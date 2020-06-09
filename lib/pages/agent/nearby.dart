import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Nearby extends StatefulWidget {
  @override
  _NearbyState createState() => _NearbyState();
}

class _NearbyState extends State<Nearby> {

  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(16.8818934, 96.1215111);
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;

  static final CameraPosition _position1 = CameraPosition(
    // bearing: 192.833,
    target: LatLng(16.8818934, 96.1215111),
    // tilt: 59.440,
    zoom: 11.0,
  );

  // Future<void> _gotoPosition1() async{
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_position1));
  // }

  _onMapCreated(GoogleMapController controller){
    _controller.complete(controller);
  }

  _onCameraMove(CameraPosition position){
    _lastMapPosition = position.target;
  }

  // _onMapTypeButtonPressed(){
  //   setState((){
  //     _currentMapType = _currentMapType == MapType.normal
  //       ? MapType.satellite
  //       : MapType.normal;
  //   });
  // }
  _onMapTypeMapButtonPressed(){
    setState((){
      _currentMapType =  MapType.normal;
    });
  }
  _onMapTypeSatelliteButtonPressed(){
    setState((){
      _currentMapType =  MapType.satellite;
    });
  }

  _onAddMarkerButtonPressed(){
    setState((){
      _markers.add(
        Marker(
          markerId: MarkerId(_lastMapPosition.toString()),
          position: _lastMapPosition,
          infoWindow: InfoWindow(
            title: 'This is a Title',
            snippet: 'This is a snippet',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }

  Widget button(Function function, IconData icon){
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: Icon(
        icon,
        size: 36.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: new Text('Near by')),
        actions: <Widget>[
          PopupMenuButton<CustomPopupMenu>(
            child: new Padding(
              padding: const EdgeInsets.all(15.0),
              child: Image.asset('assets/images/filter.png',color: Color.fromRGBO(37, 37, 161, 1)),
            ),

            elevation: 3.2,
            itemBuilder: (BuildContext context) {
              return choices.map((CustomPopupMenu choice) {
                return PopupMenuItem<CustomPopupMenu>(
                  value: choice,
                  child: Row(
                    children: <Widget>[
                      Icon(choice.icon, color: choice.color,),
                      Text(choice.title),
                    ],
                  ),
                );
              }).toList();
            },
          )

        ],
      ),
      body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 17.0,
              ),
              mapType: _currentMapType,
              markers: _markers,
              onCameraMove: _onCameraMove,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                 children: <Widget>[
                  // button(_onMapTypeMapButtonPressed, Icons.map),
                  Row(children: <Widget>[
                     RaisedButton(child: Text("Map"),
                onPressed: _onMapTypeMapButtonPressed,
                color: Colors.white,
                textColor: Colors.black,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              ),
              RaisedButton(child: Text("Satellite"),
                onPressed: _onMapTypeSatelliteButtonPressed,
                color: Colors.white,
                textColor: Colors.black,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              ),
                  ],),
                 ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                onPressed: _onAddMarkerButtonPressed,
                child: Icon(Icons.location_on),
              ),
              ),
            )
          ],
        ),
    );
  } 
}

 List<CustomPopupMenu> choices = <CustomPopupMenu>[
  CustomPopupMenu(title: 'All', icon: Icons.location_on, color: Colors.red),
  CustomPopupMenu(title: 'ATM', icon: Icons.location_on, color: Colors.blue),
  CustomPopupMenu(title: 'Branch', icon: Icons.location_on, color: Colors.green),
  CustomPopupMenu(title: 'Agent', icon: Icons.location_on, color: Colors.yellow),
  CustomPopupMenu(title: 'Merchant', icon: Icons.location_on, color: Colors.orange),
  ];

class CustomPopupMenu {
  String title;
  IconData icon;
  Color color;
  CustomPopupMenu({this.title, this.icon,this.color});
}


