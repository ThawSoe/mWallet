import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationDetail extends StatefulWidget {
  @override
  _TransactionDetailState createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<LocationDetail> {
  List<Marker> allMarkers = [];

  GoogleMapController _controller;

  @override
  void initState() {
    super.initState();
    allMarkers.add(Marker(
        markerId: MarkerId('myMarker'),
        draggable: true,
        infoWindow: InfoWindow(title: "Current Loaction"),
        // onTap: () {
        //   print('Marker Tapped');
        // },
        position: LatLng(16.8818553, 96.1216076)));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(40, 103, 178, 1),
        title: Text("Near by"),
        centerTitle: true,
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
        children: [Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            initialCameraPosition:
                CameraPosition(target: LatLng(16.8818553, 96.1216076), zoom: 18.0),
            markers: Set.from(allMarkers),
            onMapCreated: mapCreated,
          ),
        ),
        // Align(
        //   alignment: Alignment.bottomCenter,
        //   child: InkWell(
        //     onTap: movetoBoston,
        //     child: Container(
        //       height: 40.0,
        //       width: 40.0,
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(20.0),
        //         color: Colors.green
        //       ),
        //       child: Icon(Icons.forward, color: Colors.white),
        //     ),
        //   ),
        // ),
        // Align(
        //   alignment: Alignment.bottomRight,
        //   child: InkWell(
        //     onTap: movetoNewYork,
        //     child: Container(
        //       height: 40.0,
        //       width: 40.0,
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(20.0),
        //         color: Colors.red
        //       ),
        //       child: Icon(Icons.backspace, color: Colors.white),
        //     ),
        //   ),
        // )
        ]
      ),
      floatingActionButton: FloatingActionButton(
      onPressed: () {
        myLocation();
      },
      child: Icon(Icons.location_on),
      backgroundColor: Color.fromRGBO(40, 103, 178, 1),
    ),
    );
  }
   void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  // movetoBoston() {
  //   _controller.animateCamera(CameraUpdate.newCameraPosition(
  //     CameraPosition(target: LatLng(16.8818553, 96.1216076), zoom: 14.0, bearing: 45.0, tilt: 45.0),
  //   ));
  // }

  myLocation() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(16.8818553, 96.1216076), zoom: 18.0),
    ));
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
