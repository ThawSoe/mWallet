import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nsb/Link.dart';
import 'package:nsb/global.dart';
import 'dart:async';
import 'dart:convert';
import 'package:nsb/pages/faq/faqresponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FAQ extends StatefulWidget {
  @override
  _FAQState createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  final String url = '$link' + '/service002/getFAQList';
  List data = new List();
  int i;
  bool isLoading = true;
  String checklang = '';
  List faqQueEngList = [];
  List faqQueUniList = [];
  List faqAnsEngList = [];
  bool connection = false;
  List faqAnsUniList = [];
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  List textMyan = ["မေးလေ့ရှိသောမေးခွန်းများ"];
  List textEng = ["FAQ"];

  void initState() {
    super.initState();
    checkLanguage();
    CheckConnection();
  }

  CheckConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      connection = false;
      setState(() {});
      getJsonData();
      faqData();
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

  faqData() async {
    final url = '$link' + "/service002/getFAQList";
    http.get(Uri.encodeFull(url), headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((dynamic res) {
      var result = json.decode(utf8.decode(res.bodyBytes));
      print("result ===> $result");
      if (result['code'] == "0000") {
        isLoading = false;
        // snackbartrue(result['desc']);
        setState(() {});
        var data = result['faqData'];
        for (var i = 0; i < data.length; i++) {
          faqQueEngList.add(data[i]['questionEng'].toString());
          faqAnsEngList.add(data[i]['answerEng'].toString());
          faqQueUniList.add(data[i]['questionUni'].toString());
          faqAnsUniList.add(data[i]['answerUni'].toString());
        }
      } else {
        isLoading = false;
        snackbarfalse(result['desc']);
        setState(() {});
      }
    }).catchError((Object error) {
      print(error.toString());
      snackbarfalse(error.toString());
    });
  }

  FaqResponse p = new FaqResponse();

  Future<List<FaqResponse>> getJsonData() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    setState(() {
      p = FaqResponse.fromJson(json.decode(utf8.decode(response.bodyBytes)));

      data = p.faqData;
      if (p.code == "0000") {
        isLoading = false;
      } else {
        isLoading = true;
      }
    });
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
    var body = new ListView.builder(
      key: _formKey,
      itemCount: data.length,
      itemBuilder: (BuildContext contxt, int index) {
        i = index + 1;
        return new ExpansionTile(
          title: (checklang == "Eng")
              ? new Text(
                  '$i. ' + '${data[index].questionEng}',
                  style: TextStyle(fontWeight: FontWeight.w400),
                )
              : new Text(
                  '$i. ' + '${data[index].questionUni}',
                ),
          children: <Widget>[
            new ListTile(
              title: (checklang == "Eng")
                  ? new Text(
                      '${data[index].answerEng}',
                      style: TextStyle(fontWeight: FontWeight.w300),
                    )
                  : new Text('${data[index].answerUni}'),
            ),
          ],
        );
      },
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
        appBar: AppBar(
          backgroundColor: colorgreen,
          title: Padding(
            padding: const EdgeInsets.only(right: 35.0),
            child: Center(
              child: (checklang == "Eng")
                  ? new Text(
                      textEng[0],
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 19),
                    )
                  : new Text(
                      textMyan[0],
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
            ),
          ),
        ),
        body: connection ? connectionfail : isLoading ? bodyProgress : body);
  }
}
