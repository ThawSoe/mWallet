import 'dart:convert';

import 'package:condition/condition.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:nsb/Link.dart';
import 'package:nsb/constants/constant.dart';
import 'package:nsb/global.dart';
import 'package:nsb/model/AddContactRequest.dart';
import 'package:nsb/model/AddContactResponse.dart';
import 'package:nsb/model/ContactRequest.dart';
import 'package:nsb/model/ContactResponse.dart';
import 'package:nsb/pages/Transfer/transferBind.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nsb/framework/http_service.dart' as http;
import 'package:native_contact_picker/native_contact_picker.dart';

class TransferContact extends StatefulWidget {
  @override
  _TransferContactState createState() => _TransferContactState();
}

class _TransferContactState extends State<TransferContact> {
  String phoneno;
  String alertmsg = "";
  bool isLoading = false;
  String phoneNo = "";
  bool isvalidate = false;
  String checklang = '';
  bool connection = false;
  List textMyan = [
    "ငွေလွှဲမည့်သူရွေးရန်",
    "ဖုန်းနံပါတ်",
    "Next",
    "Please enter phone number"
  ];
  List textEng = [
    "Transfer To",
    "Phone Number",
    "Next",
    "ဖုန်းနံပါတ်ရိုက်​ထည့်​ပါ"
  ];
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  var contactList = [];
  var contact = [];
  final myController = TextEditingController();
  final NativeContactPicker _contactPicker = new NativeContactPicker();
  final phonenumber = TextEditingController();
  Contact _contact;
  String phonecontact;
  int startnum;
  String name;
  String number;

  CheckConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      connection = false;
      setState(() {});
      getContactList();
    } else {
      isLoading = false;
      connection = true;
      snackbarfalse("No Internet Connection !");
      setState(() {});
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

  @override
  void initState() {
    super.initState();
    checkLanguage();
    CheckConnection();
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

  getAddContact() async {
    isLoading = true;
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userId');
    String sessionID = prefs.getString('sessionID');
    phoneNo = phonenumber.text.toString();
    if (phoneNo.indexOf("7") == 0 && phoneNo.length == 9) {
      phoneNo = '+959' + this.phoneNo;
    } else if (phoneNo.indexOf("9") == 0 && phoneNo.length == 9) {
      phoneNo = '+959' + phoneNo;
    } else if (phoneNo.indexOf("+") != 0 &&
        phoneNo.indexOf("7") != 0 &&
        phoneNo.indexOf("9") != 0 &&
        (phoneNo.length == 8 || phoneNo.length == 9 || phoneNo.length == 7)) {
      this.phoneNo = '+959' + this.phoneNo;
    } else if (phoneNo.indexOf("09") == 0 &&
        (phoneNo.length == 10 || phoneNo.length == 11 || phoneNo.length == 9)) {
      phoneNo = '+959' + phoneNo.substring(2);
    } else if (phoneNo.indexOf("959") == 0 &&
        (phoneNo.length == 11 ||
            phoneNo.length == 12 ||
            phoneNo.length == 10)) {
      phoneNo = '+959' + phoneNo.substring(3);
    }
    print(phoneNo);
    ContactAddRequest contactAddRequest = new ContactAddRequest(
        userID: userID,
        sessionID: sessionID,
        phone: phoneNo,
        name: "",
        type: "1",
        t3: "0");
    ContactAddResponse contactAddResponse = await getAllAddContact(
            '$link' + '/chatservice/addContact', contactAddRequest.toMap())
        .catchError((Object error) {
      print(error.toString());
      snackbarfalse(error.toString());
    });
    if (contactAddResponse.code == '0000') {
      isLoading = false;
      snackbartrue(contactAddResponse.desc);
      setState(() {});
      this.getContactList();
    } else if (contactAddResponse.code == '0016') {
      isLoading = false;
      snackbartrue(contactAddResponse.desc);
      setState(() {});
      this.getContactList();
      for (var i = 0; i < contactList.length; i++) {
        if (phoneNo == contactList[i]["phone"]) {
          setState(() {
            name = contactList[i]["name"];
          });
        }
      }
      var route = new MaterialPageRoute(
          builder: (BuildContext context) =>
              new transferBind(value: (name), value1: (phoneNo)));
      Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.of(context).push(route);
      });
    } else {
      isLoading = false;
      snackbarfalse(contactAddResponse.desc);
      setState(() {});
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
    return p;
  }

  getContactList() async {
    isLoading = true;
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userId');
    String sessionID = prefs.getString('sessionID');
    try {
      SessionData contactlistrequest =
          new SessionData(userID: userID, sessionID: sessionID);
      ContactArr contactlistresponse = await getAllList(
              '$link' + '/chatservice/getContact', contactlistrequest.toMap())
          .catchError((Object error) {
        snackbarfalse("Service Error" + error.toString());
        print(error.toString());
      });
      if (contactlistresponse.code == '0000') {
        isLoading = false;
        // snackbartrue(contactlistresponse.desc);
        contact = contactlistresponse.dataList;
        setState(() {});
      } else {
        isLoading = false;
        snackbarfalse(contactlistresponse.desc);
        setState(() {});
      }
    } catch (error) {
      isLoading = false;
      snackbarfalse(error.toString());
      print(error.toString());
    }
    isLoading = false;
    // return contactlistresponse.code;
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
      });
    } catch (e) {
      p.code = Constants.responseCode_Error;
      p.desc = e.toString();
      isLoading = false;
      snackbarfalse(e.toString());
    }
    return p;
  }

  @override
  Widget build(BuildContext context) {
    final passwordField2 = new TextFormField(
      controller: phonenumber,
      onChanged: (text) {
        text.toString().isEmpty ? isvalidate = true : isvalidate = false;
        setState(() {});
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          labelText: (checklang == "Eng") ? textEng[1] : textMyan[1],
          hasFloatingPlaceholder: true,
          labelStyle: (checklang == "Eng")
              ? TextStyle(
                  fontSize: 15,
                  color: colorblack,
                  height: 0,
                  fontWeight: FontWeight.w300)
              : TextStyle(fontSize: 14, color: colorblack, height: 0),
          fillColor: colorblack,
          errorText:
              isvalidate ? checklang == "Eng" ? textMyan[3] : textEng[3] : null,
          errorStyle: TextStyle(
              wordSpacing: 1,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: colorerror),
          suffixIcon: IconButton(
            onPressed: () async {
              print(Text("gg"));
              Contact contact = await _contactPicker.selectContact();
              setState(() {
                _contact = contact;
                startnum = _contact.toString().indexOf(':');
                name = _contact.toString().substring(0, startnum);
                number = _contact.toString().substring(startnum + 1);
                number = number.toString().replaceAll(" ", "");
                phonenumber.text = number.toString().replaceAll("+95", "0");
                // phonenumber.text=number.toString().replaceAll(":", "");
              });
            },
            icon: Icon(
              Icons.import_contacts,
              color: colorgreen,
              size: 25,
            ),
          )),
    );

    final nextButton = Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 00.0, 0.0),
        child: SizedBox(
          height: 43.0,
          width: MediaQuery.of(context).size.width * 0.99,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0)),
            child: new Text(
              (checklang == "Eng") ? textEng[2] : textMyan[2],
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            textColor: Colors.white,
            onPressed: () async {
              if (phonenumber.text == "" || phonenumber.text == null) {
                isvalidate = true;
              } else {
                isvalidate = false;
                getAddContact();
              }
              setState(() {});
            },
            color: colorgreen,
          ),
        ));

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

    var body = new Form(
      child: new ListView(
        children: <Widget>[
          SizedBox(height: 10.0),
          Container(
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            height: MediaQuery.of(context).size.height * 0.15,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 3.0,
              child: ListView(
                // padding: EdgeInsets.all(5.0),
                children: <Widget>[
                  SizedBox(height: 20.0),
                  Center(
                    child: new Container(
                      padding: EdgeInsets.only(left: 22.0, right: 10.0),
                      child: passwordField2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // SizedBox(height: 5.0),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.99,
                  height: 65,
                  child: nextButton,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            height: 480,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              elevation: 3.0,
              child: ListView.separated(
                padding: EdgeInsets.all(3.0),
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
                          contactList[index]['t18'].toString() !=
                                  "user-icon.png" &&
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
                          contactList[index]['t18'].toString() ==
                                  "user-icon.png" &&
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
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
                    title: Text("${contactList[index]["name"]}",
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                            color: colorblack)),
                    subtitle: Text("${contactList[index]["phone"]}"),
                    onTap: () {
                      // (contactList[index]["name"],contactList[index]["phone"]);
                      var route = new MaterialPageRoute(
                          builder: (BuildContext context) => new transferBind(
                              value: (contactList[index]["name"]),
                              value1: (contactList[index]["phone"])));
                      Navigator.of(context).push(route);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
    var bodyProgress = new Container(
      child: new Stack(
        children: <Widget>[
          body,
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
      backgroundColor: bgcolor,
      appBar: new AppBar(
        centerTitle: true,
        elevation: 0.0,
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

        // actions: <Widget>[
        //   IconButton(
        //     padding: EdgeInsets.all(0),
        //     onPressed: () {
        //     },
        //     iconSize: 25,
        //     icon: Icon(
        //       Icons.view_list,
        //       color: Colors.white,
        //     ),
        //   )
        // ],
      ),
      body: connection ? connectionfail : isLoading ? bodyProgress : body,
    );
  }
}
