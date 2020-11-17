import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math' show min, cos, sqrt, asin;
import 'consts.dart';

double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
}

class MapScreen extends StatefulWidget {

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController>  _controller = Completer();
  Geolocator                      geolocator = Geolocator();
  String                          _mapStyle;
  Position                        position;
  // Object for PolylinePoints
  PolylinePoints                  polylinePoints;
  // List of coordinates to join
  List<LatLng>                    polylineCoordinates = [];
  // Map storing polylines created by connecting 2 points
  Map<PolylineId, Polyline>       polylines = {};
  Map<String, Marker>             markers = {};

  @override
  void    initState() {
    super.initState();
    getLocation();
    rootBundle.loadString('assets/mapStyle/retroMode.txt').then((string) {
      _mapStyle = string;
    });
  }

  void    _createPolylines(LatLng start, LatLng destination) async {
    // Initializing PolylinePoints
    polylinePoints = PolylinePoints();
    double totalDistance = 0.0;

    // Generating the list of coordinates to be used for
    // drawing the polylines
    PolylineResult result = await polylinePoints?.getRouteBetweenCoordinates(
      GM_API_KEY, // Google Maps API Key 
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.driving,
    );

    print(result.points);

    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    // Defining an ID
    PolylineId id = PolylineId('poly');

    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );

    // Adding the polyline to the map
    polylines[id] = polyline;
    
    // Calculating the total distance by adding the distance
    // between small segments
    for (int i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += _coordinateDistance(
        polylineCoordinates[i].latitude,
        polylineCoordinates[i].longitude,
        polylineCoordinates[i + 1].latitude,
        polylineCoordinates[i + 1].longitude,
      );
    }

    // Storing the calculated total distance of the route
    setState(() {
      print('DISTANCE: ${totalDistance.toStringAsFixed(2)} km');
    });

}

  void    updateLocationMarker() async {
    setState(() {
      markers['myLocation'] = Marker(
        markerId: MarkerId('myLocation'),
        position: LatLng(
          position.latitude,
          position.longitude,
        ),
        infoWindow: InfoWindow(
          title: 'موقعي',
        ),
      );
    });
  }

  // Get Location
  void      getLocation() async {
  bool   geolocationOn = await Geolocator.isLocationServiceEnabled();

    if(geolocationOn) {
      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        ).timeout(Duration(seconds: 5));                                ///////
      } catch(e) {
        position = await Geolocator.getLastKnownPosition(
        ).timeout(Duration(seconds: 5));
        print(e);
      }
      updateLocation();
    }
  }

  // update the position with a stream listen
  void      updateLocation() async {
    try {
      Geolocator.getPositionStream().listen((Position newPosition) {
        setState(() {
          position = newPosition;
          if (position != null)
            updateLocationMarker();
        });
      });
    } catch(e) {
      print(e);
    }
  }

  // Handle Tap Event in Map
  void  _handleTap(LatLng tapPt) {
    setState(() {
      markers['p2'] = Marker(
        markerId: MarkerId(tapPt.toString()),
        icon: BitmapDescriptor.defaultMarkerWithHue(120),
        position: tapPt,
        draggable: true,
        onDragEnd: (DragEndPosition) {
          _handleTap(DragEndPosition);
        }
      );
      if (markers['myLocation'] != null) {
        _createPolylines(markers['myLocation'].position , markers['p2'].position);
      }
    });
  }

  // Loading position widget
    Widget    widget_loading_position(screenSize) {
      return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget> [
              SpinKitRipple(
                color: Color(GreenyBarid),
                size: 2 * min(screenSize.width, screenSize.height) / 3,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  Text(
                    'محاولة لتحديد موقعك الجغرافي',
                    style: titleStyle,
                  ),
                  Text('يرجى الانتظار'),
                ],
              ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    // Size of device screen:
    final Size    screenSize = MediaQuery.of(context).size;

    if (position == null)
      return widget_loading_position(screenSize);
    return Stack(
      children: <Widget>[
        GoogleMap(
          compassEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            controller.setMapStyle(_mapStyle);
            _controller.complete(controller);
          },
          initialCameraPosition: CameraPosition(
            target: LatLng(
              position.latitude,
              position.longitude,
            ),
            zoom: CAM_ZOOM,
            bearing: CAM_BEARING,
            tilt: CAM_TILT,
          ),
          mapType: MapType.normal,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          tiltGesturesEnabled: true,
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
          onTap: _handleTap,
          markers: Set<Marker>.of(markers.values),
          polylines: Set<Polyline>.of(polylines.values),
        ),
      ],
    );
  }
}