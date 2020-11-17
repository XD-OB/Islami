import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/services.dart' show rootBundle;
import './consts.dart';

class MapScreen extends StatefulWidget {

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController>  _controller = Completer();
  Geolocator                      geolocator = Geolocator();
  String                          _mapStyle;
  Position                        position;
  Position                        _beginPosition;
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
    updateLocation();
    rootBundle.loadString('assets/mapStyle/retroMode.txt').then((string) {
      _mapStyle = string;
    });
  }

  void    _createPolylines(LatLng start, LatLng destination) async {
    // Initializing PolylinePoints
    polylinePoints = PolylinePoints();

    // Generating the list of coordinates to be used for
    // drawing the polylines
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GM_API_KEY, // Google Maps API Key 
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.transit,
    );

    print(GM_API_KEY);

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

  void updateLocation() async {
    try {
      Geolocator.getPositionStream().listen((Position newPosition) {
        setState(() {
          position = newPosition;
          if (position != null)
            updateLocationMarker();
        });
      });
    } catch (e) {
      print(e);
    }
  }

  void  _handleTap(LatLng tapPt) {
    setState(() {
      markers['p2'] = Marker(
        markerId: MarkerId(tapPt.toString()),
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

    @override
    Widget build(BuildContext context) {
      return StreamBuilder(
      stream: Geolocator.getPositionStream(),
      builder: (_, AsyncSnapshot<Position> newPosition) {
        if (newPosition.connectionState == ConnectionState.waiting)
          return  SpinKitRipple(
                    color: Color(GreenyBarid),
                    size: 50.0,
                  );
      if (position == null)
        return Text('hgfhfghfghfg');
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
                    _beginPosition.latitude,
                    _beginPosition.longitude,
                  ),
                  zoom: 16,
                  bearing: 15.0,
                  tilt: 30.0,
                ),
                mapType: MapType.normal,
                onTap: _handleTap,
                markers: Set<Marker>.of(markers.values),
                polylines: Set<Polyline>.of(polylines.values),
              ),
            ],
        );
      }
      );
    }
  }