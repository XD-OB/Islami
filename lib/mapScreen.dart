import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/services.dart' show rootBundle;
import './consts.dart';

class MapScreen extends StatefulWidget {
  final Position oldPosition;

  MapScreen({this.oldPosition});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController>  _controller = Completer();
  Geolocator                      geolocator = Geolocator();
  String                          _mapStyle;
  Position                        position;
  Position                        _beginPosition;
  Map<String, Marker>             markers = {};
  List<Polyline>                  _polyLines = [];

  @override
  void initState() {
    super.initState();
    position = widget.oldPosition;
    _beginPosition = position;
    if (position != null)
      updateLocationMarker();
    rootBundle.loadString('assets/mapStyle/retroMode.txt').then((string) {
      _mapStyle = string;
    });
    updateLocation();
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
          title: 'My Location',
        ),
      );
    });
  }

  void updateLocation() async {
    try {
      Geolocator.getPositionStream().listen((Position newPosition) {
        setState(() {
          position = newPosition;
          updateLocationMarker();
        });
      });
      if (_beginPosition == null)
        _beginPosition = position;
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
        _polyLines.add(Polyline(
        polylineId: PolylineId("route"),
        color: Colors.blue,
        patterns: [
          PatternItem.dash(20.0),
          PatternItem.gap(10)
        ],
        width: 3,
        points: [
          markers['myLocation'].position,
          markers['p2'].position,
        ],
      ));
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
                    _beginPosition == null ? 34.0477 : _beginPosition.latitude,
                    _beginPosition == null ? -6.8181 : _beginPosition.longitude,
                  ),
                  zoom: 16,
                  bearing: 15.0,
                  tilt: 30.0,
                ),
                mapType: MapType.normal,
                onTap: _handleTap,
                markers: Set<Marker>.of(markers.values),
                polylines: _polyLines.toSet(),
              ),
            ],
        );
      }
      );
    }
  }