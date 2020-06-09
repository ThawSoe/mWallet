import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:nsb/Link.dart';
import 'package:nsb/global.dart';
import 'package:nsb/pages/LocationDetail.dart';
import 'package:nsb/pages/Transaction/TransitionMain.dart';
import 'package:nsb/pages/agent/branchlocation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AgentPage extends StatefulWidget {
  final String value1;
  final String value2;
  final String value3;

  AgentPage({
    Key key,
    this.value1,
    Key key1,
    this.value2,
    Key key2,
    this.value3,
  }) : super(key: key);

  @override
  _AgentPageState createState() => _AgentPageState();
}

class _AgentPageState extends State<AgentPage> {
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  String alertmsg = "";
  bool isLoading = false;
  var location = new Location();
  Map<String, double> userLocation;

  List agentDataList = new List();
  TextEditingController controller = new TextEditingController();
  String checklang = '';
  List textMyan = ["ကိုယ်စားလှယ်"];
  List textEng = ["Agent"];
  List locationList = [];
  List searchList = [];
  List agentList = [];
  void initState() {
    checkLanguage();
    super.initState();
    getLocation();
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

  checkLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    checklang = prefs.getString("Lang");
    if (checklang == "" || checklang == null || checklang.length == 0) {
      checklang = "Eng";
    } else {
      checklang = checklang;
    }
    setState(() {});
  }

  getLocation() async {
    isLoading = true;
    String url = '$link' + "/service002/getLocation";
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
      isLoading = false;
      String body = response.body;
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      print(data);
      if (data["code"] == "0000") {
        setState(() {
          locationList = data["data"];
        });
      } else {
        isLoading = false;
        snackbarfalse(data["desc"]);
      }
    } else {
      isLoading = false;
      print("Connection Fail");
    }
  }

  Widget build(BuildContext context) {
    for (var dataLoop = 0; dataLoop < locationList.length; dataLoop++) {
      if (locationList[dataLoop]["locationType"] == "Agent") {
        agentDataList = locationList[dataLoop]["dataList"];
        for (var a = 0; a < agentDataList.length; a++) {
          agentList.add(agentDataList[a]["name"]);
        }
        setState(() {});
      }
    }

    var agentbody = new Container(
      key: _scaffoldkey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: new TextField(
                  onChanged: onSearchResult,
                  controller: controller,
                  decoration: InputDecoration(
                    icon: new Icon(Icons.search),
                    hintText: 'Search',
                    focusedBorder: InputBorder.none,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: (controller.text.isEmpty || searchList.length == null)
                  ? ListView.builder(
                      itemCount: agentDataList.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return Column(
                          children: <Widget>[
                            ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
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
                                // branchDataList[index]["address"],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.keyboard_arrow_right,
                                    color: colorgreen),
                                onPressed: () {
                                  // launch('tel:' + branchDataList[index]["phone1"]);
                                },
                              ),
                              onTap: () {
                                // _launchMapsUrl(agentDataList[index]["latitude"],agentDataList[index]["longitude"]);
                                var route = new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        new BranchLocation(
                                          value1: agentDataList[index]["name"],
                                          value2: agentDataList[index]
                                              ["phone1"],
                                          value3: agentDataList[index]
                                              ["address"],
                                          value4: agentDataList[index]
                                              ["latitude"],
                                          value5: agentDataList[index]
                                              ["longitude"],
                                        ));
                                Navigator.of(context).push(route);
                                print(Text("AgentBranch"));
                              },
                            ),
                            Divider(
                              height: 2,
                              color: Colors.blue,
                              indent: 20,
                              endIndent: 20,
                            )
                          ],
                        );
                      })
                  : ListView.builder(
                      itemCount: searchList.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return Column(
                          children: <Widget>[
                            ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              title: Text(
                                searchList[index]["name"],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "\nTelephone : " +
                                    searchList[index]["phone1"] +
                                    "\n\nAddress : " +
                                    searchList[index]["address"],
                                style: TextStyle(color: Colors.black),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.phone, color: Colors.indigo),
                                onPressed: () {
                                  launch('tel:' + searchList[index]["phone1"]);
                                },
                              ),
                              onTap: () {
                                // _launchMapsUrl(agentDataList[index]["latitude"],agentDataList[index]["longitude"]);
                                var route = new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        new BranchLocation(
                                          value1: searchList[index]["name"],
                                          value2: searchList[index]["phone1"],
                                          value3: searchList[index]["address"],
                                          value4: agentDataList[index]
                                              ["latitude"],
                                          value5: agentDataList[index]
                                              ["longitude"],
                                        ));
                                Navigator.of(context).push(route);
                                print(Text("AgentBranch"));
                              },
                            ),
                            Divider(
                              height: 2,
                              color: Colors.blue,
                              indent: 20,
                              endIndent: 20,
                            )
                          ],
                        );
                      }),
            ),
          ),
        ],
      ),
    );

    var bodyProgress = new Container(
      child: new Stack(
        children: <Widget>[
          agentbody,
          Container(
              decoration: new BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.5),
              ),
              width: MediaQuery.of(context).size.width * 0.99,
              height: MediaQuery.of(context).size.height * 0.9,
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.amber,
                ),
              ))
        ],
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          key: _formKey,
          appBar: AppBar(
            leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                disabledColor: Colors.indigo,
                onPressed: () => Navigator.of(context).pop()),
            backgroundColor: colorgreen,
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
            centerTitle: true,
            actions: <Widget>[
              new IconButton(
                  icon: Image.asset("assets/images/map.png"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LocationDetail()),
                    );
                  }),
            ],
          ),
          body: isLoading ? bodyProgress : agentbody),
    );
  }

  onSearchResult(String text) async {
    searchList.clear();
    // text = text.toLowerCase();
    if (text.isNotEmpty) {
      for (var a = 0; a < agentDataList.length; a++) {
        if (agentDataList[a]["name"].contains(text)) {
          searchList.add(agentDataList[a]);
          print("sarchlist ==>  $searchList");
        }
      }
      setState(() {});
    }
  }
}
