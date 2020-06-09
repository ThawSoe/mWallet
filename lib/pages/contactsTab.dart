import 'dart:convert';
import 'package:nsb/Link.dart';
import 'package:nsb/framework/http_service.dart' as http;
import 'package:flutter/material.dart';
import 'package:nsb/constants/constant.dart';
import 'package:nsb/global.dart';
import 'package:nsb/model/AddContactRequest.dart';
import 'package:nsb/model/AddContactResponse.dart';
import 'package:nsb/model/ContactRequest.dart';
import 'package:nsb/model/ContactResponse.dart';
import 'package:nsb/pages/Wallet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:condition/condition.dart';

class contactsTab extends StatefulWidget {
  static final String path = "lib/src/pages/lists/list1.dart";
  @override
  _contactsTabState createState() => _contactsTabState();
}

class _contactsTabState extends State<contactsTab> {
  String phoneno;
  String alertmsg = "";
  bool _isLoading;
  bool isLoading = true;
  String phoneNo = "";
  String desc;
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  String _scanBarcode = "";
  var result;

  var contactList = [];
  final myController = TextEditingController();

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

  @override
  void initState() {
    super.initState();
    this.getContactList();
  }

  getAddContact() async {
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userId');
    String sessionID = prefs.getString('sessionID');

    ContactAddRequest contactAddRequest = new ContactAddRequest(
        userID: userID,
        sessionID: sessionID,
        phone: myController.text,
        name: "",
        type: "1",
        t3: "0");
    Navigator.pop(context);
    ContactAddResponse contactAddResponse = await getAllAddContact(
            '$link' + '/chatservice/addContact', contactAddRequest.toMap())
        .catchError((Object error) {
      print(error.toString());
      snackbarfalse(error.toString());
    });
    myController.text = "";
    if (contactAddResponse.code == '0000') {
      snackbartrue(contactAddResponse.desc);
      this.getContactList();
      setState(() {
        isLoading = false;
      });
    } else {
      snackbarfalse(contactAddResponse.desc);
      final form = _formKey.currentState;
      form.validate();
      setState(() {
        isLoading = false;
      });
    }
  }

  Future scanBarcodeNormal() async {
    String barcodeScanRes = "";
    try {
      barcodeScanRes = await scanner.scan();
      if (barcodeScanRes != null) {
        if (barcodeScanRes.substring(0, 1) == "{") {
          setState(() {
            result = jsonDecode(barcodeScanRes);
            myController.text = result["contacts"];
          });
        } else {
          print("Scan Error");
        }
      } else {
        scanBarcodeNormal();
      }
      setState(() {
        _scanBarcode = barcodeScanRes;
        print(_scanBarcode);
      });
    } on FormatException {
      setState(() {
        alertmsg = "Scan canceled, try again !";
        print(alertmsg);
      });
    } catch (e) {
      alertmsg = "Unknown error $e";
    }
  }

  Future<ContactAddResponse> getAllAddContact(url, Map jsonMap) async {
    ContactAddResponse p = new ContactAddResponse();
    var body;
    try {
      body = await http.doPost(url, jsonMap);
      p = ContactAddResponse.fromJson(json.decode(body.toString()));
    } catch (e) {
      p.code = Constants.responseCode_Error;
      p.desc = e.toString();
    }
    print(p.toMap());
    return p;
  }

  getContactList() async {
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userId');
    String sessionID = prefs.getString('sessionID');

    SessionData contactlistrequest =
        new SessionData(userID: userID, sessionID: sessionID);
    ContactArr contactlistresponse = await getAllList(
            '$link' + '/chatservice/getContact', contactlistrequest.toMap())
        .catchError((Object error) {
      print(error.toString());
      snackbarfalse(error.toString());
    });
    desc = contactlistresponse.desc;
    if (contactlistresponse.code == '0000') {
      // this.alertmsg = contactlistresponse.desc;
      // this._method1();
      setState(() {
        isLoading = false;
      });
    } else {
      snackbarfalse(contactlistresponse.desc);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<ContactArr> getAllList(url, Map jsonMap) async {
    ContactArr p = new ContactArr();
    var body;
    try {
      body = await http.doPost(url, jsonMap);
      p = ContactArr.fromJson(json.decode(body.toString()));
      Map data = jsonDecode(body);
      setState(() {
        contactList = data["dataList"];
        isLoading = false;
      });
    } catch (e) {
      p.code = Constants.responseCode_Error;
      p.desc = e.toString();
      setState(() {
        isLoading = true;
      });
    }
    print(p.toMap());
    return p;
  }

  @override
  Widget build(BuildContext context) {
// contactlistresponse
    var contactbody = desc == "No record found!"
        ? Center(
            child: Text("No record found !",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300)))
        : ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.blue,
              endIndent: 50,
              indent: 50,
            ),
            key: _formKey,
            itemCount: contactList == null ? 0 : contactList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Conditioned(
                  cases: [
                    Case(
                      contactList[index]['t18'].toString() != "user-icon.png" &&
                          contactList[index]['t18'] != null &&
                          contactList[index]['t18'] != "",
                      builder: () => Container(
                        padding: EdgeInsets.all(8),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: colorgreen,
                          backgroundImage: NetworkImage(
                            '$linkapi' +
                                "/DigitalMedia/upload/image/userProfile/" +
                                contactList[index]['t18'].toString(),
                          ),
                        ),
                      ),
                    ),
                    Case(
                      contactList[index]['t18'].toString() == "user-icon.png" &&
                          contactList[index]['t18'] != null &&
                          contactList[index]['t18'] != "",
                      builder: () => Container(
                        padding: EdgeInsets.all(8),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: colorgreen,
                          child: Text(
                            contactList[index]['name'].substring(0, 1),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Case(
                      contactList[index]['t18'] == "" ||
                          contactList[index]['t18'] == null,
                      builder: () => Container(
                        padding: EdgeInsets.all(8),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: colorgreen,
                          child: Text(
                            contactList[index]['name'].substring(0, 1),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  defaultBuilder: () => null,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                title: Text("${contactList[index]["name"]}",
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black)),
                subtitle: Text("${contactList[index]["phone"]}"),
              );
            },
          );
    var bodyProgress = new Container(
      child: new Stack(
        children: <Widget>[
          contactbody,
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

    return Scaffold(
      key: _scaffoldkey,
      body: isLoading ? bodyProgress : contactbody,
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorgreen,
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Form(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          controller: myController,
                          decoration: InputDecoration(
                            labelText: "Phone Number",
                            hasFloatingPlaceholder: true,
                            labelStyle:
                                TextStyle(color: colorgreen, fontSize: 15),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          OutlineButton(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 15.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            highlightedBorderColor: colorblack,
                            borderSide: BorderSide(color: colorgreen),
                            color: Colors.white.withOpacity(1),
                            textColor: Colors.black,
                            child: Text(
                              "QRScan",
                              style: TextStyle(fontSize: 15),
                            ),
                            onPressed: () {
                              scanBarcodeNormal();
                            },
                          ),
                          RaisedButton(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 15.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            color: colorgreen.withOpacity(0.8),
                            textColor: Colors.white,
                            child: Text(
                              "Add Contact",
                              style: TextStyle(fontSize: 15),
                            ),
                            onPressed: () {
                              setState(() {
                                phoneNo = myController.text;
                                if (phoneNo.indexOf("7") == 0 &&
                                    phoneNo.length == 9) {
                                  phoneNo = '+959' + this.phoneNo;
                                } else if (phoneNo.indexOf("9") == 0 &&
                                    phoneNo.length == 9) {
                                  phoneNo = '+959' + phoneNo;
                                } else if (phoneNo.indexOf("+") != 0 &&
                                    phoneNo.indexOf("7") != 0 &&
                                    phoneNo.indexOf("9") != 0 &&
                                    (phoneNo.length == 8 ||
                                        phoneNo.length == 9 ||
                                        phoneNo.length == 7)) {
                                  this.phoneNo = '+959' + this.phoneNo;
                                } else if (phoneNo.indexOf("09") == 0 &&
                                    (phoneNo.length == 10 ||
                                        phoneNo.length == 11 ||
                                        phoneNo.length == 9)) {
                                  phoneNo = '+959' + phoneNo.substring(2);
                                  // phoneNo = true;
                                } else if (phoneNo.indexOf("959") == 0 &&
                                    (phoneNo.length == 11 ||
                                        phoneNo.length == 12 ||
                                        phoneNo.length == 10)) {
                                  phoneNo = '+959' + phoneNo.substring(3);
                                  // phoneNo = true;
                                }
                              });
                              print('Phone no: ' + phoneNo);
                              myController.text = phoneNo;
                              this.getAddContact();
                            },
                          ),
                        ],
                      )
                    ],
                  )),
                );
              });
        },
        tooltip: 'Increment',
        child: Icon(Icons.person_add),
      ),
    );
  }
}
