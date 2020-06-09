import 'dart:convert';
import 'package:contacts_service/contacts_service.dart';
import 'package:condition/condition.dart';
import 'package:flutter/material.dart';
import 'package:nsb/Link.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ContactsCalling extends StatefulWidget {
  @override
  _ContactsCallingState createState() => _ContactsCallingState();
}

class _ContactsCallingState extends State<ContactsCalling> {

  Iterable<Contact> contacts;

  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  var d = [];
  bool isChecked = false;
  bool isAllChecked = false;
  List<bool> isChecking = new List<bool>();
  var checkList = [];
  String alertmsg = "";

  @override
  void initState() {
    super.initState();
    contactPhoneNumber();
  }

  contactPhoneNumber() async {
    contacts = await ContactsService.getContacts();
    var c5 = [];
    var c4 = [];
    var c3 = [];
    var c2 = [];
    var c1 = contacts.toList();
    // c=contacts.toList();
    for (var i = 0; i < c1.length; i++) {
      c2.add(c1[i].toMap());
      c3.add(c2[i]["phones"]);
      for (var j = 0; j < c3[i].length; j++) {
        c4.add(c3[i][j]["value"].toString().replaceAll(" ", ""));
      }
    }
    for (var i = 0; i < c4.length; i++) {
      if (c4[i].startsWith('09')) {
        c5.add('+959' + c4[i].substring(2, c4[i].length));
      } else if (c4[i].startsWith('+959')) {
        c5.add(c4[i]);
      } else if (c4[i].length == 7 || c4[i].length == 9) {
        c5.add('+959' + c4[i]);
      }
    }

    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userId');
    String sessionID = prefs.getString('sessionID');
    var data = [];
    for (var i = 0; i < c5.length; i++) {
      data.add(
          {"userID": userID, "phone": c5[i], "name": "", "type": 1, "t3": 0});
    }

    final url = '$link' +
        '/chatservice/getContactListByPhoneNo';
    var body =
        jsonEncode({"userID": userID, "sessionID": sessionID, "data": data});
    http.post(Uri.encodeFull(url), body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((dynamic res) {
      var result = json.decode(res.body);
      if (result['code'] == "0000") {
        setState(() {
          d = result['dataList'];
        });
      }
      for (var i = 0; i < d.length; i++) {
        isChecking.add(false);
      }
    });
  }

  void _method1() {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
        content: new Text(this.alertmsg), duration: Duration(seconds: 2)));
  }

  phoneCheckListAdd() async{
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userId');
    String sessionID = prefs.getString('sessionID');
    print("balancephone >>>" + userID);
    print("balancesid >>>" + sessionID);
    var phone = [];
    var phoneary=[];
    for (var i = 0; i < isChecking.length; i++) {
      if (isChecking[i] == true) {
        phone.add(d[i]);
      }
    }
    print(phone);
    print("Check PHone  $phone");
    for (var i = 0; i < phone.length; i++) {
      phoneary.add({
        "userID": userID,
        "phone": phone[i]['t1'],
        "name": "",
        "type": 1,
        "t3": 0
      });
    }
    // print(phoneary.length);
    
    final url = '$link' +
        '/chatservice/addContactList';
    var body =
        jsonEncode({"userID": userID, "sessionID": sessionID, "data": phoneary});

    http.post(Uri.encodeFull(url), body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((dynamic res) {
      var result = json.decode(res.body);
      if (result['code'] == "0000") {
        this.alertmsg = result['desc'];
        this._method1();
        // var route = new MaterialPageRoute(builder: (BuildContextcontext) =>new ContactsCalling());
        // Navigator.of(context).push(route);
        contactPhoneNumber();

      } else {
        this.alertmsg = result['desc'];
        this._method1();
      }
      print(result);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Contact List",
            style: TextStyle(
                color: Color.fromRGBO(40, 103, 178, 1), fontSize: 20)),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: new Icon(Icons.arrow_back,
                color: Color.fromRGBO(40, 103, 178, 1)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Checkbox(
                activeColor: Colors.green,
                value: isAllChecked,
                onChanged: (bool value) {
                  setState(() {
                    isAllChecked = value;
                    for(var i=0;i<isChecking.length;i++){
                      isChecking[i]=value;
                    }
                  });
                }),
          ),
        ],
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(
          color: Colors.black,
        ),
        key: _formKey,
        itemCount: d == null ? 0 : d.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Conditioned(
              cases: [
                Case(
                  d[index]['t16'].toString() != "user-icon.png" &&
                      d[index]['t16'] != null &&
                      d[index]['t16'] != "",
                  builder: () => Container(
                    padding: EdgeInsets.all(8),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Color.fromRGBO(40, 103, 178, 1),
                      backgroundImage: NetworkImage(
                       '$linkapi'+ "/DigitalMedia/upload/image/userProfile/" +
                            d[index]['t16'].toString(),
                      ),
                    ),
                  ),
                ),
                Case(
                  d[index]['t16'].toString() == "user-icon.png" &&
                      d[index]['t16'] != null &&
                      d[index]['t16'] != "",
                  builder: () => Container(
                    padding: EdgeInsets.all(8),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Color.fromRGBO(40, 103, 178, 1),
                      child: Text(
                        d[index]['t3'].substring(0, 1),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Case(
                  d[index]['t16'] == "" || d[index]['t16'] == null,
                  builder: () => Container(
                    padding: EdgeInsets.all(8),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Color.fromRGBO(40, 103, 178, 1),
                      child: Text(
                        d[index]['t3'].substring(0, 1),
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
            title: Text(d[index]["t3"],
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            subtitle: Text(d[index]["t1"]),
            trailing: Checkbox(
                activeColor: Colors.green,
                // value: c.isChecked,
                value: isChecking[index],
                onChanged: (bool value) {
                  setState(() {
                    isChecking[index] = value;
                    // if(isChecking[index]["value"]==true){
                    //   checkList.add({
                    //     "t1" : d[index]["t3"],
                    //     "t3" : d[index]["t1"],
                    //     "value" : isChecking[index]["value"]
                    //   });
                    // }else{
                    //   isAllChecked=value;
                    // }
                  });
                  print(isChecking);
                  // print(d[index]["t3"]);
                  // print(d[index]["t1"]);
                  // print(isChecking[index]["value"]);
                }),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.30,
              height: 50.0,
              child: RaisedButton(
                child: Text("ADD"),
                onPressed: () {
                  phoneCheckListAdd();
                },
                color: Color.fromRGBO(40, 103, 178, 1),
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
