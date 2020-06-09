import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:nsb/Link.dart';
import 'package:nsb/framework/http_service.dart' as http;
import 'package:nsb/global.dart';
import 'package:nsb/model/notificationRequest.dart';
import 'package:nsb/model/notificationResponse.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';

class Noti extends StatefulWidget {
  @override
  _NotiState createState() => _NotiState();
}

class _NotiState extends State<Noti> {
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  String alertmsg = "";
  var list = [];
  bool connection = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    CheckConnection();
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

  CheckConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      connection = false;
      setState(() {});
      method1();
    } else {
      isLoading = false;
      connection = true;
      snackbarfalse("No Internet Connection !");
      setState(() {});
    }
  }

  method1() async {
    isLoading = true;
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userId');
    String sessionID = "";
    String customerNo = "";
    String totalCount = "0";
    String currentPage = "";
    String pageSize = "";
    String pageCount = "0";
    NotificationRequest notificationRequest = new NotificationRequest(
        userID: userID,
        sessionID: sessionID,
        customerNo: customerNo,
        totalCount: totalCount,
        currentPage: currentPage,
        pageSize: pageSize,
        pageCount: pageCount);
    NotiRemove notificationResponse = await goLogin(
            '$link' + '/service007/removeNotiCount',
            notificationRequest.toMap())
        .catchError((Object error) {
      print(error.toString());
      snackbarfalse(error.toString());
    });
    if (notificationResponse.count == 0) {
      String sessionID = prefs.getString('sessionID');
      String customerNo = "";
      String totalCount = "0";
      String currentPage = "1";
      String pageSize = "10";
      String pageCount = "0";
      NotificationRequest notificationRequest1 = new NotificationRequest(
          userID: userID,
          sessionID: sessionID,
          customerNo: customerNo,
          totalCount: totalCount,
          currentPage: currentPage,
          pageSize: pageSize,
          pageCount: pageCount);
      NotificationResponse notificationResponse1 = await goLogin1(
              '$link' + '/service007/getAllTokenNotification',
              notificationRequest1.toMap())
          .catchError((Object error) {
        print(error.toString());
        snackbarfalse(error.toString());
      });
      if (notificationResponse1.msgCode == '0000') {
        setState(() {
          isLoading = false;
          // snackbartrue(notificationResponse1.msgDesc);
          list = notificationResponse1.data;
          print(list.length);
        });
      } else {
        isLoading = false;
        snackbarfalse(notificationResponse1.msgDesc);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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

    var notiload =
        list.length == null || list.length == "null" || list.length == 0
            ? Center(
                child: Text("No record found !",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w300)))
            : ListView.builder(
                key: _formKey,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 10.0,
                    // color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.09),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            // trailing:
                            //     '${list[index].description}'.substring(0, 17) ==
                            //             "You have received"
                            //         ? Icon(
                            //             Icons.arrow_downward,
                            //             color: colorgreen,
                            //           )
                            //         : Icon(
                            //             Icons.arrow_upward,
                            //             color: colorerror,
                            //           ),
                            title: new Column(
                              children: <Widget>[
                                Text('${list[index].description}',
                                    style: TextStyle(
                                        color: colorblack,
                                        fontWeight: FontWeight.w300))
                              ],
                            ),
                          ),
                          // Divider(),
                        ],
                      ),
                    ),
                  );
                });

    var bodyProgress = new Container(
      child: new Stack(
        children: <Widget>[
          notiload,
          Container(
              decoration: new BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.5),
              ),
              width: MediaQuery.of(context).size.width * 0.99,
              height: MediaQuery.of(context).size.height * 0.9,
              child: Center(
                child: CircularProgressIndicator(backgroundColor: colorgreen),
              ))
        ],
      ),
    );

    return Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          backgroundColor: colorgreen,
          title: Padding(
            padding: const EdgeInsets.only(right: 35.0),
            child: Center(
                child: new Text(
              'Notification',
              style: TextStyle(fontWeight: FontWeight.w500),
            )),
          ),
        ),
        body:
            connection ? connectionfail : isLoading ? bodyProgress : notiload);
  }

  Future<NotiRemove> goLogin(url, Map jsonMap) async {
    NotiRemove p = new NotiRemove();
    var body;
    try {
      body = await http.doPost(url, jsonMap);
      p = NotiRemove.fromJson(json.decode(body.toString()));
    } catch (e) {
      print(e.toString());
    }
    return p;
  }

  Future<NotificationResponse> goLogin1(url, Map jsonMap) async {
    NotificationResponse p = new NotificationResponse();
    var body;
    try {
      body = await http.doPost(url, jsonMap);
      // print(body);
      p = NotificationResponse.fromJson(json.decode(body.toString()));
    } catch (e) {
      print(e.toString());
    }
    return p;
  }
}
