import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nsb/Link.dart';
import 'package:nsb/global.dart';
import 'package:nsb/pages/skyNetTest/SkynetSuccess.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ConfirmSkynet extends StatefulWidget {
  String payandmonth;
  String cardNo;
  String packageName;
  String voucherType;
  String amount;
  String bankcharges;
  String movieName;
  String mID;
  String mName;
  String subscriptionno;
  String startDate;
  String endDate;
  String movieID;

  ConfirmSkynet(
      {Key key,
      this.payandmonth,
      this.cardNo,
      this.packageName,
      this.voucherType,
      this.amount,
      this.bankcharges,
      this.movieName,
      this.mID,
      this.mName,
      this.subscriptionno,
      this.startDate,
      this.endDate,
      this.movieID})
      : super(key: key);

  @override
  _ConfirmSkynetState createState() => _ConfirmSkynetState();
}

class _ConfirmSkynetState extends State<ConfirmSkynet> {
  double amount;
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  double bankcharges;
  double totalamount;
  String userID;
  String sId;
  String userName;
  bool isLoading = false;
  String checklang = '';
  List textMyan = [
    "အတည်ပြုခြင်း",
    "ကဒ်နံပါတ်",
    "ပက်ကေ့နာမည်",
    "ဘောက်ချာအမျိုးအစား",
    "ငွေပမာဏ",
    "၀န်ဆောင်ခ",
    "စုစုပေါင်း ပမာဏ",
    "ပယ်ဖျက်မည်",
    "လုပ်ဆောင်မည်",
    "ဇာတ်ကားနာမည်"
  ];
  List textEng = [
    "Confirmation",
    "Your Card No",
    "Package Name",
    "Voucher Type",
    "Amount",
    "Bank Charges",
    "Total Amount",
    "CANCEL",
    "CONFIRM",
    "Movie Name"
  ];

  @override
  void initState() {
    if (widget.payandmonth == "1") {
      print("Monthly");
    } else {
      print("PPV");
    }
    amount = double.parse(widget.amount);
    bankcharges = double.parse(widget.bankcharges);
    totalamount = amount + bankcharges;
    super.initState();
    checkLanguage();
  }

  checkLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    checklang = prefs.getString("Lang");
    print("Language $checklang");
    if (checklang == "" || checklang == null || checklang.length == 0) {
      checklang = "Eng";
    } else {
      checklang = checklang;
    }
    setState(() {});
  }
  // void showErrorFloatingFlushbar(BuildContext context, message, sec) {
  //   Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Flushbar(
  //       duration: Duration(seconds: sec),
  //       borderRadius: 8,
  //       backgroundColor: Colors.orange,
  //       boxShadows: [
  //         BoxShadow(
  //           color: Colors.black45,
  //           offset: Offset(3, 3),
  //           blurRadius: 3,
  //         ),
  //       ],
  //       dismissDirection: FlushbarDismissDirection.HORIZONTAL,
  //       forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
  //       // title: title,
  //       message: message,
  //     )..show(context),
  //   );
  // }

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

  submitPPVPayment() async {
    // showSuccessFloatingFlushbar(context, 'Paying', 'Please wait...', 5);
    isLoading = true;
    setState(() {});
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('userId');
    final value1 = prefs.getString('sessionID');
    final value2 = prefs.getString('name');
    userID = value;
    print(userID);
    sId = value1;
    userName = value2;
    final url = '$link' + "/payment/goMerchantPayment";
    final body = json.encode({
      "token": sId,
      "senderCode": userID,
      "merchantID": "M00012",
      "fromName": userName,
      "toName": "SkyNet",
      "currentAmount": amount,
      "bankCharges": widget.bankcharges,
      "amount": totalamount,
      "cardNo": widget.cardNo,
      "subscriptionno": widget.subscriptionno,
      "packagetype": "ppv",
      "moviename": widget.movieName,
      "moviecode": widget.movieName,
      "startdate": widget.startDate,
      "enddate": widget.endDate,
      "usage_service_catalog_identifier__id": widget.movieID
    });
    print("PPV $body");
    http.post(Uri.encodeFull(url), body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((dynamic res) {
      var result = json.decode(res.body);
      print(result);
      if (result['code'] == "0000") {
        isLoading = false;
        setState(() {});
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SkynetSuccess(
                  payandmonth: widget.payandmonth,
                  cardNo: widget.cardNo,
                  amount: widget.amount,
                  totalamount: totalamount.toString(),
                  bankcharges: widget.bankcharges,
                  movieName: widget.movieName,
                  mID: widget.mID,
                  mName: widget.mName,
                  subscriptionno: widget.subscriptionno,
                  startDate: widget.startDate,
                  endDate: widget.endDate,
                  movieID: widget.movieID)),
        );
      } else {
        isLoading = false;
        snackbarfalse(result['desc']);
        // showErrorFloatingFlushbar(context, result['desc'], 3);
        setState(() {});
      }
    }).catchError((Object error) {
      print(error.toString());
      snackbarfalse(error.toString());
    });
  }

  submitMonthly() async {
    isLoading = true;
    setState(() {});
    print("Monthly");
    // showSuccessFloatingFlushbar(context, 'Paying', 'Please wait...', 5);
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString("userId");
    final value1 = prefs.getString("sessionID");
    final value2 = prefs.getString('name');
    userID = value;
    print(userID);
    sId = value1;
    userName = value2;
    final url =
        '$linkapi' + "/WalletService/module001/payment/goMerchantPayment";
    final body = json.encode({
      "token": sId,
      "senderCode": userID,
      "merchantID": "M00012",
      "fromName": userName,
      "toName": widget.mName,
      "currentAmount": widget.amount,
      "bankCharges": widget.bankcharges,
      "amount": totalamount,
      "cardNo": widget.cardNo,
      "packageName": widget.packageName,
      "voucherType": widget.voucherType,
      "subscriptionno": widget.subscriptionno,
      "packagetype": "normal"
    });
    print("Monthly $body");
    http.post(Uri.encodeFull(url), body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((dynamic res) {
      var result = json.decode(res.body);
      print(result);
      if (result['code'] == "0000") {
        isLoading = false;
        setState(() {});
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SkynetSuccess(
                  payandmonth: widget.payandmonth,
                  cardNo: widget.cardNo,
                  packageName: widget.packageName,
                  voucherType: widget.voucherType,
                  amount: widget.amount,
                  totalamount: totalamount.toString(),
                  bankcharges: widget.bankcharges)),
        );
      } else {
        isLoading = false;
        snackbarfalse(result['desc']);
        // showErrorFloatingFlushbar(context, result['desc'], 3);
        setState(() {});
      }
    }).catchError((Object error) {
      print(error.toString());
      snackbarfalse(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    var body = Padding(
      key: _formKey,
      padding: EdgeInsets.all(5),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 0.5),
                        ),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (checklang == "Eng")
                                ? Text(
                                    (checklang == "Eng")
                                        ? textEng[1]
                                        : textMyan[1],
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.grey),
                                  )
                                : Text(
                                    (checklang == "Eng")
                                        ? textEng[1]
                                        : textMyan[1],
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                            SizedBox(height: 10),
                            Text(
                              widget.cardNo,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            )
                          ]),
                    ),
                    (widget.payandmonth == "2")
                        ? Container(
                            padding: EdgeInsets.all(16),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey, width: 0.5),
                              ),
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  (checklang == "Eng")
                                      ? Text(
                                          (checklang == "Eng")
                                              ? textEng[9]
                                              : textMyan[9],
                                          style: TextStyle(
                                              fontSize: 15, color: Colors.grey),
                                        )
                                      : Text(
                                          (checklang == "Eng")
                                              ? textEng[9]
                                              : textMyan[9],
                                          style: TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                  SizedBox(height: 10),
                                  Text(
                                    widget.movieName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  )
                                ]),
                          )
                        : Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(16),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 0.5),
                                  ),
                                ),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      (checklang == "Eng")
                                          ? Text(
                                              (checklang == "Eng")
                                                  ? textEng[2]
                                                  : textMyan[2],
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.grey),
                                            )
                                          : Text(
                                              (checklang == "Eng")
                                                  ? textEng[2]
                                                  : textMyan[2],
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey),
                                            ),
                                      SizedBox(height: 10),
                                      Text(
                                        widget.packageName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      )
                                    ]),
                              ),
                              Container(
                                padding: EdgeInsets.all(16),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 0.5),
                                  ),
                                ),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      (checklang == "Eng")
                                          ? Text(
                                              (checklang == "Eng")
                                                  ? textEng[3]
                                                  : textMyan[3],
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.grey),
                                            )
                                          : Text(
                                              (checklang == "Eng")
                                                  ? textEng[3]
                                                  : textMyan[3],
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey),
                                            ),
                                      SizedBox(height: 10),
                                      Text(
                                        widget.voucherType,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      )
                                    ]),
                              )
                            ],
                          ),
                    Container(
                      padding: EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 0.5),
                        ),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (checklang == "Eng")
                                ? Text(
                                    (checklang == "Eng")
                                        ? textEng[4]
                                        : textMyan[4],
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.grey),
                                  )
                                : Text(
                                    (checklang == "Eng")
                                        ? textEng[4]
                                        : textMyan[4],
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                            SizedBox(height: 10),
                            Text(
                              widget.amount,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            )
                          ]),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 0.5),
                        ),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (checklang == "Eng")
                                ? Text(
                                    (checklang == "Eng")
                                        ? textEng[5]
                                        : textMyan[5],
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.grey),
                                  )
                                : Text(
                                    (checklang == "Eng")
                                        ? textEng[5]
                                        : textMyan[5],
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                            SizedBox(height: 10),
                            Row(children: [
                              Text(
                                widget.bankcharges,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                  child: Text(
                                '',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              )),
                            ])
                          ]),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      width: double.infinity,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (checklang == "Eng")
                                ? Text(
                                    (checklang == "Eng")
                                        ? textEng[6]
                                        : textMyan[6],
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.grey),
                                  )
                                : Text(
                                    (checklang == "Eng")
                                        ? textEng[6]
                                        : textMyan[6],
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                            SizedBox(height: 10),
                            Text(
                              totalamount.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            )
                          ]),
                    ),
                  ]),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: OutlineButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        borderSide: BorderSide(color: colorgreen),
                        color: Colors.white,
                        child: (checklang == "Eng")
                            ? Text(
                                (checklang == "Eng") ? textEng[7] : textMyan[7],
                                style: TextStyle(
                                    fontSize: 15,
                                    color: colorgreen,
                                    fontWeight: FontWeight.w500),
                              )
                            : Text(
                                (checklang == "Eng") ? textEng[7] : textMyan[7],
                                style: TextStyle(
                                    fontSize: 14,
                                    color: colorgreen,
                                    fontWeight: FontWeight.w500),
                              ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: colorgreen,
                        child: (checklang == "Eng")
                            ? Text(
                                (checklang == "Eng") ? textEng[8] : textMyan[8],
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              )
                            : Text(
                                (checklang == "Eng") ? textEng[8] : textMyan[8],
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                        onPressed: () {
                          if (widget.payandmonth == "1") {
                            submitMonthly();
                          } else {
                            submitPPVPayment();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
      appBar: AppBar(
        centerTitle: true,
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
      ),
      body: isLoading ? bodyProgress : body,
    );
  }
}
