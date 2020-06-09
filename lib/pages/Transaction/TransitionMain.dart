import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nsb/Link.dart';
import 'package:nsb/constants/constant.dart';
import 'package:nsb/global.dart';
import 'package:nsb/main.dart';
import 'package:nsb/model/TransitionListRequest.dart';
import 'package:nsb/model/TransitionListResponse.dart';
import 'package:nsb/pages/Transaction/Details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nsb/framework/http_service.dart' as http;
import 'package:http/http.dart' as http;

class TransitionMain extends StatefulWidget {
  @override
  _TransitionMainState createState() => _TransitionMainState();
}

class popupItem {
  static const String Default = 'Default';
  static const String TwoDays = '2Days';
  static const String FiveDays = '5Days';
  static const String Custom = 'Custom';

  static const List<String> choice = <String>[
    Default,
    TwoDays,
    FiveDays,
    Custom
  ];
}

class _TransitionMainState extends State<TransitionMain> {
  var balance = 0.0;
  var locationList = [];
  var displayArray = [];
  List paymentList = [];
  List receiveList = [];
  var datas, q;
  bool empty = false;
  var duration = 0;
  var pageC;
  var currPage;
  var pageSize;
  var date;
  var toDate;
  var fromDate;
  var endDate;
  var startDate;
  var selected;
  bool isLoading = true;
  TextEditingController startCon = TextEditingController();
  TextEditingController endCon = TextEditingController();
  String checklang = '';
  String alertmsg = "";
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  var data;
  List textMyan = [
    "လုပ်ဆောင်မှု မှတ်တမ်း",
    "နောက်ဆုံး၁၀ကြောင်း",
    "လွန်ခဲ့သော၂ရက်",
    "လွန်ခဲ့သော၅ရက်" "စိတ်ကြိုက်ရွေးချယ်မည်"
  ];
  List textEng = [
    "Transactions",
    "Last 10 Transactions",
    "2 Days",
    "5 Days",
    "Custom"
  ];
  @override
  void initState() {
    super.initState();
    checkLanguage();
    pageSize = 10;
    currPage = 1;
    pageC = 0;
    getTransactionList(duration);
  }

  Future _viewload() async {
    setState(() {
      isLoading = false;
    });
  }

  snackbartrue(name) {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      content: new Text(name),
      backgroundColor: Colors.blueAccent,
      duration: Duration(seconds: 2),
    ));
  }

  snackbarfalse(name) {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      content: new Text(name),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
    ));
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

  _choiceAction(selected) {
    print("object ===> $selected");
    if (selected == "default") {
      setState(() {
        isLoading = true;
      });
      duration = 0;
      locationList = [];
      paymentList = [];
      receiveList = [];
      print("duration ==> $duration");
      getTransactionList(duration);
    } else if (selected == "twoD") {
      setState(() {
        isLoading = true;
      });
      duration = 1;
      locationList = [];
      paymentList = [];
      receiveList = [];
      print("duration ==> $duration");
      getTransactionList(duration);
    } else if (selected == "fiveD") {
      setState(() {
        isLoading = true;
      });
      duration = 2;
      locationList = [];
      paymentList = [];
      receiveList = [];
      print("duration ==> $duration");
      getTransactionList(duration);
    } else if (selected == "custom") {
      duration = 3;
      return PreferredSize;
    }
  }

  getTransactionList(value) async {
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userId');
    String sessionID = prefs.getString('sessionID');
    String accountNo = prefs.getString('accountNo');

    TransitionListRequest transitionListRequest = new TransitionListRequest(
      userID: userID,
      sessionID: sessionID,
      customerNo: "",
      durationType: value,
      fromDate: "",
      toDate: "",
      totalCount: 0,
      acctNo: accountNo,
      currentPage: 2,
      pageSize: 10,
      pageCount: 0,
    );
    TransitionListResponse transitionListResponse = await getAllList1(
            '$link' + '/service001/getTransactionActivityList',
            transitionListRequest.toMap())
        .catchError((Object error) {
      print("Service Error" + error.toString());
      snackbarfalse(error.toString());
    });
    for (var a = 0; a < locationList.length; a++) {
      if (locationList[a]["drcr"] == "1") {
        paymentList.add(locationList[a]);
        print(paymentList);
      } else if (locationList[a]["drcr"] == "2") {
        receiveList.add(locationList[a]);
        print(receiveList);
      }
    }
    if (transitionListResponse.code == '0000') {
      setState(() {
        isLoading = false;
      });
      print(locationList);
      print('Get Everything.................');
    } else {
      isLoading = false;
      this.alertmsg = data["desc"];
      this._showDialog();
    }
  }

  Future<TransitionListResponse> getAllList1(url, Map jsonMap) async {
    TransitionListResponse p = new TransitionListResponse();
    var body;
    try {
      body = await http.doPost(url, jsonMap);
      p = TransitionListResponse.fromJson(json.decode(body.toString()));
      var data = jsonDecode(body);
      setState(() {
        if (data['data'] == null || data['data'] == "null") {
          empty = true;
        } else {
          locationList = data['data'];
        }
      });
    } catch (e) {
      p.code = Constants.responseCode_Error;
      p.desc = e.toString();
    }
    print(p.toMap());
    return p;
  }

  String _currText = "";

  _onSelect(duration) {
    print("duration ==> $duration");
  }

  @override
  Widget build(BuildContext context) {
    var all = new ListView.separated(
        separatorBuilder: (context, index) => Divider(
              color: Colors.white,
            ),
        itemCount: locationList.length,
        itemBuilder: (BuildContext context, int index) {
          isLoading = false;
          this.displayArray =
              this.locationList[index]["txnTypeDesc"].split(',');
          print("display ==> " + displayArray[1]);
          String dateString = locationList[index]["txnDate"];
          String d = dateString.substring(0, 4);
          String e = dateString.substring(5, 7);
          String f = dateString.substring(8, 10);
          String g = d + e + f;
          var date = new DateFormat.yMMMd().format(DateTime.parse(g));
          datas = date;
          print("data ==> $datas");
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsPage(
                    name: displayArray[1],
                    type: locationList[index]["remark"],
                    amount: locationList[index]["txnAmount"],
                    refNo: locationList[index]["txtReferenceNo"],
                    date: datas,
                    phNo: displayArray[0],
                  ),
                ),
              );
            },
            child: new Material(
              child: Column(children: <Widget>[
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 40,
                      child: Text(
                        locationList[index]["txnDate"],
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 15),
                      ),
                      decoration: BoxDecoration(
                        color: bgcolor,
                        // border: Border(
                        //   bottom: BorderSide(color: Colors.red, width: 0.5),
                        // ),
                      ),
                      padding: EdgeInsets.all(10),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(17.0),
                  child: new GestureDetector(
                    onTap: () {},
                    child: Row(children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            displayArray[1],
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          Divider(height: 10),
                          Text(
                            locationList[index]["remark"],
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          (locationList[index]['drcr'] == "1")
                              ? Text(
                                  locationList[index]["txnAmount"] + " MMK",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: colorerror),
                                )
                              : Text(
                                  locationList[index]["txnAmount"] + " MMK",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: colorgreen),
                                ),
                          Divider(height: 10),
                          Text(
                            "$datas",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
              ]),
            ),
          );
        });
    var payment = new ListView.separated(
        separatorBuilder: (context, index) => Divider(
              color: Colors.blue,
              indent: 20,
              endIndent: 20,
            ),
        itemCount: paymentList.length,
        itemBuilder: (BuildContext context, int index) {
          isLoading = false;
          this.displayArray = this.paymentList[index]["txnTypeDesc"].split(',');
          String dateString = paymentList[index]["txnDate"];
          String d = dateString.substring(0, 4);
          String e = dateString.substring(5, 7);
          String f = dateString.substring(8, 10);
          String g = d + e + f;
          var date = new DateFormat.yMMMd().format(DateTime.parse(g));
          datas = date;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsPage(
                    name: displayArray[1],
                    type: paymentList[index]["remark"],
                    amount: paymentList[index]["txnAmount"],
                    refNo: paymentList[index]["txtReferenceNo"],
                    date: datas,
                    phNo: displayArray[0],
                  ),
                ),
              );
            },
            child: new Material(
              child: Container(
                padding: const EdgeInsets.all(17.0),
                child: new GestureDetector(
                  onTap: () {},
                  child: Row(children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          displayArray[1],
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        Divider(height: 10),
                        Text(
                          paymentList[index]["remark"],
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          paymentList[index]["txnAmount"] + " MMK",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: colorerror),
                        ),
                        Divider(height: 10),
                        Text(
                          "$datas",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
            ),
          );
        });
    var receive = new ListView.separated(
        separatorBuilder: (context, index) => Divider(
              color: Colors.blue,
              indent: 20,
              endIndent: 20,
            ),
        itemCount: receiveList.length,
        itemBuilder: (BuildContext context, int index) {
          isLoading = false;
          this.displayArray = this.receiveList[index]["txnTypeDesc"].split(',');
          String dateString = receiveList[index]["txnDate"];
          String d = dateString.substring(0, 4);
          String e = dateString.substring(5, 7);
          String f = dateString.substring(8, 10);
          String g = d + e + f;
          var date = new DateFormat.yMMMd().format(DateTime.parse(g));
          datas = date;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsPage(
                    name: displayArray[1],
                    type: receiveList[index]["remark"],
                    amount: receiveList[index]["txnAmount"],
                    refNo: receiveList[index]["txtReferenceNo"],
                    date: datas,
                    phNo: displayArray[0],
                  ),
                ),
              );
            },
            child: new Material(
              child: Container(
                padding: const EdgeInsets.all(17.0),
                child: new GestureDetector(
                  onTap: () {},
                  child: Row(children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          displayArray[1],
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        Divider(height: 10),
                        Text(
                          receiveList[index]["remark"],
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          receiveList[index]["txnAmount"] + " MMK",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: colorgreen),
                        ),
                        Divider(height: 10),
                        Text(
                          "$datas",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
            ),
          );
        });

    var viewbody = TabBarView(
      key: _formKey,
      children: <Widget>[
        all,
        payment,
        receive,
      ],
    );

    var bodyProgress = new Container(
      child: new Stack(
        children: <Widget>[
          viewbody,
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
        length: 3,
        child: Scaffold(
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
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: <Widget>[
                PopupMenuButton<String>(
                    onSelected: (String value) {
                      setState(() {
                        selected = value;
                        print("selected ==> $selected");
                        _choiceAction(selected);
                      });
                    },
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(14),
                      child: Image.asset(
                        'assets/images/filter.png',
                        color: Colors.white,
                        width: 20.0,
                        height: 20.0,
                      ),
                    ),
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          value: "default",
                          child: GestureDetector(
                            child: Text("Last 10 Transactions",
                                style: TextStyle(
                                    color: colorblack,
                                    fontWeight: FontWeight.w400)),
                          ),
                        ),
                        PopupMenuItem(
                          value: "twoD",
                          child: GestureDetector(
                            child: Text("2 Days",
                                style: TextStyle(
                                    color: colorblack,
                                    fontWeight: FontWeight.w400)),
                          ),
                        ),
                        PopupMenuItem(
                          value: "fiveD",
                          child: GestureDetector(
                            onTap: () {
                              _choiceAction('fiveD');
                            },
                            child: Text("5 Days",
                                style: TextStyle(
                                    color: colorblack,
                                    fontWeight: FontWeight.w400)),
                          ),
                        ),
                        PopupMenuItem(
                          value: "custom",
                          child: GestureDetector(
                            child: Text("Custom",
                                style: TextStyle(
                                    color: colorblack,
                                    fontWeight: FontWeight.w400)),
                          ),
                        ),
                      ];
                    }),
              ],
              elevation: 2,
              bottom: (duration == 3)
                  ? PreferredSize(
                      preferredSize: const Size.fromHeight(120.0),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 5, right: 5, top: 0, bottom: 0),
                        child: Column(
                          children: <Widget>[
                            Row(children: [
                              new Flexible(
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: TextField(
                                    controller: startCon,
                                    style: TextStyle(color: Colors.white),
                                    keyboardType: TextInputType.datetime,
                                    onTap: () {
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());
                                      getStartDate();
                                    },
                                    decoration: InputDecoration(
                                        labelText: "From Date",
                                        labelStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300)),
                                  ),
                                ),
                              ),
                              new Flexible(
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: TextField(
                                    controller: endCon,
                                    style: TextStyle(color: Colors.white),
                                    keyboardType: TextInputType.datetime,
                                    onTap: () {
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());
                                      getEndDate();
                                    },
                                    decoration: InputDecoration(
                                        labelText: "To Date",
                                        labelStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300)),
                                  ),
                                ),
                              ),
                            ]),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(bottom: 10, right: 10),
                                    child: RaisedButton(
                                        color: colorgreen,
                                        child: Text(
                                          "Search",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () async {
                                          // if (startDate > endDate) {
                                          //   print("Impossible ...");
                                          // } else {
                                          searchDatawithDate();
                                          // print(startDate);
                                          // }
                                        }),
                                  ),
                                ]),
                          ],
                        ),
                      ),
                    )
                  : TabBar(
                      // unselectedLabelColor: Colors.red,
                      indicatorColor: colorblack,
                      indicatorWeight: 2.5,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: [
                        Tab(
                          child: Container(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "ALL",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "PAYMENT",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "RECEIVE",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            body: empty
                ? Center(
                    child: Text("No Transaction found !",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w300)))
                : isLoading ? bodyProgress : viewbody
            // body: TabBarView(
            //   children: <Widget>[
            //     all,
            //     payment,
            //     receive,
            //   ],
            // ),
            ),
      ),
    );
  }

  searchDatawithDate() async {
    setState(() {
      isLoading = true;
    });
    locationList = [];
    paymentList = [];
    receiveList = [];
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userId');
    String sessionID = prefs.getString('sessionID');
    String accountNo = prefs.getString('accountNo');
    String url = '$link' + "/service001/getTransactionActivityList";
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{ "userID": "' +
        userID +
        '", "sessionID":"' +
        sessionID +
        '" , "customerNo":"' +
        "" +
        '", "durationType":"' +
        "$duration" +
        '", "fromDate":"' +
        toDate +
        '", "toDate":"' +
        fromDate +
        '", "totalCount":"' +
        "0" +
        '", "acctNo":"' +
        accountNo +
        '", "currentPage":"' +
        "1" +
        '", "pageSize":"' +
        "10" +
        '", "pageCount":"' +
        "0" +
        '"}';
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
      String body = response.body;
      print(body);
      data = jsonDecode(body);
      if (data["code"] == "0000") {
        duration = 0;
        locationList = data["data"];
        print(locationList.length);
        for (var a = 0; a < locationList.length; a++) {
          if (locationList[a]["drcr"] == "1") {
            paymentList.add(locationList[a]);
            print(paymentList);
          } else if (locationList[a]["drcr"] == "2") {
            receiveList.add(locationList[a]);
            print(receiveList);
          }
        }
      } else {
        isLoading = false;
        this.alertmsg = data["desc"];
        this._showDialog();
      }
      setState(() {});
    } else {
      print("Connection Fail");
      setState(() {
        isLoading = false;
      });
    }
  }

  _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Warning! "),
          content: new Text(this.alertmsg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  getEndDate() async {
    var end = await getendDate();
    setState(() {
      endDate = end;
      endCon.text = DateFormat('dd-MM-yyyy').format(endDate).toString();
      var splitDate =
          DateFormat('yyyy,MM,dd').format(endDate).toString().split(",");
      fromDate = splitDate[0] + splitDate[1] + splitDate[2];
    });
  }

  getStartDate() async {
    var start = await getstartDate();
    setState(() {
      startDate = start;
      startCon.text = DateFormat('dd-MM-yyyy').format(startDate).toString();
      var splitDate =
          DateFormat('yyyy,MM,dd').format(startDate).toString().split(",");
      toDate = splitDate[0] + splitDate[1] + splitDate[2];
      print("controller ==> " + startCon.text);
    });
  }

  Future<DateTime> getstartDate() {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
  }

  Future<DateTime> getendDate() {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
  }
}
