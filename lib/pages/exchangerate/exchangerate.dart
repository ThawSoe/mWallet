import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nsb/Link.dart';
import 'package:nsb/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'exchangerateRequest.dart';
import 'exchangerateResponse.dart';

class Exchanerate extends StatefulWidget {
  @override
  _ExchanerateState createState() => _ExchanerateState();
}

class _ExchanerateState extends State<Exchanerate> {
  List fromList = [];
  List toList = [];
  List sellList = [];
  List buyList = [];
  List currList = [];
  List searchList = [];
  List allData = [];
  bool connection = false;
  String userID;
  String sId;
  bool isLoaing = false;
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();
  String checklang = '';
  List textMyan = ["နိုင်ငံခြားငွေလွှဲနှုန်း"];
  List textEng = ["Foreign Exchange Rate"];

  @override
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
      getexchangeList();
    } else {
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
      backgroundColor: colorblack,
      duration: Duration(seconds: 2),
    ));
  }

  getexchangeList() async {
    isLoaing = true;
    final url =
        '$linkapi' + '/AppService/module001/service001/getForeignExchangeRates';
    print(url);
    var body = jsonEncode({"userId": '', "sessionID": ''});

    http.post(Uri.encodeFull(url), body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((dynamic res) {
      var data = json.decode(res.body);
      var result = data['data'];
      print(result);
      if (data['code'] == "0000") {
        isLoaing = false;
        // snackbartrue(data['desc']);
        for (var a = 0; result.length > a; a++) {
          allData.add(result[a]);
          fromList.add(result[a]["ccy1"]);
          toList.add(result[a]["ccy2"]);
          sellList.add(result[a]["numSellRate"]);
          buyList.add(result[a]["numBuyRate"]);
          currList.add(result[a]["namCURRTo"]);
        }
        setState(() {});
      } else {
        isLoaing = false;
        snackbarfalse(data['desc']);
      }
    }).catchError((Object error) {
      print(error.toString());
      snackbarfalse(error.toString());
    });
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
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        backgroundColor: colorgreen,
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
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
        bottom: PreferredSize(
          key: _formKey,
          preferredSize: const Size.fromHeight(70.0),
          child: Container(
            color: Colors.white,
            child: new Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: new TextField(
                    onChanged: searchResult,
                    controller: searchController,
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
          ),
        ),
      ),
      body: connection
          ? connectionfail
          : isLoaing
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.amber,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: (searchList.length == 0 ||
                          searchController.text.isEmpty)
                      ? ListView.separated(
                          separatorBuilder: (context, index) => Row(
                                children: <Widget>[
                                  Text(
                                    "--------------------------",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Expanded(
                                    child: new Container(
                                        margin: const EdgeInsets.only(
                                            left: 0.0, right: 10.0),
                                        child: Divider(
                                          color: Colors.blue,
                                        )),
                                  ),
                                ],
                              ),
                          itemCount: allData.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: 70,
                              child: ListTile(
                                leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Image.asset(
                                      'assets/flag/' + fromList[index] + '.jpg',
                                      width: 70,
                                      height: 170,
                                      fit: BoxFit.cover,
                                    )),
                                title: Text(
                                    fromList[index] + ' - ' + toList[index]),
                                subtitle: Text('Buy Rate - ' +
                                    buyList[index] +
                                    ' ' +
                                    currList[index] +
                                    '\n' +
                                    'Sell Rate - ' +
                                    sellList[index] +
                                    ' ' +
                                    currList[index]),
                              ),
                            );
                          })
                      : ListView.separated(
                          separatorBuilder: (context, index) => Row(
                                children: <Widget>[
                                  Text(
                                    "--------------------------",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Expanded(
                                    child: new Container(
                                        margin: const EdgeInsets.only(
                                            left: 0.0, right: 10.0),
                                        child: Divider(
                                          color: Colors.grey,
                                        )),
                                  ),
                                ],
                              ),
                          itemCount: searchList.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              height: 70,
                              child: ListTile(
                                leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Image.asset(
                                      'assets/flag/' +
                                          searchList[index]["ccy1"] +
                                          '.jpg',
                                      width: 80,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    )),
                                title: Text(searchList[index]["ccy1"] +
                                    ' - ' +
                                    searchList[index]["ccy2"]),
                                subtitle: Text('Buy Rate - ' +
                                    searchList[index]["numBuyRate"] +
                                    ' ' +
                                    searchList[index]["namCURRTo"] +
                                    '\n' +
                                    'Sell Rate - ' +
                                    searchList[index]["numSellRate"] +
                                    ' ' +
                                    searchList[index]["namCURRTo"]),
                              ),
                            );
                          })),
    );
  }

  searchResult(String text) async {
    searchList.clear();
    text = text.toUpperCase();
    if (text.isNotEmpty) {
      fromList.forEach((name) {
        if (name.contains(text)) {
          for (var a = 0; a < allData.length; a++) {
            print("ccy1 " + allData[a]["ccy1"]);
            if (allData[a]["ccy1"] == name) {
              searchList.add(allData[a]);
            }
            setState(() {});
          }
        }
      });

      print("No data found");
    }
  }
}
