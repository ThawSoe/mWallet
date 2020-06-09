import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nsb/Link.dart';
import 'package:nsb/global.dart';
import 'package:nsb/pages/MPT/mpt.dart';
import 'package:nsb/pages/MeterBill/meterBill.dart';
import 'package:nsb/pages/UtilityPayment/UtilityPayment.dart';
import 'package:nsb/pages/Wallet.dart';
import 'package:nsb/pages/skyNet/skynetPage.dart';
import 'package:nsb/pages/skyNetTest/Skynet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:condition/condition.dart';

class billTabPage extends StatefulWidget {
  @override
  _billTabPageState createState() => _billTabPageState();
}

class _billTabPageState extends State<billTabPage> {
  String user;
  var contactList = [];
  String id;
  String checklang = '';
  bool isLoading = true;
  List textMyan = ["ငွေပေးချေမှု"];
  List textEng = ["Payment Bill"];
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    checkLanguage();
    super.initState();
    getLocation();
  }

  Future _load() async {
    setState(() {
      isLoading = false;
    });
  }

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

  getLocation() async {
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userId');
    String sessionID = prefs.getString('sessionID');
    id = userID;
    String url = '$link'
        "/service001/getPayee";
    Map<String, String> headers = {"Content-type": "application/json"};
    String json =
        '{ "userID": "' + userID + '", "sessionID": "' + sessionID + '" }';
    http.Response response = await http.post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      String body = response.body;
      var data = jsonDecode(body);
      setState(() {
        isLoading = false;
        contactList = data["merchantList"];
        print(contactList);
      });
    } else {
      print("Connection Fail");
      setState(() {
        isLoading = true;
        // new Future.delayed(new Duration(seconds: 3), _load);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var body = ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: Colors.blue,
        indent: 20,
        endIndent: 20,
      ),
      key: _formKey,
      itemCount: contactList == null ? 0 : contactList.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Conditioned(
            cases: [
              Case(
                contactList[index]["merchantName"] == "SkyNet",
                builder: () => CircleAvatar(
                  radius: 20,
                  backgroundColor: colorgreen,
                  backgroundImage: AssetImage(
                    "assets/images/Skynet.jpg",
                  ),
                ),
              ),
              Case(
                contactList[index]["merchantName"] == "Utility",
                builder: () => CircleAvatar(
                  radius: 20,
                  backgroundColor: colorgreen,
                  backgroundImage: AssetImage(
                    "assets/images/utility.jpg",
                  ),
                ),
              ),
              Case(
                contactList[index]["merchantName"] != "SkyNet" &&
                    contactList[index]["merchantName"] != "Utility",
                builder: () => CircleAvatar(
                  child: Text(
                    contactList[index]["merchantName"].substring(0, 1),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  radius: 20,
                  backgroundColor: colorgreen,
                ),
              ),
            ],
            defaultBuilder: () => null,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
          title: Text("${contactList[index]["merchantName"]}",
              style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                  color: colorblack)),
          subtitle: Text("${contactList[index]["merchantID"]}"),
          onTap: () {
            if (contactList[index]["merchantName"] == "SkyNet") {
              // var route = new MaterialPageRoute(
              //     builder: (BuildContext context) => new skynetPage(
              //         value: (contactList[index]["merchantName"]),
              //         value1: (contactList[index]["merchantID"]),
              //         value2: id));
              // Navigator.of(context).push(route);
              var route = new MaterialPageRoute(
                  builder: (BuildContext context) => new SkyNetPage(
                        mName: (contactList[index]["merchantName"]),
                        mID: (contactList[index]["merchantID"]),
                      ));
              Navigator.of(context).push(route);
            } else if (contactList[index]["merchantName"] == "Utility") {
              var route = new MaterialPageRoute(
                  builder: (BuildContext context) => new UtilityPayment(
                      value: (contactList[index]["merchantName"]),
                      value1: (contactList[index]["merchantID"]),
                      value2: id));
              Navigator.of(context).push(route);
            } else if (contactList[index]["merchantName"] == "MPT") {
              var route = new MaterialPageRoute(
                  builder: (BuildContext context) => new MPTPage(
                      value: (contactList[index]["merchantName"]),
                      value1: (contactList[index]["merchantID"]),
                      value2: id));
              Navigator.of(context).push(route);
            } else {
              var route = new MaterialPageRoute(
                  builder: (BuildContext context) => new MeterBillPage(
                      value: (contactList[index]["merchantName"]),
                      value1: (contactList[index]["merchantID"]),
                      value2: id));
              Navigator.of(context).push(route);
            }
          },
        );
      },
    );

    var bodyProgress = new Container(
      child: new Stack(
        children: <Widget>[
          body,
          Container(
              decoration: new BoxDecoration(
                color: colorwhite,
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

    return Scaffold(
        appBar: AppBar(
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
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
          centerTitle: true,
          leading: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WalletPage()));
              },
              child: Icon(Icons.arrow_back, color: Colors.white)),
        ),
        key: _scaffoldkey,
        body: isLoading ? bodyProgress : body);
  }
}
