import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nsb/Link.dart';
import 'package:nsb/constants/constant.dart';
import 'package:nsb/global.dart';
import 'package:nsb/model/GetBalanceRequest.dart';
import 'package:nsb/model/GetBalanceResponse.dart';
import 'package:nsb/model/TransitionListRequest.dart';
import 'package:nsb/model/TransitionListResponse.dart';
// import 'package:nsb/pages/Contact%20qr/Generateqr.dart';
import 'package:nsb/pages/Contact.dart';
import 'package:nsb/pages/News.dart';
import 'package:nsb/pages/News/newsFeeds.dart';
import 'package:nsb/pages/Scan/GenerateQR/QR.dart';
import 'package:nsb/pages/Scan/ScanPayment.dart';
import 'package:nsb/pages/Transaction/TransitionMain.dart';
import 'package:nsb/pages/Transfer/transferContact.dart';
import 'package:nsb/pages/accountSecurity/acSecurity.dart';
import 'package:nsb/pages/agent/agent.dart';
import 'package:nsb/pages/agent/agentTransfer.dart';
import 'package:nsb/pages/billTabPage.dart';
import 'package:nsb/pages/contactsTab.dart';
import 'package:nsb/pages/contactscall.dart';
import 'package:nsb/pages/exchangerate/exchangerate.dart';
import 'package:nsb/pages/faq/faq.dart';
import 'package:nsb/pages/locationPage.dart';
import 'package:nsb/pages/messagesTab.dart';
import 'package:nsb/pages/newLoginPage.dart';
import 'package:nsb/constants/rout_path.dart' as routes;
import 'package:nsb/pages/notification/notification.dart';
import 'package:nsb/pages/profile/profile.dart';
import 'package:nsb/pages/setting/font.dart';
import 'package:nsb/pages/setting/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nsb/framework/http_service.dart' as http;
import 'package:markdown/markdown.dart' as md;
import 'package:condition/condition.dart';
import 'package:qrscan/qrscan.dart' as scanner;

// import 'Contact qr/Generateqr.dart';

class WalletPage extends StatefulWidget {
  String sessionID;
  final String value;
  final String value1;

  WalletPage({Key key, this.value, this.value1}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new WalletPageState();
}

class WalletPageState extends State<WalletPage> {
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  GlobalKey globalKey = new GlobalKey();

  var balance = 0.0;
  var locationList = [];
  var displayArray = [];
  var datas = "";
  String _scanBarcode = "";
  String alertmsg = "";
  var ncount = 0;
  var name = "No Activity Found",
      topup = "",
      amount = "",
      date = "",
      changeamount = "";
  String uu, ss;
  String checklang = '';
  List advList = [];
  List textMyan = [
    "ငွေပေးချေ",
    "ငွေလက်ခံ",
    "ငွေလွှဲရန်",
    "ဘေလ်",
    "ငွေသွင်း",
    "ငွေထုတ်",
    "ဝေါ(လ်)လတ် လက်ကျန်ငွေ",
    "ကျပ်",
    "ငွေဖြည့်ရန်",
    "လုပ်ဆောင်မှုမှတ်တမ်း",
    "အားလုံးကြည့်ရန်",
    "ကိုယ်စားလှယ်",
  ];
  List textEng = [
    "Scan",
    "My QR",
    "Transfer",
    "Bills",
    "Cash In",
    "Cash Out",
    "Wallet Balance",
    "MMK",
    "Top Up",
    "Activity",
    "View all",
    "Agent",
  ];
  List drawertextMyan = [
    "အကောင့်လုံခြုံရေး",
    "ပြင်​ဆင်​ရန်​",
    "တည်နေရာ",
    "ငွေလွှဲနှုန်း",
    "မေးလေ့ရှိသောမေးခွန်းများ",
    "ဆက်သွယ်ရန်",
    "ထွက်ရန်"
  ];
  List drawertextEng = [
    "Account Security",
    "Setting",
    "Location",
    "Exchange Rate",
    "FAQ",
    "Contact Us",
    "Log Out"
  ];
  List bottombarMyan = ["ဝေါ(လ်)လတ်", "မက်ဆေ့ချ်", "အဆက်အသွယ်", "သတင်း"];
  List bottombarEng = ["Wallet", "Message", "Contacts", "News"];
  @override
  void initState() {
    super.initState();
    this.checkLanguage();
    this.refreshPage();
    this.getBalance();
    this.getList();
    this.getNotiCount();
    this.getadbLink();
  }

  CarouselSlider carouselSlider;
  int _current = 0;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
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

  goToPrevious() {
    carouselSlider.previousPage(
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  goToNext() {
    carouselSlider.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.decelerate);
  }

  refreshPage() {
    this.checkLanguage();
    this.getBalance();
    this.getList();
    this.getNotiCount();
    this.getadbLink();
  }

  Future<Null> refreshing() async {
    await Future.delayed(Duration(seconds: 1));
    refreshPage();
    return null;
  }

  getBalance() async {
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userId');
    String sessionID = prefs.getString('sessionID');

    GetBalanceRequest getBalanceRequest =
        new GetBalanceRequest(userID: userID, sessionID: sessionID);
    GetBalanceResponse getBalanceResponse = await goBalance(
            '$link' + '/wallet/getBalanceWL', getBalanceRequest.toMap())
        .catchError((Object error) {
      print(error.toString());
      snackbarfalse(error.toString());
    });
    if (getBalanceResponse.messageCode == '0000') {
      setState(() {
        balance = getBalanceResponse.balance;
      });
      print("My balance" + balance.toString().substring(0, 6));
    }
    changebalance();
    setState(() {});
  }

  changebalance() async {
    var index = balance.toString().indexOf('.');
    int value = int.parse(balance.toString().substring(0, index));
    int value1 = int.parse(balance.toString().substring(index + 1));
    print("value $value");
    if (value > -1000 && value < 1000) {
      changeamount = balance.toString();
    } else {
      final String digits = value.toString();
      print(digits);
      final StringBuffer amount1 = StringBuffer(value < 0 ? '-' : '');
      final int maxDigitIndex = digits.length - 1;
      for (int i = 0; i <= maxDigitIndex; i += 1) {
        amount1.write(digits[i]);
        if (i < maxDigitIndex && (maxDigitIndex - i) % 3 == 0) {
          amount1.write(',');
        }
      }
      changeamount = amount1.toString() + "." + value1.toString();
      print("Standart Balance" + changeamount);
      setState(() {});
    }
    setState(() {});
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

  getList() async {
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userId');
    String sessionID = prefs.getString('sessionID');
    String accountNo = prefs.getString('accountNo');

    TransitionListRequest transitionListRequest = new TransitionListRequest(
      userID: userID,
      sessionID: sessionID,
      customerNo: "",
      durationType: 0,
      fromDate: "",
      toDate: "",
      totalCount: 0,
      acctNo: accountNo,
      currentPage: 1,
      pageSize: 10,
      pageCount: 0,
    );
    TransitionListResponse transitionListResponse = await getAllList(
            '$link' + '/service001/getTransactionActivityList',
            transitionListRequest.toMap())
        .catchError((Object error) {
      print(error.toString());
      snackbarfalse(error.toString());
    });
    try {
      String dateString = locationList[0]['txnDate'];
      String d = dateString.substring(0, 4);
      String e = dateString.substring(5, 7);
      String f = dateString.substring(8, 10);
      String g = d + e + f;
      var date = new DateFormat.yMMMd().format(DateTime.parse(g));
      datas = date;
      name = displayArray[1];
      topup = locationList[0]["remark"];
      amount = locationList[0]["txnAmount"] + " MMK";
      date = datas;
    } catch (error) {
      print("DateTimeError " + error.toString());
    }
    if (transitionListResponse.code == '0000') {
      print(locationList);
      print('Get Everything.............');
      print(displayArray);
      print(locationList[0]["txnDate"]);
    }
  }

  getadbLink() async {
    final url = '$link' + "/service001/getAdLink";
    http.get(Uri.encodeFull(url), headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((dynamic res) {
      var result = json.decode(res.body);
      print("result ===> $result");
      if (result['code'] == "0000") {
        var data = result['dataList'];
        for (var i = 0; i < data.length; i++) {
          advList.add(data[i]['logo'].toString().substring(29));
        }
      }
      print("Phot link $advList");
    }).catchError((Object error) {
      print(error.toString());
      snackbarfalse(error.toString());
    });
  }

  getNotiCount() async {
    final prefs = await SharedPreferences.getInstance();
    uu = prefs.getString('userId');
    ss = prefs.getString('name');

    String url = '$link'
        "/service007/tokenNotiCount";
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{ "userid": "' +
        uu +
        '", "sessionID":"' +
        "" +
        '", "customerNo":"' +
        "" +
        '", "totalCount":"' +
        "0" +
        '", "currentPage":"' +
        "" +
        '", "pageSize":"' +
        "" +
        '", "pageCount":"' +
        "0" +
        '" }';
    http.Response response = await http
        .post(url, headers: headers, body: json)
        .catchError((Object error) {
      print(error.toString());
      snackbarfalse(error.toString());
    });
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      String body = response.body;
      var data = jsonDecode(body);
      print(data);
      setState(() {
        ncount = data['count'];
      });
      print(ncount);
    } else {
      print("Connection Fail");
      setState(() {});
    }
  }

  removeNotiCount() async {
    final prefs = await SharedPreferences.getInstance();
    uu = prefs.getString('userId');
    ss = prefs.getString('name');

    String url = '$link'
        "/service007/removeNotiCount";
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{ "userid": "' +
        uu +
        '", "sessionID":"' +
        "" +
        '", "customerNo":"' +
        "" +
        '", "totalCount":"' +
        "0" +
        '", "currentPage":"' +
        "" +
        '", "pageSize":"' +
        "" +
        '", "pageCount":"' +
        "0" +
        '" }';
    http.Response response = await http
        .post(url, headers: headers, body: json)
        .catchError((Object error) {
      print(error.toString());
      snackbarfalse(error.toString());
    });
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      String body = response.body;
      var data = jsonDecode(body);
      print(data);
      setState(() {
        ncount = data['count'];
        if (ncount == 0) {
          ncount = 0;
        }
      });
      print(ncount);
    } else {
      print("Connection Fail");
      setState(() {});
    }
  }

  int _selectedIndex = 0;

  Future<bool> popped() {
    // DateTime now = DateTime.now();
    // if (current == null || now.difference(current) > Duration(seconds: 2)) {
    // current = now;
    // Fluttertoast.showToast(
    //   msg: "Press back Again To exit !",
    //   toastLength: Toast.LENGTH_SHORT,
    // );
    return Future.value(false);
    // } else {
    //   Fluttertoast.cancel();
    //   return Future.value(true);
    // }
  }

  @override
  Widget build(BuildContext context) {
    final _tabs = [
      storeTab(context),
      // messagesTab(),
      contactsTab(),
      // NewFeedsPage(),
      // Text('Tab5'),
    ];
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: colorwhite,
          leading: Builder(
            builder: (context) => IconButton(
              icon: new Icon(Icons.menu, color: colorgreen),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: _selectedIndex == 0
              ? Text(
                  "mWallet",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colorgreen, fontSize: 20),
                )
              : _selectedIndex == 1
                  ? Text(
                      "Contacts",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colorgreen, fontSize: 20),
                    )
                  : _selectedIndex == 2
                      ? Text(
                          "Contacts",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: colorgreen, fontSize: 20),
                        )
                      : Text(
                          "News",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: colorgreen, fontSize: 20),
                        ),
          actions: <Widget>[
            _selectedIndex == 0
                ? ncount == 0
                    ? IconButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Noti()));
                        },
                        iconSize: 25,
                        icon: Icon(
                          Icons.notifications_active,
                          color: colorgreen,
                        ),
                      )
                    : Badge(
                        badgeContent: Text(
                          '$ncount',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        animationType: BadgeAnimationType.slide,
                        position: BadgePosition.topRight(top: 5, right: 8),
                        // badgeColor: Colors.red,
                        child: IconButton(
                          onPressed: () {
                            removeNotiCount();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Noti()));
                          },
                          iconSize: 25,
                          icon: Icon(
                            Icons.notifications_active,
                            color: colorgreen,
                          ),
                        ),
                      )
                : _selectedIndex == 1
                    ? IconButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {},
                        iconSize: 25,
                        icon: Icon(
                          Icons.message,
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                      )
                    : _selectedIndex == 2
                        ? IconButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ContactsCalling()));
                            },
                            iconSize: 25,
                            icon: Icon(
                              Icons.account_circle,
                              color: colorgreen,
                            ),
                          )
                        : IconButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              // Navigator.push(
                              //     context, MaterialPageRoute(builder: (context) => Noti()));
                            },
                            iconSize: 25,
                            icon: Icon(
                              Icons.account_circle,
                              color: Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ),
          ],
        ),
        drawer: _drawer(),
        body: RefreshIndicator(
          onRefresh: () async {
            await refreshing();
          },
          child: _tabs[_selectedIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: false,
          elevation: 0,
          // unselectedItemColor: Colors.white,
          backgroundColor: colorgreen,
          // backgroundColor: Colors.white,
          // backgroundColor: Color(0x00ffffff),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Image.asset("assets/images/wallet-home.png",
                    width: 24, height: 24),
                title: Text(
                  (checklang == "Eng") ? bottombarEng[0] : bottombarMyan[0],
                )),
            // BottomNavigationBarItem(
            //     icon: Image.asset("assets/images/message.png",
            //         width: 24, height: 24),
            //     title: Text(
            //       (checklang == "Eng") ? bottombarEng[1] : bottombarMyan[1],
            //     )),
            BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/images/contact.png",
                  width: 24,
                  height: 24,
                ),
                title: Text(
                  (checklang == "Eng") ? bottombarEng[2] : bottombarMyan[2],
                )),
            // BottomNavigationBarItem(
            //     icon: Image.asset("assets/images/news.png",
            //         width: 24, height: 24),
            //     title: Text(
            //       (checklang == "Eng") ? bottombarEng[3] : bottombarMyan[3],
            //     )),
          ],
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.white,
          onTap: _onItemTapped,
        ));
  }

  Future<TransitionListResponse> getAllList(url, Map jsonMap) async {
    TransitionListResponse p = new TransitionListResponse();
    var body;
    try {
      body = await http.doPost(url, jsonMap);
      p = TransitionListResponse.fromJson(json.decode(body.toString()));
      Map data = jsonDecode(body);
      setState(() {
        locationList = data["data"];
        this.displayArray = this.locationList[0]["txnTypeDesc"].split(',');
      });
    } catch (e) {
      p.code = Constants.responseCode_Error;
      p.desc = e.toString();
    }
    print(p.toMap());
    return p;
  }

  Future<GetBalanceResponse> goBalance(url, Map jsonMap) async {
    GetBalanceResponse p = new GetBalanceResponse();
    var body;
    try {
      body = await http.doPost(url, jsonMap);
      p = GetBalanceResponse.fromJson(json.decode(body.toString()));
    } catch (e) {
      p.messageCode = Constants.responseCode_Error;
      p.messageDesc = e.toString();
    }
    print(p.toMap());
    return p;
  }

  Future scanBarcodeNormal() async {
    String barcodeScanRes = "";
    try {
      //  barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      //     "#ff6666", "Cancel", true, ScanMode.QR,);
      barcodeScanRes = await scanner.scan();
      if (barcodeScanRes != null) {
        if (barcodeScanRes.substring(0, 1) == "{") {
          var route = new MaterialPageRoute(
              builder: (BuildContext context) =>
                  new ScanPayment(value: barcodeScanRes));
          Navigator.of(context).push(route);
        } else {
          print("Success");
        }
      } else {
        scanBarcodeNormal();
      }
      setState(() {
        _scanBarcode = barcodeScanRes;
        print(_scanBarcode);
        alertmsg = _scanBarcode;
        snackbarfalse(alertmsg);
      });
      // } on PlatformException catch(ex){
      //   if(ex.code == BarcodeScanner.CameraAccessDenied){
      //     setState(() {
      //       alertmsg = "The permission was denied.";
      //     });
      //   }else{
      //     setState(() {
      //       alertmsg = "unknown error ocurred $ex";
      //     });
      //   }
    } on FormatException {
      setState(() {
        alertmsg = "Scan canceled, try again !";
        print(alertmsg);
      });
    } catch (e) {
      alertmsg = "Unknown error $e";
      snackbarfalse(e.toString());
    }
    print(barcodeScanRes);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  ListView storeTab(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 0.0),
          height: 770.0,
          child: Stack(
            children: <Widget>[
              Container(
                height: 160,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [colorgreen, Colors.white],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.4, 1]),
                ),
                // color: colorgreen,
                // color: Colors.green,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: <Widget>[
                        SizedBox(width: 35),
                        Column(
                          children: <Widget>[
                            SizedBox(height: 15),
                            GestureDetector(
                              onTap: () {
                                scanBarcodeNormal();
                              },
                              child: Container(
                                child: Image.asset(
                                  "assets/images/scan.png",
                                  width: 45.00,
                                  height: 45.00,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              child: (checklang == "Eng")
                                  ? Text(
                                      (checklang == "Eng")
                                          ? textEng[0]
                                          : textMyan[0],
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          letterSpacing: 1),
                                    )
                                  : Text(
                                      (checklang == "Eng")
                                          ? textEng[0]
                                          : textMyan[0],
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          letterSpacing: 1),
                                    ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 38,
                        ),
                        Column(
                          children: <Widget>[
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => QRPage()));
                                });
                              },
                              child: Container(
                                child: Image.asset(
                                  "assets/images/qr.png",
                                  width: 55.00,
                                  height: 55.00,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              child: (checklang == "Eng")
                                  ? Text(
                                      (checklang == "Eng")
                                          ? textEng[1]
                                          : textMyan[1],
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          letterSpacing: 1),
                                    )
                                  : Text(
                                      (checklang == "Eng")
                                          ? textEng[1]
                                          : textMyan[1],
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          letterSpacing: 1),
                                    ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 38,
                        ),
                        Column(
                          children: <Widget>[
                            SizedBox(height: 5),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TransferContact()));
                                });
                              },
                              child: Container(
                                child: Image.asset(
                                  "assets/images/transfer.png",
                                  width: 65.00,
                                  height: 65.00,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 4),
                            Container(
                              child: (checklang == "Eng")
                                  ? Text(
                                      (checklang == "Eng")
                                          ? textEng[2]
                                          : textMyan[2],
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          letterSpacing: 1),
                                    )
                                  : Text(
                                      (checklang == "Eng")
                                          ? textEng[2]
                                          : textMyan[2],
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          letterSpacing: 1),
                                    ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 38,
                        ),
                        Column(
                          children: <Widget>[
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => billTabPage()));
                                });
                              },
                              child: Container(
                                child: Image.asset(
                                  "assets/images/bill.png",
                                  width: 55.00,
                                  height: 55.00,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              child: (checklang == "Eng")
                                  ? Text(
                                      (checklang == "Eng")
                                          ? textEng[3]
                                          : textMyan[3],
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          letterSpacing: 1),
                                    )
                                  : Text(
                                      (checklang == "Eng")
                                          ? textEng[3]
                                          : textMyan[3],
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          letterSpacing: 1),
                                    ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 38,
                        ),
                        Column(
                          children: <Widget>[
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => QRPage()));
                                });
                              },
                              child: Container(
                                child: Image.asset(
                                  "assets/images/qr.png",
                                  width: 55.00,
                                  height: 55.00,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              child: (checklang == "Eng")
                                  ? Text(
                                      (checklang == "Eng")
                                          ? textEng[4]
                                          : textMyan[4],
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          letterSpacing: 1),
                                    )
                                  : Text(
                                      (checklang == "Eng")
                                          ? textEng[4]
                                          : textMyan[4],
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          letterSpacing: 1),
                                    ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 35,
                        ),
                        Column(
                          children: <Widget>[
                            SizedBox(height: 15),
                            GestureDetector(
                              onTap: () {
                                scanBarcodeNormal();
                              },
                              child: Container(
                                child: Image.asset(
                                  "assets/images/scan.png",
                                  width: 45.00,
                                  height: 45.00,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              child: (checklang == "Eng")
                                  ? Text(
                                      (checklang == "Eng")
                                          ? textEng[5]
                                          : textMyan[5],
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          letterSpacing: 1),
                                    )
                                  : Text(
                                      (checklang == "Eng")
                                          ? textEng[5]
                                          : textMyan[5],
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          letterSpacing: 1),
                                    ),
                            ),
                          ],
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(
                    top: 110.0, left: 15.0, right: 15.0, bottom: 567.0),
                // child: Material(
                //   shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(20.0)),
                //   elevation: 1.0,
                //   color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Card(
                      elevation: 10.0,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              (checklang == "Eng")
                                  ? Text(
                                      (checklang == "Eng")
                                          ? textEng[6]
                                          : textEng[6],
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: colorblack,
                                          fontWeight: FontWeight.w300),
                                    )
                                  : Text(
                                      (checklang == "Eng")
                                          ? textEng[6]
                                          : textEng[6],
                                      style: TextStyle(
                                          fontSize: 14, color: colorblack),
                                    ),
                              Divider(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                                color: colorblack,
                              ),
                              (checklang == "Eng")
                                  ? Text(
                                      "$changeamount" + " " + textEng[7],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  : Text(
                                      "$changeamount" + " " + textEng[7],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    )
                            ],
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
                // ),
              ),
              Container(
                padding: EdgeInsets.only(
                    top: 230.0, left: 15.0, right: 15.0, bottom: 355.0),
                child: Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  elevation: 10.0,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Card(
                        elevation: 10.0,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                (checklang == "Eng")
                                    ? Text(
                                        (checklang == "Eng")
                                            ? textEng[9]
                                            : textMyan[9],
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: colorblack,
                                            fontWeight: FontWeight.w300),
                                      )
                                    : Text(
                                        (checklang == "Eng")
                                            ? textEng[9]
                                            : textMyan[9],
                                        style: TextStyle(
                                            fontSize: 14, color: colorblack),
                                      ),
                                Divider(
                                  height: 25,
                                ),
                                Text(
                                  "$name",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Divider(height: 10),
                                Text(
                                  "$topup",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Divider(
                                  height: 45,
                                ),
                                Text(
                                  "$amount",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Divider(height: 10),
                                Text(
                                  "$datas",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ]),
                        ),
                      ),
                      SizedBox(height: checklang == "Eng" ? 15 : 0),
                      new GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TransitionMain()),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: (checklang == "Eng")
                              ? Text(
                                  (checklang == "Eng")
                                      ? textEng[10]
                                      : textMyan[10],
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: colorblack,
                                      fontWeight: FontWeight.w300),
                                )
                              : Text(
                                  (checklang == "Eng")
                                      ? textEng[10]
                                      : textMyan[10],
                                  style: TextStyle(
                                      fontSize: 12, color: colorblack),
                                ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    top: 435.0, left: 15.0, right: 15.0, bottom: 286.0),
                child: Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  elevation: 1.0,
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Card(
                        color: Colors.white,
                        elevation: 10,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Divider(
                                  height: 4,
                                ),
                                Icon(Icons.people, color: colorgreen),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Divider(
                                  height: 1,
                                ),
                                new GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AgentPage()),
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 16),
                                    child: (checklang == "Eng")
                                        ? Text(
                                            (checklang == "Eng")
                                                ? textEng[11]
                                                : textMyan[11],
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: colorblack,
                                                fontWeight: FontWeight.w300),
                                          )
                                        : Text(
                                            (checklang == "Eng")
                                                ? textEng[11]
                                                : textMyan[11],
                                            style: TextStyle(
                                                fontSize: 12.2,
                                                color: colorblack),
                                          ),
                                  ),
                                )
                              ],
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AgentPage()),
                                    );
                                  },
                                  child: Icon(Icons.keyboard_arrow_right,
                                      color: colorblack),
                                ),
                                Divider(
                                  height: 5,
                                ),
                              ],
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    top: 510.0, left: 15.0, right: 15.0, bottom: 40.0),
                child: Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  elevation: 5.0,
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      (advList == [] || advList == null || advList.length == 0)
                          ? Card(
                              elevation: 2,
                              child: CarouselSlider(
                                height: 160.0,
                                initialPage: 0,
                                enlargeCenterPage: false,
                                autoPlay: true,
                                reverse: false,
                                enableInfiniteScroll: true,
                                autoPlayInterval: Duration(seconds: 3),
                                // autoPlayAnimationDuration:
                                //     Duration(milliseconds: 2000),
                                pauseAutoPlayOnTouch: Duration(seconds: 0),
                                scrollDirection: Axis.horizontal,
                                items: <Widget>[SizedBox(height: 0)],
                                // initialPage: 0,
                              ),
                            )
                          : Card(
                              elevation: 2,
                              // color: Colors.transparent,
                              child: CarouselSlider(
                                height: 160.0,
                                initialPage: 0,
                                enlargeCenterPage: false,
                                autoPlay: true,
                                reverse: false,
                                enableInfiniteScroll: true,
                                autoPlayInterval: Duration(seconds: 3),
                                // autoPlayAnimationDuration:
                                //     Duration(milliseconds: 5000),
                                pauseAutoPlayOnTouch: Duration(seconds: 0),
                                scrollDirection: Axis.horizontal,
                                items: advList.map((imgUrl) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                            // color: Colors.green,
                                            ),
                                        child: Image.network(
                                          '$linkapi' + imgUrl,
                                          // "http://52.187.13.89:8080/WalletService//image//1.jpg",
                                          fit: BoxFit.fill,
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                            )
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _drawer() {
    return Container(
      color: Colors.white,
      child: new SizedBox(
          width: MediaQuery.of(context).size.width * 0.80,
          child: new ListView(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              children: <Widget>[
                Container(
                  height: 200,
                  width: 100,
                  // color: colorgreen,
                  padding: EdgeInsets.all(0),
                  child: new DrawerHeader(
                    margin: EdgeInsets.only(bottom: 0),
                    padding:
                        EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: new BoxDecoration(
                            image: new DecorationImage(
                              image: new AssetImage('assets/images/green1.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Stack(
                                      children: <Widget>[
                                        Positioned(
                                          // bottom: 12.0,
                                          // left: 16.0,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              GestureDetector(
                                                  onTap: () {
                                                    var route =
                                                        new MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                new Profile(
                                                                  value1: '$uu',
                                                                  value2: '$ss',
                                                                ));
                                                    Navigator.of(context)
                                                        .push(route);
                                                  },
                                                  child: CircleAvatar(
                                                    radius: 37,
                                                    backgroundImage: AssetImage(
                                                        'assets/images/user.png'),
                                                  )),
                                              SizedBox(height: 20),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                child: Container(
                                                  child: Text(
                                                    '$ss',
                                                    // overflow: TextOverflow.visible,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        height: 0,
                                                        fontSize: 15.0),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 10, top: 5),
                                                child: Text(
                                                  '$uu',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15.0),
                                                ),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.001,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Stack(
                                      children: <Widget>[
                                        Positioned(
                                          // bottom: 12.0,
                                          // left: 16.0,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () {
                                                  // Navigator.push(
                                                  //   context,
                                                  //   MaterialPageRoute(
                                                  //     builder: (context) =>
                                                  //         Generateqr(),
                                                  //   ),
                                                  // );
                                                },
                                                child: Container(
                                                  child: Image.asset(
                                                      'assets/images/contactqr.png',
                                                      fit: BoxFit.cover,
                                                      height: 75,
                                                      width: 75),
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                child: Text(
                                                  "Version 1.0.15",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15.0),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 10, top: 5),
                                                child: Text(
                                                  "",
                                                  style: TextStyle(
                                                      color: Color(0xFF525252),
                                                      fontSize: 15.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.001),
                ListTile(
                  leading: Icon(Icons.lock, color: colorgreen),
                  title: (checklang == "Eng")
                      ? Text(
                          (checklang == "Eng")
                              ? drawertextEng[0]
                              : drawertextMyan[0],
                          style: TextStyle(
                              fontSize: 15,
                              color: colorblack,
                              fontWeight: FontWeight.w400))
                      : Text(
                          (checklang == "Eng")
                              ? drawertextEng[0]
                              : drawertextMyan[0],
                          style: TextStyle(
                              fontSize: 14,
                              color: colorblack,
                              fontWeight: FontWeight.w400)),
                  trailing: Icon(Icons.chevron_right, color: colorgreen),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AcSecurityPage()),
                    );
                  },
                ),
                Divider(
                  indent: 60,
                  endIndent: 10,
                  color: Colors.blue,
                  height: 5,
                ),
                ListTile(
                  leading: Icon(Icons.settings, color: colorgreen),
                  title: (checklang == "Eng")
                      ? Text(
                          (checklang == "Eng")
                              ? drawertextEng[1]
                              : drawertextMyan[1],
                          style: TextStyle(
                              fontSize: 15,
                              color: colorblack,
                              fontWeight: FontWeight.w400))
                      : Text(
                          (checklang == "Eng")
                              ? drawertextEng[1]
                              : drawertextMyan[1],
                          style: TextStyle(
                              fontSize: 14,
                              color: colorblack,
                              fontWeight: FontWeight.w400)),
                  trailing: Icon(Icons.chevron_right, color: colorgreen),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingPage()),
                    );
                  },
                ),
                Divider(
                  indent: 60,
                  endIndent: 10,
                  color: Colors.blue,
                  height: 5,
                ),
                ListTile(
                  leading: Icon(Icons.location_on, color: colorgreen),
                  title: (checklang == "Eng")
                      ? Text(
                          (checklang == "Eng")
                              ? drawertextEng[2]
                              : drawertextMyan[2],
                          style: TextStyle(
                              fontSize: 15,
                              color: colorblack,
                              fontWeight: FontWeight.w400))
                      : Text(
                          (checklang == "Eng")
                              ? drawertextEng[2]
                              : drawertextMyan[2],
                          style: TextStyle(
                              fontSize: 14,
                              color: colorblack,
                              fontWeight: FontWeight.w400)),
                  trailing: Icon(Icons.chevron_right, color: colorgreen),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => locationPage()),
                    );
                  },
                ),
                Divider(
                  indent: 60,
                  endIndent: 10,
                  color: Colors.blue,
                  height: 5,
                ),
                ListTile(
                  leading: Icon(Icons.loop, color: colorgreen),
                  title: (checklang == "Eng")
                      ? Text(
                          (checklang == "Eng")
                              ? drawertextEng[3]
                              : drawertextMyan[3],
                          style: TextStyle(
                              fontSize: 15,
                              color: colorblack,
                              fontWeight: FontWeight.w400))
                      : Text(
                          (checklang == "Eng")
                              ? drawertextEng[3]
                              : drawertextMyan[3],
                          style: TextStyle(
                              fontSize: 14,
                              color: colorblack,
                              fontWeight: FontWeight.w400)),
                  trailing: Icon(Icons.chevron_right, color: colorgreen),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Exchanerate()));
                  },
                ),
                Divider(
                  indent: 60,
                  endIndent: 10,
                  color: Colors.blue,
                  height: 5,
                ),
                ListTile(
                  leading: Icon(Icons.question_answer, color: colorgreen),
                  title: (checklang == "Eng")
                      ? Text(
                          (checklang == "Eng")
                              ? drawertextEng[4]
                              : drawertextMyan[4],
                          style: TextStyle(
                              fontSize: 15,
                              color: colorblack,
                              fontWeight: FontWeight.w400))
                      : Text(
                          (checklang == "Eng")
                              ? drawertextEng[4]
                              : drawertextMyan[4],
                          style: TextStyle(
                              fontSize: 14,
                              color: colorblack,
                              fontWeight: FontWeight.w400)),
                  trailing: Icon(Icons.chevron_right, color: colorgreen),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FAQ()),
                    );
                  },
                ),
                Divider(
                  indent: 60,
                  endIndent: 10,
                  color: Colors.blue,
                  height: 5,
                ),
                ListTile(
                  leading: Icon(Icons.phone, color: colorgreen),
                  title: (checklang == "Eng")
                      ? Text(
                          (checklang == "Eng")
                              ? drawertextEng[5]
                              : drawertextMyan[5],
                          style: TextStyle(
                              fontSize: 15,
                              color: colorblack,
                              fontWeight: FontWeight.w400))
                      : Text(
                          (checklang == "Eng")
                              ? drawertextEng[5]
                              : drawertextMyan[5],
                          style: TextStyle(
                              fontSize: 14,
                              color: colorblack,
                              fontWeight: FontWeight.w400)),
                  trailing: Icon(Icons.chevron_right, color: colorgreen),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Contact()),
                    );
                  },
                ),
                Divider(
                  indent: 60,
                  endIndent: 10,
                  color: Colors.blue,
                  height: 5,
                ),
                ListTile(
                  leading: Icon(Icons.power_settings_new, color: colorgreen),
                  title: (checklang == "Eng")
                      ? Text(
                          (checklang == "Eng")
                              ? drawertextEng[6]
                              : drawertextMyan[6],
                          style: TextStyle(
                              fontSize: 15,
                              color: colorblack,
                              fontWeight: FontWeight.w400))
                      : Text(
                          (checklang == "Eng")
                              ? drawertextEng[6]
                              : drawertextMyan[6],
                          style: TextStyle(
                              fontSize: 14,
                              color: colorblack,
                              fontWeight: FontWeight.w400)),
                  trailing: Icon(Icons.chevron_right, color: colorgreen),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewLoginPage()),
                    );
                  },
                )
              ])),
    );
  }
}
