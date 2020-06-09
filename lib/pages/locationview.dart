import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nsb/global.dart';

class LocationView extends StatefulWidget {
  final String name;
  final String phno;
  final String address;
  final String lat;
  final String long;

  LocationView(
      {Key key, this.name, this.phno, this.address, this.lat, this.long})
      : super(key: key);

  @override
  _LocationViewState createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  LatLng _mainLocation;
  GoogleMapController myMapController;

  @override
  void initState() {
    super.initState();
    print(
        widget.name + widget.address + widget.phno + widget.lat + widget.long);
    _mainLocation = LatLng(double.parse(widget.lat), double.parse(widget.long));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Container(
      color: bgcolor,
      child: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: 500,
                width: MediaQuery.of(context).size.width * 90,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _mainLocation,
                    zoom: 18.0,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId(widget.name.toString()),
                      position: _mainLocation,
                      infoWindow: InfoWindow(
                        title: widget.name.toString(),
                      ),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueRed),
                    )
                  },
                  mapType: MapType.satellite,
                  onMapCreated: (controller) {
                    setState(() {
                      myMapController = controller;
                    });
                  },
                ),
              ),
              Divider(
                height: 30,
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 5.0,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  30.0, 0.0, 0.0, 0.0),
                              child: Text("Name :"),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  90.0, 0.0, 0.0, 0.0),
                              child: Container(
                                  width: 200,
                                  child: Text(
                                    widget.name,
                                    overflow: TextOverflow.visible,
                                    softWrap: true,
                                  )),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  30.0, 0.0, 0.0, 0.0),
                              child: Text("Phone No :"),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  70.0, 0.0, 0.0, 0.0),
                              child: Container(
                                  child: Text(
                                widget.phno,
                                overflow: TextOverflow.visible,
                                softWrap: true,
                              )),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  30.0, 0.0, 0.0, 0.0),
                              child: Text("Address :"),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  80.0, 0.0, 0.0, 0.0),
                              child: Container(
                                  width: 200,
                                  child: Text(
                                    widget.address,
                                    overflow: TextOverflow.visible,
                                    softWrap: true,
                                  )),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    ));
  }
}
