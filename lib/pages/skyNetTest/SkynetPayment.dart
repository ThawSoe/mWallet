import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nsb/Link.dart';
import 'package:nsb/global.dart';
import 'package:nsb/pages/Wallet.dart';
import 'package:nsb/pages/skyNetTest/confirmskynet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SkyNetPayment extends StatefulWidget {
  var result;
  String cardNo;
  String cycleState;
  String provisioningprovider;
  String identifierNumber;
  String serviceidentifier;
  String mID;
  String mName;
  String subscriptionno;
  String bankCharges;

  SkyNetPayment(
      {Key key,
      this.result,
      this.cardNo,
      this.cycleState,
      this.provisioningprovider,
      this.identifierNumber,
      this.serviceidentifier,
      this.mID,
      this.mName,
      this.subscriptionno,
      this.bankCharges})
      : super(key: key);
  @override
  _SkyNetPaymentState createState() => _SkyNetPaymentState();
}

class _SkyNetPaymentState extends State<SkyNetPayment> {
  final _formKey = GlobalKey<FormState>();
  String _value = 'month';
  String _mthvalue;
  String payandmonth = "1";
  String userID = '';
  String sId = '';
  String selectedmovie;
  String date1;
  String selectedmonth;
  String hintmonth;
  String userName;
  String movieID;
  String reqstartDate;
  String reqendDate;
  String reqamount;
  String reqamount1;
  String reqmonth;
  String reqpackage;
  TextEditingController cardNo = TextEditingController();
  TextEditingController availablepackage = TextEditingController();
  TextEditingController expiryDate = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController amount1 = TextEditingController();
  bool isLoading = false;
  List durationList = [];
  List amountList = [];
  List voucherList = [];
  List movieList = [];
  List movienameList = [];
  List startDateList = [];
  List endDateList = [];
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  String checklang = '';
  List textMyan = [
    "Skynet ငွေပေးချေမှု",
    "ကဒ်နံပါတ်",
    "သက်တမ်းကုန်မည့် နေ့ရက်/အချိန်",
    "ပက်​ကေ့ အမျိုးအစား",
    "ပက်​ကေ့နာမည်",
    "​ကြာမြင့်ချိန်",
    "ပမာဏ",
    "ပြန်စမည်",
    "လုပ်ဆောင်မည်",
    "ဇာတ်ကားနာမည်",
    "စတင်သုံစွဲသည့် နေ့ရက်/အချိန်",
    "ပြီးဆုံးသည့် နေ့ရက်/အချိန်",
  ];
  List textEng = [
    "Skynet Payment",
    "Card No.",
    "Expirary Date Time",
    "Package Type",
    "Available Packages",
    "Duration",
    "Amount",
    "RESET",
    "SUBMIT",
    "Movie Name",
    "Start Date Time",
    "End Date Time",
  ];

  @override
  void initState() {
    getData();
    print(widget.cycleState);
    print(widget.provisioningprovider);
    print(widget.identifierNumber);
    print(widget.serviceidentifier);
    checkLanguage();
    super.initState();
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
    // print(lang);
    if (checklang == "" || checklang == null || checklang.length == 0) {
      checklang = "Eng";
    } else {
      checklang = checklang;
    }
    setState(() {});
  }

    _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Warning! "),
          content: new Text("There is no movies.You already purchased !"),
          actions: <Widget>[
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

  getData() {
    var data = widget.result;
    voucherList = data['voucherlist'];
    reqmonth = voucherList[0]['alternative_code'];
    var mont = voucherList[0]['alternative_code'];
    var mont1 = mont.toString().split("-");
    hintmonth = mont1[1];
    availablepackage.text = data['currentpackage'];
    reqpackage = data['currentpackage'];
    if (data['expirydate'] == "" ||
        data['expirydate'] == null ||
        data['expirydate'].length == 0) {
    } else {
      var eDate = data['expirydate'];
      print("EDate ====> $eDate");
      var date = eDate.split("T");
      var date1 = date[0];
      var date2 = date[1];
      expiryDate.text = date1 + " " + date2;
    }
    // expiryDate.text = data['expirydate'];
    cardNo.text = widget.cardNo;
    var data1 = data['voucherlist'];
    for (var i = 0; i < data1.length; i++) {
      amountList.add(data1[i]['value']);
      durationList.add(data1[i]['alternative_code']);
    }
    amount.text = amountList[0];
    reqamount1 = amountList[0];
    print("amountList ==>> $amountList");
    print("durationList ==> $durationList");
    setState(() {});
    // for(var i = 0 ; i < data.length; i++){

    // }
  }

  // submitPPVPayment() async {
  //   // showSuccessFloatingFlushbar(context, 'Paying', 'Please wait...', 5);
  //   final prefs = await SharedPreferences.getInstance();
  //   final value = prefs.getString("userId");
  //   final value1 = prefs.getString("sessionID");
  //   final value2 = prefs.getString('name');
  //   userID = value;
  //   print(userID);
  //   sId = value1;
  //   userName = value2;
  //   final url = '$linkapi'+
  //       "/AppService/module001/payment/goMerchantPayment";
  //   final body = json.encode({
  //     "token": sId,
  //     "senderCode": userID,
  //     "merchantID": widget.mID,
  //     "fromName": userName,
  //     "toName": widget.mName,
  //     "currentAmount": reqamount,
  //     "bankCharges": widget.bankCharges,
  //     "amount": int.parse(reqamount) + int.parse(widget.bankCharges),
  //     "cardNo": widget.cardNo,
  //     "subscriptionno": widget.subscriptionno,
  //     "packagetype": "ppv",
  //     "moviename": selectedmovie,
  //     "moviecode": selectedmovie,
  //     "startdate": reqstartDate,
  //     "enddate": reqendDate,
  //     "usage_service_catalog_identifier__id": movieID
  //   });

  //   http.post(Uri.encodeFull(url), body: body, headers: {
  //     "Accept": "application/json",
  //     "content-type": "application/json"
  //   }).then((dynamic res) {
  //     var result = json.decode(res.body);
  //     print(result);
  //     if (result['code'] == "0000") {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => WalletPage()),
  //       );
  //     }
  //   });
  // }

  // submitMonthly() async {
  //   // showSuccessFloatingFlushbar(context, 'Paying', 'Please wait...', 5);
  //   final prefs = await SharedPreferences.getInstance();
  //   final value = prefs.getString("userId");
  //   final value1 = prefs.getString("sessionID");
  //   final value2 = prefs.getString('name');
  //   userID = value;
  //   print(userID);
  //   sId = value1;
  //   userName = value2;
  //   final url = '$linkapi' +
  //       "/AppService/module001/payment/goMerchantPayment";
  //   final body = json.encode({
  //     "token": sId,
  //     "senderCode": userID,
  //     "merchantID": widget.mID,
  //     "fromName": userName,
  //     "toName": widget.mName,
  //     "currentAmount": reqamount1,
  //     "bankCharges": widget.bankCharges,
  //     "amount": int.parse(reqamount1) + int.parse(widget.bankCharges),
  //     "cardNo": widget.cardNo,
  //     "packageName": reqpackage,
  //     "voucherType": reqmonth,
  //     "subscriptionno": widget.subscriptionno,
  //     "packagetype": "normal"
  //   });

  //   http.post(Uri.encodeFull(url), body: body, headers: {
  //     "Accept": "application/json",
  //     "content-type": "application/json"
  //   }).then((dynamic res) {
  //     var result = json.decode(res.body);
  //     print(result);
  //     if (result['code'] == "0000") {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => WalletPage()),
  //       );
  //     }
  //   });
  // }

  // void showSuccessFloatingFlushbar(BuildContext context, title, message, sec) {
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
  //       title: title,
  //       message: message,
  //     )..show(context),
  //   );
  // }

  getPayPerViewData() async {
    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString("userId");
    final value1 = prefs.getString("sessionID");
    userID = value;
    print(userID);
    sId = value1;
    print(sId);
    final url = '$linkapi' +
        "/AppService/module001/serviceskynet/getCatalogListAndAvailablePPV";
    final body = json.encode({
      "userid": userID,
      "sessionid": sId,
      "life_cycle_state": widget.cycleState,
      "provisioning_provider_identifier__alternative_code":
          widget.provisioningprovider,
      "subscription_identifier__number": widget.identifierNumber,
      "termed_service_identifier__alternative_code": widget.serviceidentifier
    });

    http.post(Uri.encodeFull(url), body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((dynamic res) {
      var result = json.decode(utf8.decode(res.bodyBytes));
      print("Movie Result $result");
      if (result['code'] == "0000") {
        setState(() {
          isLoading = false;
        });
        var data = result['movielist'];
        print(data);
        print(data.length);
        // print(data['startdate'].toString());
        for (var i = 0; i < data.length; i++) {
          movieList.add(data[i]);
          print(movieList);
          movienameList.add(data[i]['moviename']);
          startDateList.add(data[i]['startdate']);
          endDateList.add(data[i]['enddate']);
        }
        startDate.text = startDateList[0];
        reqstartDate = startDateList[0];
        amount1.text = movieList[0]['amount'];
        reqamount = movieList[0]['amount'];
        endDate.text = endDateList[0];
        reqendDate = endDateList[0];
        movieID = result['usage_service_catalog_identifier__id'];
        print("Movieeeeeeeeeee $movieID");
        selectedmovie = movienameList[0];
        print(movienameList);
        print(startDateList);
        print(endDateList);
        payandmonth = "2";
      }else{
        isLoading = false;
        _showDialog();
        // payandmonth = "1";
      }
      setState(() {});
    }).catchError((Object error){
       snackbarfalse("Service Call Error"+error.toString());
       print(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {

    var body = new SingleChildScrollView(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            new Flexible(
                              child: TextFormField(
                                controller: cardNo,
                                readOnly: true,
                                decoration: new InputDecoration(
                                  labelText: (checklang == "Eng")
                                      ? textEng[1]
                                      : textMyan[1],
                                  labelStyle: (checklang == "Eng")
                                      ? TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                          height: 0)
                                      : TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          height: 0),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please fill Card No';
                                  }
                                },
                              ),
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.offline_pin,
                                  size: 35,
                                  color: colorgreen,
                                ),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {}
                                  // print("button click!");
                                }),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: expiryDate,
                          readOnly: true,
                          decoration: new InputDecoration(
                            labelText:
                                (checklang == "Eng") ? textEng[2] : textMyan[2],
                            labelStyle: (checklang == "Eng")
                                ? TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                    height: 0)
                                : TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    height: 0),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          // padding:
                          // EdgeInsetsDirectional.fromSTEB(15, 0, 15, 15),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              (checklang == "Eng")
                                  ? Text(
                                      (checklang == "Eng")
                                          ? textEng[3]
                                          : textMyan[3],
                                      style: TextStyle(fontSize: 14),
                                    )
                                  : Text(
                                      (checklang == "Eng")
                                          ? textEng[3]
                                          : textMyan[3],
                                      style: TextStyle(fontSize: 12),
                                    ),
                              DropdownButton<String>(
                                isExpanded: true,
                                items: [
                                  DropdownMenuItem<String>(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 15.0),
                                      child: Text(
                                        'Monthly Package',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    value: 'month',
                                  ),
                                  DropdownMenuItem<String>(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 15.0),
                                      child: Text(
                                        'Pay Per View Package',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    value: 'payper',
                                  ),
                                ],
                                onChanged: (String value) {
                                  setState(() {
                                    _value = value;
                                    if (_value == "payper") {
                                      print(payandmonth);
                                      if (movieList.length == 0) {
                                        getPayPerViewData();
                                      } else {
                                        payandmonth = "2";
                                      }
                                    } else if (_value == "month") {
                                      payandmonth = "1";
                                      print(payandmonth);
                                    }
                                  });
                                },
                                hint: Text('Select Item'),
                                value: _value,
                                underline: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        (payandmonth == "2")
                            ? Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          (checklang == "Eng")
                                              ? Text(
                                                  (checklang == "Eng")
                                                      ? textEng[9]
                                                      : textMyan[9],
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                )
                                              : Text(
                                                  (checklang == "Eng")
                                                      ? textEng[9]
                                                      : textMyan[9],
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                          new DropdownButton(
                                            isExpanded: true,
                                            items: movieList.map((item) {
                                              // date1 = item['startdate'];
                                              return new DropdownMenuItem(
                                                child:
                                                    new Text(item['moviename']),
                                                value: item['moviename']
                                                    .toString(),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              // startDate.text = date1;
                                              setState(() {
                                                selectedmovie = value;
                                                for (var i = 0;
                                                    i < movieList.length;
                                                    i++) {
                                                  if (movieList[i]
                                                          ['moviename'] ==
                                                      selectedmovie) {
                                                    var date = movieList[i]
                                                            ['startdate']
                                                        .toString()
                                                        .split("T");
                                                    reqstartDate = movieList[i]
                                                        ['startDate'];
                                                    startDate.text =
                                                        date[0] + " " + date[1];
                                                    reqendDate =
                                                        movieList[i]['enddate'];
                                                    movieID =
                                                        movieList[i]['id'];
                                                    var date1 = movieList[i]
                                                            ['enddate']
                                                        .toString()
                                                        .split("T");
                                                    endDate.text = date1[0] +
                                                        " " +
                                                        date[1];
                                                    reqamount =
                                                        movieList[i]['amount'];
                                                    amount1.text =
                                                        movieList[i]['amount'];
                                                  }
                                                }
                                              });
                                            },
                                            value: selectedmovie.toString(),
                                            underline: Container(
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors.grey),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                    controller: startDate,
                                    readOnly: true,
                                    decoration: new InputDecoration(
                                      labelText: (checklang == "Eng")
                                          ? textEng[10]
                                          : textMyan[10],
                                      labelStyle: (checklang == "Eng")
                                          ? TextStyle(
                                              fontSize: 17,
                                              color: Colors.black,
                                              height: 0)
                                          : TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              height: 0),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 1.0),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 1.0),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    controller: endDate,
                                    readOnly: true,
                                    decoration: new InputDecoration(
                                      labelText: (checklang == "Eng")
                                          ? textEng[11]
                                          : textMyan[11],
                                      labelStyle: (checklang == "Eng")
                                          ? TextStyle(
                                              fontSize: 17,
                                              color: Colors.black,
                                              height: 0)
                                          : TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              height: 0),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 1.0),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 1.0),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  TextFormField(
                                    controller: amount1,
                                    readOnly: true,
                                    decoration: new InputDecoration(
                                      labelText: "Amount",
                                      labelStyle: TextStyle(color: Colors.grey),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 1.0),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 1.0),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    readOnly: true,
                                    controller: availablepackage,
                                    decoration: new InputDecoration(
                                      labelText: (checklang == "Eng")
                                          ? textEng[4]
                                          : textMyan[4],
                                      labelStyle: (checklang == "Eng")
                                          ? TextStyle(
                                              fontSize: 17,
                                              color: Colors.black,
                                              height: 0)
                                          : TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              height: 0),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 1.0),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 1.0),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 10, 0, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        (checklang == "Eng")
                                            ? Text(
                                                (checklang == "Eng")
                                                    ? textEng[5]
                                                    : textMyan[5],
                                                style: TextStyle(fontSize: 14),
                                              )
                                            : Text(
                                                (checklang == "Eng")
                                                    ? textEng[5]
                                                    : textMyan[5],
                                                style: TextStyle(fontSize: 11),
                                              ),
                                        new DropdownButton(
                                          isExpanded: true,
                                          items: voucherList.map((item) {
                                            return new DropdownMenuItem(
                                              child: new Text(
                                                  item['alternative_code']
                                                      .split("-")[1]),
                                              value: item['id'].toString(),
                                            );
                                          }).toList(),
                                          onChanged: (newVal) {
                                            setState(() {
                                              selectedmonth = newVal;
                                              for (var i = 0;
                                                  voucherList.length > i;
                                                  i++) {
                                                if (voucherList[i]['id'] ==
                                                    selectedmonth) {
                                                  reqamount1 =
                                                      voucherList[i]['value'];
                                                  reqmonth = voucherList[i]
                                                      ['alternative_code'];
                                                  amount.text =
                                                      voucherList[i]['value'];
                                                }
                                              }
                                            });
                                          },
                                          hint: Text(
                                            "1MONTH",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          value: selectedmonth,
                                          underline: Container(
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  TextFormField(
                                    controller: amount,
                                    readOnly: true,
                                    decoration: new InputDecoration(
                                      labelText: (checklang == "Eng")
                                          ? textEng[6]
                                          : textMyan[6],
                                      labelStyle: (checklang == "Eng")
                                          ? TextStyle(
                                              fontSize: 17,
                                              color: Colors.black,
                                              height: 0)
                                          : TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              height: 0),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 1.0),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 1.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                              "Note : Including 5% Government commercial tax."),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 15),
                          child: OutlineButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                            borderSide: BorderSide(color: colorgreen),
                            color: Colors.white,
                            child: (checklang == "Eng")
                                ? Text(
                                    (checklang == "Eng")
                                        ? textEng[7]
                                        : textMyan[7],
                                    style: TextStyle(
                                        fontSize: 15, color: colorgreen,fontWeight: FontWeight.w500),
                                  )
                                : Text(
                                    (checklang == "Eng")
                                        ? textEng[7]
                                        : textMyan[7],
                                    style: TextStyle(
                                        fontSize: 14, color: colorgreen,fontWeight: FontWeight.w500),
                                  ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                            color: colorgreen,
                            child: (checklang == "Eng")
                                ? Text(
                                    (checklang == "Eng")
                                        ? textEng[8]
                                        : textMyan[8],
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white,fontWeight: FontWeight.w500),
                                  )
                                : Text(
                                    (checklang == "Eng")
                                        ? textEng[8]
                                        : textMyan[8],
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white,fontWeight: FontWeight.w500),
                                  ),
                            onPressed: () {
                              if (payandmonth == "2") {
                                // submitPPVPayment();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ConfirmSkynet(
                                        payandmonth: payandmonth,
                                        cardNo: widget.cardNo,
                                        amount: reqamount,
                                        bankcharges: widget.bankCharges,
                                        movieName: selectedmovie,
                                        mID: widget.mID,
                                        mName: widget.mName,
                                        subscriptionno: widget.subscriptionno,
                                        startDate: reqstartDate,
                                        endDate: reqendDate,
                                        movieID: movieID),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ConfirmSkynet(
                                        payandmonth: payandmonth,
                                        cardNo: widget.cardNo,
                                        packageName: reqpackage,
                                        voucherType: reqmonth,
                                        amount: reqamount1,
                                        mID: widget.mID,
                                        mName: widget.mName,
                                        subscriptionno: widget.subscriptionno,
                                        bankcharges: widget.bankCharges),
                                  ),
                                );
                                // submitMonthly();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.all(10),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Container(
                //         width: 120,
                //         child: OutlineButton(
                //           onPressed: () {},
                //           child: Text(
                //             "RESET",
                //             style: TextStyle(color: Colors.lightBlue),
                //           ),
                //           borderSide: BorderSide(
                //             color: Colors.lightBlue,
                //             style: BorderStyle.solid,
                //             width: 1,
                //           ),
                //         ),
                //       ),
                //       Container(
                //         width: 120,
                //         child: RaisedButton(
                //           color: Colors.lightBlue,
                //           textColor: Colors.white,
                //           child: Text(
                //             "SUBMIT",
                //             style: TextStyle(color: Colors.white),
                //           ),
                //           onPressed: () {
                //             if (payandmonth == "2") {
                //               submitPPVPayment();
                //             } else {
                //               submitMonthly();
                //             }
                //           },
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
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
    
    return Form(
      child: Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          backgroundColor : colorgreen,
          centerTitle: true,
          title: (checklang == "Eng")
              ? Text(
                  (checklang == "Eng") ? textEng[0] : textMyan[0],
                  style: TextStyle(fontSize: 19, color: Colors.white),
                )
              : Text(
                  (checklang == "Eng") ? textEng[0] : textMyan[0],
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
        ),
        body: isLoading ? bodyProgress :body,
      ),
    );
  }
}
