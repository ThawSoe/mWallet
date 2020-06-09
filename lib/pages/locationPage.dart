import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:nsb/Link.dart';
import 'package:nsb/global.dart';
import 'package:nsb/pages/LocationDetail.dart';
import 'package:nsb/pages/Transaction/TransitionMain.dart';
import 'package:nsb/pages/locationview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class locationPage extends StatefulWidget {
  locationPage();
  @override
  _locationPageState createState() => _locationPageState();
}

class _locationPageState extends State<locationPage> {
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  final Set<Marker> _markers = {};

  LatLng _lastMapPosition = _center;

  MapType _currentMapType = MapType.normal;
  bool isLoading = false;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: 'Really cool place',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  var location = new Location();
  Map<String, double> userLocation;
  List ALLDataList = new List();
  List ATMDataList = new List();
  List agentDataList = new List();
  List branchDataList = new List();
  bool connection = false;
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  List merchantDataList = new List();
  String checklang = '';
  var data;
  List textMyan = ["တည်နေရာ"];
  List textEng = ["Location"];
  var locationList = [];

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

  void initState() {
    checkLanguage();
    super.initState();
    CheckConnection();
  }

  CheckConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      connection = false;
      setState(() {});
      getLocation();
    } else {
      connection = true;
      snackbarfalse("No Internet Connection !");
    }
  }

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

  getLocation() async {
    isLoading = true;
    try {
      String url = '$link'
          "/service002/getLocation";
      Map<String, String> headers = {"Content-type": "application/json"};
      String json = '{ "userID": "", "sessionID": "" }';
      http.Response response = await http
          .post(url, headers: headers, body: json)
          .catchError((Object error) {
        print(error.toString());
        snackbarfalse(error.toString());
      });
      int statusCode = response.statusCode;
      if (statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        String body = utf8.decode(response.bodyBytes);
        print(body);
        data = jsonDecode(body);
        // snackbartrue(data['desc']);
        try {
          setState(() {
            locationList = data["data"];
          });
        } catch (error) {
          snackbarfalse(error.toString());
          // executed for errors of all types other than Exception
        }
      } else {
        print("Connection Fail");
        snackbarfalse(data['desc']);
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      snackbarfalse(error.toString());
      // executed for errors of all types other than Exception
    }
  }

  Widget build(BuildContext context) {
    void _launchMapsUrl(String lat, String lon) async {
      final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    Future<Map<String, double>> _getLocation() async {
      var currentLocation = <String, double>{};
      try {
        currentLocation = (await location.getLocation()) as Map<String, double>;
      } catch (e) {
        currentLocation = null;
      }
      return currentLocation;
    }

    print(locationList.length);
    for (var dataLoop = 0; dataLoop < locationList.length; dataLoop++) {
      if (locationList[dataLoop]["locationType"] == "ATM") {
        ATMDataList = locationList[dataLoop]["dataList"];
      } else if (locationList[dataLoop]["locationType"] == "Branch") {
        branchDataList = locationList[dataLoop]["dataList"];
      } else if (locationList[dataLoop]["locationType"] == "Agent") {
        agentDataList = locationList[dataLoop]["dataList"];
      } else if (locationList[dataLoop]["locationType"] == "Merchant") {
        merchantDataList = locationList[dataLoop]["dataList"];
      }
    }
    ALLDataList =
        ATMDataList + branchDataList + agentDataList + merchantDataList;

    var connectionfail = new Container(
      width: MediaQuery.of(context).size.width * 0.99,
      height: MediaQuery.of(context).size.height * 0.99,
      child: GestureDetector(
        onTap: () {
          CheckConnection();
        },
        child: Center(
          child: Image.asset('assets/images/connection.jpg',
              width: MediaQuery.of(context).size.width * 0.99,
              height: MediaQuery.of(context).size.height * 0.99),
        ),
      ),
    );

    var locationbody = TabBarView(key: _formKey, children: [
      ListView.builder(
          itemCount: ALLDataList.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Column(
              children: <Widget>[
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  title: Text(
                    ALLDataList[index]["name"] + '\n',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 15),
                  ),
                  subtitle: Text(
                    // "\nTelephone : " +
                    ALLDataList[index]["phone1"],
                    //+ "\n\nAddress : " +
                    // ALLDataList[index]["address"],
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w300),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.keyboard_arrow_right, color: colorgreen),
                    onPressed: () {
                      // launch('tel:' + ALLDataList[index]["phone1"]);
                    },
                  ),
                  onTap: () {
                    // _launchMapsUrl(ALLDataList[index]["latitude"],
                    //     ALLDataList[index]["longitude"]);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LocationView(
                                name: ALLDataList[index]["name"],
                                phno: ALLDataList[index]["phone1"],
                                address: ALLDataList[index]["address"],
                                lat: ALLDataList[index]["latitude"],
                                long: ALLDataList[index]["longitude"])));
                  },
                ),
                Divider(
                  height: 0.1,
                  color: Colors.blue,
                  indent: 20,
                  endIndent: 20,
                )
              ],
            );
          }),
      ListView.builder(
          itemCount: ATMDataList.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Column(
              children: <Widget>[
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  title: Text(
                    ATMDataList[index]["name"] + '\n',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 15),
                  ),
                  subtitle: Text(
                    // "\nTelephone : " +
                    ATMDataList[index]["phone1"],
                    // "\n\nAddress : " +
                    // ATMDataList[index]["address"],
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w300),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.keyboard_arrow_right, color: colorgreen),
                    onPressed: () {
                      // launch('tel:' + ATMDataList[index]["phone1"]);
                    },
                  ),
                  onTap: () {
                    // _launchMapsUrl(ATMDataList[index]["latitude"],
                    //     ATMDataList[index]["longitude"]);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LocationView(
                                name: ATMDataList[index]["name"],
                                phno: ATMDataList[index]["phone1"],
                                address: ATMDataList[index]["address"],
                                lat: ATMDataList[index]["latitude"],
                                long: ATMDataList[index]["longitude"])));
                  },
                ),
                Divider(
                  height: 0.1,
                  color: Colors.blue,
                  indent: 20,
                  endIndent: 20,
                )
              ],
            );
          }),
      ListView.builder(
          itemCount: branchDataList.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Column(
              children: <Widget>[
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  title: Text(
                    branchDataList[index]["name"] + '\n',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 15),
                  ),
                  subtitle: Text(
                    // "\nTelephone : " +
                    branchDataList[index]["phone1"],
                    // +"\n\nAddress : " +
                    // branchDataList[index]["address"],
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w300),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.keyboard_arrow_right, color: colorgreen),
                    onPressed: () {
                      // launch('tel:' + branchDataList[index]["phone1"]);
                    },
                  ),
                  onTap: () {
                    // _launchMapsUrl(branchDataList[index]["latitude"],
                    //     branchDataList[index]["longitude"]);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LocationView(
                                name: branchDataList[index]["name"],
                                phno: branchDataList[index]["phone1"],
                                address: branchDataList[index]["address"],
                                lat: branchDataList[index]["latitude"],
                                long: branchDataList[index]["longitude"])));
                  },
                ),
                Divider(
                  height: 0.1,
                  color: Colors.blue,
                  indent: 20,
                  endIndent: 20,
                )
              ],
            );
          }),
      ListView.builder(
          itemCount: agentDataList.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Column(
              children: <Widget>[
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  title: Text(
                    agentDataList[index]["name"] + '\n',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 15),
                  ),
                  subtitle: Text(
                    // "\nTelephone : " +
                    agentDataList[index]["phone1"],
                    // +"\n\nAddress : " +
                    // agentDataList[index]["address"],
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w300),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.keyboard_arrow_right, color: colorgreen),
                    onPressed: () {
                      // launch('tel:' + agentDataList[index]["phone1"]);
                    },
                  ),
                  onTap: () {
                    // _launchMapsUrl(agentDataList[index]["latitude"],
                    //     agentDataList[index]["longitude"]);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LocationView(
                                name: agentDataList[index]["name"],
                                phno: agentDataList[index]["phone1"],
                                address: agentDataList[index]["address"],
                                lat: agentDataList[index]["latitude"],
                                long: agentDataList[index]["longitude"])));
                  },
                ),
                Divider(
                  height: 0.1,
                  color: Colors.blue,
                  indent: 20,
                  endIndent: 20,
                )
              ],
            );
          }),
      ListView.builder(
          itemCount: merchantDataList.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Column(
              children: <Widget>[
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  title: Text(
                    merchantDataList[index]["name"] + '\n',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 15),
                  ),
                  subtitle: Text(
                    // "\nTelephone : " +
                    merchantDataList[index]["phone1"],
                    // +"\n\nAddress : " +
                    // merchantDataList[index]["address"],
                    style: TextStyle(color: Colors.black),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.keyboard_arrow_right, color: colorgreen),
                    onPressed: () {
                      // launch('tel:' + merchantDataList[index]["phone1"]);
                    },
                  ),
                  onTap: () {
                    // _launchMapsUrl(merchantDataList[index]["latitude"],
                    //     merchantDataList[index]["longitude"]);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LocationView(
                                name: merchantDataList[index]["name"],
                                phno: merchantDataList[index]["phone1"],
                                address: merchantDataList[index]["address"],
                                lat: merchantDataList[index]["latitude"],
                                long: merchantDataList[index]["longitude"])));
                  },
                ),
                Divider(
                  height: 0.1,
                  color: Colors.blue,
                  indent: 20,
                  endIndent: 20,
                )
              ],
            );
          }),
    ]);

    var bodyProgress = new Container(
      child: new Stack(
        children: <Widget>[
          locationbody,
          Container(
              decoration: new BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.5),
              ),
              width: MediaQuery.of(context).size.width * 0.99,
              height: MediaQuery.of(context).size.height * 0.9,
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: colorgreen,
                ),
              ))
        ],
      ),
    );

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
            length: 5,
            child: Scaffold(
                key: _scaffoldkey,
                backgroundColor: Colors.white,
                appBar: AppBar(
                  bottom: TabBar(
                    isScrollable: true,
                    indicatorWeight: 2,
                    indicatorColor: colorblack,
                    labelColor: colorblack,
                    unselectedLabelColor: Colors.white,
                    tabs: [
                      Tab(
                          child: Text("ALL",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w400))),
                      Tab(
                          child: Text("ATM",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w400))),
                      Tab(
                          child: Text("BRANCH",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w400))),
                      Tab(
                          child: Text("AGENT",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w400))),
                      Tab(
                          child: Text("MERCHANT",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w400))),
                    ],
                  ),
                  leading: new IconButton(
                      icon: new Icon(Icons.arrow_back),
                      // color: Colors.indigo,
                      disabledColor: Colors.indigo,
                      onPressed: () => Navigator.of(context).pop()),
                  backgroundColor: colorgreen,
                  title: (checklang == "Eng")
                      ? Text(
                          (checklang == "Eng") ? textEng[0] : textMyan[0],
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.w500),
                        )
                      : Text(
                          (checklang == "Eng") ? textEng[0] : textMyan[0],
                          style: TextStyle(fontSize: 18),
                        ),
                  centerTitle: true,
                  actions: <Widget>[
                    new IconButton(
                        icon: Image.asset("assets/images/map.png"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LocationDetail()),
                          );
                        }),
                  ],
                ),
                body: connection
                    ? connectionfail
                    : isLoading ? bodyProgress : locationbody)));
  }
}
