import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:nsb/Link.dart';
import 'package:nsb/global.dart';
import 'package:nsb/pages/billTabPage.dart';
import 'package:nsb/pages/contactsTab.dart';
import 'package:nsb/pages/skyNet/skynetPage.dart';
import 'package:nsb/pages/skyNetTest/Skynet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SkynetBeneficiary extends StatefulWidget {
  @override
  _SkynetBeneficiaryState createState() => _SkynetBeneficiaryState();
}

class _SkynetBeneficiaryState extends State<SkynetBeneficiary> {
  String alertmsg = "";
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  List contactList = new List();
  String checklang = '';
  var data;
  bool isLoading = false;
  List textMyan = ["ငွေပေးချေမှု"];
  List textEng = ["Skynet Card Beneficiary"];
  void initState() {
    super.initState();
    checkLanguage();
    getCardno();
  }

  void _method1() {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
        content: new Text(this.alertmsg),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1)));
  }

  getCardno() async {
    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userId');
    String sessionID = prefs.getString('sessionID');
    String url = '$link'
        "/payment/getCardNo";
    Map<String, String> headers = {"Content-type": "application/json"};
    String json =
        '{ "userID": "' + userID + '", "sessionID":"' + sessionID + '" }';
    http.Response response = await http
        .post(url, headers: headers, body: json)
        .catchError((Object error) {
      print(error.toString());
      this.alertmsg = error.toString();
      this._method1();
    });
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      String body = response.body;
      print(body);
      data = jsonDecode(body);
      print(data);
      setState(() {
        isLoading = false;
        contactList = data["cadData"];
      });
      print(contactList);
    } else {
      print("Connection Fail");
      this.alertmsg = data["desc"];
      this._method1();
      setState(() {
        isLoading = false;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    void getCardNo(String cardNo) async {
      print("CardNo " + cardNo);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SkyNetPage(cardNo: cardNo)));
    }

    var skynetbody = contactList == "[]"
        ? Center(
            child: Text("No Record found !",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300)))
        : ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.blue,
              indent: 20,
              endIndent: 20,
            ),
            key: _formKey,
            itemCount: contactList == null ? 0 : contactList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: CircleAvatar(
                  radius: 20.0,
                  // child: Text("${contactList[index]["name"]}".substring(0, 1)),
                  backgroundImage: AssetImage("assets/images/Skynet.jpg"),
                ),
                onTap: () {
                  getCardNo(contactList[index]["cardNo"]);
                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                title: Text("${contactList[index]["name"]}",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        color: colorblack)),
                subtitle: Text("${contactList[index]["cardNo"]}"),
              );
            },
          );

    var bodyProgress = new Container(
      child: new Stack(
        children: <Widget>[
          skynetbody,
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
    return Scaffold(
        key: _scaffoldkey,
        backgroundColor: Colors.white,
        appBar: new AppBar(
          centerTitle: true,
          elevation: 2.0,
          backgroundColor: colorgreen,
          title: Text(
            checklang == "Eng" ? textEng[0] : textMyan[0],
            style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
                height: 1.0,
                fontWeight: FontWeight.w500),
          ),
        ),
        body: isLoading ? bodyProgress : skynetbody);
  }
}
