import 'dart:async';
import 'dart:convert';
import 'package:condition/condition.dart';
import 'package:nsb/Link.dart';
import 'package:nsb/framework/http_service.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nsb/constants/constant.dart';
import 'package:nsb/global.dart';
import 'package:nsb/model/GetAccountListRequest.dart';
import 'package:nsb/model/GetAccountListResponse.dart';
import 'package:nsb/pages/Transfer/transferconfirm.dart';
import 'package:nsb/pages/agent/agentTransfer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BranchLocation extends StatefulWidget {
  final String value1;
  final String value2;
  final String value3;
  final String value4;
  final String value5;

  BranchLocation(
      {Key key,
      this.value1,
      this.value2,
      this.value3,
      this.value4,
      this.value5})
      : super(key: key);

  @override
  _BranchLocationState createState() => _BranchLocationState();
}

class _BranchLocationState extends State<BranchLocation> {
  String alertmsg = "";
  var all = [];
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  var contactList = [];
  String a;

  snackbartrue(name) {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      content: new Text(name),
      backgroundColor: colorgreen,
      duration: Duration(seconds: 2),
    ));
  }

  snackbarfalse(name) {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      content: new Text(name),
      backgroundColor: colorerror,
      duration: Duration(seconds: 2),
    ));
  }

  checkPhNoRequest() async {
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userId');
    String sessionID = prefs.getString('sessionID');
    String loginID = "+959" + "${widget.value2}".substring(2, 11);
    print(loginID);
    a = loginID;
    String url = '$link' + "/chatservice/checkPhoneNo";
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{ "userID": "' +
        userID +
        '", "sessionID": "' +
        sessionID +
        '","loginID":"' +
        loginID +
        '" }';
    http.Response response = await http
        .post(url, headers: headers, body: json)
        .catchError((Object error) {
      print(error.toString());
      snackbarfalse(error.toString());
    });
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      String body = response.body;
      print(body);
      var data = jsonDecode(body);
      setState(() {
        all = data["data"];
      });
    } else {
      print("Connection Fail");
    }
  }

  void _method1() {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
        content: new Text(this.alertmsg),
        backgroundColor: colorgreen,
        duration: Duration(seconds: 2)));
  }

  @override
  void initState() {
    super.initState();
    checkLanguage();
    checkPhNoRequest();
    _mainLocation =
        LatLng(double.parse(widget.value4), double.parse(widget.value5));
  }

  getAccountList() async {
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userId');
    String sessionID = prefs.getString('sessionID');
    GetAccountListRequest accountListRequest =
        new GetAccountListRequest(userID: userID, sessionID: sessionID);
    GetAccountListResponse accountListResponse = await getAllAddContact(
            '$link' + '/service001/getAccountList', accountListRequest.toMap())
        .catchError((Object error) {
      print(error.toString());
      snackbarfalse(error.toString());
    });
    if (accountListResponse.code == '0000') {
      this.alertmsg = accountListResponse.desc;
      // this._method1();
      checkPhNoRequest();
    } else {
      this.alertmsg = accountListResponse.desc;
      this._method1();
      final form = _formKey.currentState;
      form.validate();
    }
  }

  Future<GetAccountListResponse> getAllAddContact(url, Map jsonMap) async {
    GetAccountListResponse p = new GetAccountListResponse();
    var body;
    try {
      body = await http.doPost(url, jsonMap);
      p = GetAccountListResponse.fromJson(json.decode(body.toString()));
      var data = jsonDecode(body);
      setState(() {
        contactList = data["accountList"];
      });
    } catch (e) {
      p.code = Constants.responseCode_Error;
      p.desc = e.toString();
    }
    print(p.toMap());
    return p;
  }

  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(16.8818934, 96.1215111);
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;
  String checklang = '';
  List textMyan = ["တည်နေရာ", "ငွေလွှဲရန်"];
  List textEng = ["Location", "Transfer"];
  LatLng _mainLocation;
  GoogleMapController myMapController;

  // static final CameraPosition _position1 = CameraPosition(
  //   // bearing: 192.833,
  //   target: LatLng(16.8818934, 96.1215111),
  //   // tilt: 59.440,
  //   zoom: 11.0,
  // );

  // Future<void> _gotoPosition1() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_position1));
  // }

  // _onMapCreated(GoogleMapController controller) {
  //   _controller.complete(controller);
  // }

  // _onCameraMove(CameraPosition position) {
  //   _lastMapPosition = position.target;
  // }

  // // _onMapTypeButtonPressed(){
  // //   setState((){
  // //     _currentMapType = _currentMapType == MapType.normal
  // //       ? MapType.satellite
  // //       : MapType.normal;
  // //   });
  // // }

  // _onMapTypeMapButtonPressed() {
  //   setState(() {
  //     _currentMapType = MapType.normal;
  //   });
  // }

  // _onMapTypeSatelliteButtonPressed() {
  //   setState(() {
  //     _currentMapType = MapType.satellite;
  //   });
  // }

  // _onAddMarkerButtonPressed() {
  //   setState(() {
  //     _markers.add(
  //       Marker(
  //         markerId: MarkerId(_lastMapPosition.toString()),
  //         position: _lastMapPosition,
  //         infoWindow: InfoWindow(
  //           title: 'This is a Title',
  //           snippet: 'This is a snippet',
  //         ),
  //         icon: BitmapDescriptor.defaultMarker,
  //       ),
  //     );
  //   });
  // }

  checkLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    checklang = prefs.getString("Lang");
    // print(lang);
    if (checklang == "" || checklang == null || checklang.length == 0) {
      checklang = "Eng";
    } else {
      checklang = checklang;
    }
    setState(() {});
  }

  // Widget button(Function function, IconData icon) {
  //   return FloatingActionButton(
  //     onPressed: function,
  //     materialTapTargetSize: MaterialTapTargetSize.padded,
  //     backgroundColor: Colors.blue,
  //     child: Icon(
  //       icon,
  //       size: 36.0,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        centerTitle: true,
        title: (checklang == "Eng")
            ? Text(
                (checklang == "Eng") ? textEng[0] : textMyan[0],
                style: TextStyle(
                    fontSize: 19,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              )
            : Text(
                (checklang == "Eng") ? textEng[0] : textMyan[0],
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
        backgroundColor: colorgreen,
      ),
      body: Container(
        // color: bgcolor,
        child: SingleChildScrollView(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.65,
              //   child: Stack(
              //     children: <Widget>[
              //       GoogleMap(
              //         onMapCreated: _onMapCreated,
              //         initialCameraPosition: CameraPosition(
              //           target: _center,
              //           zoom: 17.0,
              //         ),
              //         mapType: _currentMapType,
              //         markers: _markers,
              //         onCameraMove: _onCameraMove,
              //       ),
              //       Padding(
              //         padding: EdgeInsets.all(16.0),
              //         child: Align(
              //           alignment: Alignment.topRight,
              //           child: Column(
              //             children: <Widget>[
              //               // button(_onMapTypeButtonPressed, Icons.map),
              //               Row(
              //                 children: <Widget>[
              //                   RaisedButton(
              //                     child: Text("Map"),
              //                     onPressed: _onMapTypeMapButtonPressed,
              //                     color: Colors.white,
              //                     textColor: Colors.black,
              //                     padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              //                   ),
              //                   RaisedButton(
              //                     child: Text("Satellite"),
              //                     onPressed: _onMapTypeSatelliteButtonPressed,
              //                     color: Colors.white,
              //                     textColor: Colors.black,
              //                     padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              //                   ),
              //                   SizedBox(
              //                     height: 16.0,
              //                   ),
              //                   // button(_onAddMarkerButtonPressed, Icons.add_location),
              //                   SizedBox(
              //                     height: 16.0,
              //                   ),
              //                   // button(_gotoPosition1, Icons.location_searching),
              //                 ],
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(16.0),
              //         child: Align(
              //           alignment: Alignment.bottomRight,
              //           child: FloatingActionButton(
              //             onPressed: _onAddMarkerButtonPressed,
              //             child: Icon(Icons.location_on),
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // ),

              Container(
                height: 450,
                width: MediaQuery.of(context).size.width * 90,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _mainLocation,
                    zoom: 18.0,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId(widget.value1.toString()),
                      position: _mainLocation,
                      infoWindow: InfoWindow(
                        title: widget.value1.toString(),
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
              SizedBox(
                // height: MediaQuery.of(context).size.height * 0.25,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Text('Name:'),
                                Padding(
                                  padding: const EdgeInsets.only(left: 80.0),
                                  child: Container(
                                      width: 200,
                                      child: Text(
                                        "${widget.value1}",
                                        overflow: TextOverflow.visible,
                                        softWrap: true,
                                      )),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Text('Phone No:'),
                                Padding(
                                  padding: const EdgeInsets.only(left: 56.0),
                                  child: Text("${widget.value2}"),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Text('Address:'),
                                Padding(
                                  padding: const EdgeInsets.only(left: 66.0),
                                  child: Container(
                                      width: 200,
                                      child: Text(
                                        "${widget.value3}",
                                        overflow: TextOverflow.visible,
                                        softWrap: true,
                                      )),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.80,
                                  height: 43.0,
                                  child: RaisedButton(
                                    splashColor: colorblack,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    onPressed: () {
                                      getAccountList();
                                      var route = new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              new AgentTransfer(
                                                  value1: a,
                                                  value2: "${widget.value1}"));
                                      Navigator.of(context).push(route);
                                    },
                                    child: (checklang == "Eng")
                                        ? Text(
                                            (checklang == "Eng")
                                                ? textEng[1]
                                                : textMyan[1],
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white),
                                          )
                                        : Text(
                                            (checklang == "Eng")
                                                ? textEng[1]
                                                : textMyan[1],
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                    color: colorgreen,
                                    textColor: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
