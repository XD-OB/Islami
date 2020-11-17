import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'languages.dart' show map;
import 'dart:math' show min;
import 'consts.dart';

class MapScreen extends StatefulWidget {
  final     language;

  MapScreen({
    this.language
  });

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

  void _currentLocation() async {
   final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: CAM_BEARING,
        target: LatLng(position.latitude, position.longitude),
        zoom: CAM_ZOOM,
      ),
    ));
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
          myLocationButtonEnabled: false,
          tiltGesturesEnabled: true,
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
          onTap: _handleTap,
          markers: Set<Marker>.of(markers.values),
          polylines: Set<Polyline>.of(polylines.values),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: FloatingActionButton.extended(
            backgroundColor: Color(GreenyBarid),
            onPressed: _currentLocation,
            label: Text(map[widget.language]),
            icon: Icon(Icons.gps_fixed),
          ),
        ),
      ],
    );
  }
}