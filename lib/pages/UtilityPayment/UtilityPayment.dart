import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:nsb/Link.dart';
import 'package:nsb/global.dart';
import 'package:nsb/pages/UtilityPayment/UtilityPaymentConfirm.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:shared_preferences/shared_preferences.dart';

class UtilityPayment extends StatefulWidget {
  final String value;
  final String value1;
  final String value2;

  UtilityPayment({Key key, this.value, this.value1, this.value2})
      : super(key: key);

  @override
  _UtilityPaymentState createState() => _UtilityPaymentState();
}

class _UtilityPaymentState extends State<UtilityPayment> {
  String id;
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  String text, belatedDays, beneId;
  String alertmsg = "";
  final myControllerno = TextEditingController();
  final myrefno = TextEditingController();
  final mybillId = TextEditingController();
  final mycuname = TextEditingController();
  final mydename = TextEditingController();
  final mybillamount = TextEditingController();
  final mypeamount = TextEditingController();
  final mycommamount = TextEditingController();
  final mytotalamount = TextEditingController();
  final mytaxdesc = TextEditingController();
  final mydueDate = TextEditingController();
  final mynarrative = TextEditingController();
  String checklang = '';
  bool isLoading = false;
  List textMyan = [
    "ငွေးပေးချေမှု",
    "QRစာသားထည့်ရန်",
    "အမှတ်စဥ်",
    "ဘေလ်နံပါတ်",
    "အမည်",
    "အခွန်ဌာန",
    "အခွန်ပမာဏ",
    "ဒဏ်ကြေး",
    "ကော်မရှင် ငွေပမာဏ",
    "စုစုပေါင်း ငွေပမာဏ",
    "အခွန် အမျိုးအစား",
    "ကုန်ဆုံမည့် ရက်စွဲ",
    "အကြောင်းအရာ",
    "လုပ်ဆောင်မည်"
  ];
  List textEng = [
    "Utility Payment",
    "For paste Your QR Text",
    "Reference Number",
    "Bill ID",
    "Customer Name",
    "Department Name",
    "Bill Amount",
    "Penalty Amount",
    "Commission Amount",
    "Total Amount",
    "Tax Description",
    "Due Date",
    "Narrative",
    "SUBMIT"
  ];
  decryptData() async {
    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userId');
    String sessionID = prefs.getString('sessionID');
    id = userID;
    text = myControllerno.text;
    String url = '$link'
        "/service002/decryptData";
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{ "userID": "' +
        userID +
        '", "sessionID": "' +
        sessionID +
        '","data":"' +
        text +
        '" }';
    http.Response response = await http.post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      var data = jsonDecode(body);
      print(data);
      if (data["code"] == "0000") {
        setState(() {
          myrefno.text = data["data"]["refNo"];
          mybillId.text = data["data"]["billId"];
          mycuname.text = data["data"]["cusName"];
          mydename.text = data["data"]["deptName"];
          mybillamount.text = data["data"]["billAmount"];
          mypeamount.text = data["data"]["penalty"];
          mycommamount.text = data["data"]["bankCharges"];
          mytotalamount.text = data["data"]["totalAmount"];
          mytaxdesc.text = data["data"]["taxDesc"];
          mydueDate.text = data["data"]["dueDate"];
          mynarrative.text = data["data"]["desc"];
          belatedDays = data["data"]["belatedDays"];
          beneId = data["data"]["deptAcc"];
          isLoading = false;
        });
      } else {
        this.alertmsg = data["desc"];
        this._showDialog();
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print("Connection Fail");
      isLoading = false;
    }
  }

  @override
  void initState() {
    checkLanguage();
    super.initState();
  }

  scan() async {
    myControllerno.text = await scanner.scan();
    print(myControllerno.text);
    decryptData();
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

  @override
  Widget build(BuildContext context) {
    var scanbody = ListView(
      key: _formKey,
      padding: EdgeInsets.all(15.0),
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                controller: myControllerno,
                decoration: InputDecoration(
                  labelText: (checklang == "Eng") ? textEng[1] : textMyan[1],
                  labelStyle: (checklang == "Eng")
                      ? TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          height: 0,
                          fontWeight: FontWeight.w300)
                      : TextStyle(fontSize: 14, color: Colors.black, height: 0),
                ),
              ),
            ),
            SizedBox(
              width: 50,
              child: RawMaterialButton(
                onPressed: () async {
                  if (myControllerno.text != null &&
                      myControllerno.text != '') {
                    decryptData();
                  } else {
                    scan();
                  }
                },
                child: new Image(
                  height: 25,
                  image: AssetImage("assets/images/scan.png"),
                  color: Colors.white,
                  fit: BoxFit.scaleDown,
                ),
                shape: const StadiumBorder(),
                elevation: 2.0,
                fillColor: colorgreen,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextFormField(
                enabled: false,
                controller: myrefno,
                decoration: InputDecoration(
                  labelText: (checklang == "Eng") ? textEng[2] : textMyan[2],
                  labelStyle: (checklang == "Eng")
                      ? TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          height: 0,
                          fontWeight: FontWeight.w300)
                      : TextStyle(fontSize: 14, color: Colors.black, height: 0),
                ),
                style: TextStyle(height: 2.0),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: mybillId,
                enabled: false,
                decoration: InputDecoration(
                  labelText: (checklang == "Eng") ? textEng[3] : textMyan[3],
                  labelStyle: (checklang == "Eng")
                      ? TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          height: 0,
                          fontWeight: FontWeight.w300)
                      : TextStyle(fontSize: 14, color: Colors.black, height: 0),
                ),
                style: TextStyle(height: 2.0),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: mycuname,
                enabled: false,
                decoration: InputDecoration(
                  labelText: (checklang == "Eng") ? textEng[4] : textMyan[4],
                  labelStyle: (checklang == "Eng")
                      ? TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          height: 0,
                          fontWeight: FontWeight.w300)
                      : TextStyle(fontSize: 14, color: Colors.black, height: 0),
                ),
                style: TextStyle(height: 2.0),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: mydename,
                enabled: false,
                decoration: InputDecoration(
                  labelText: (checklang == "Eng") ? textEng[5] : textMyan[5],
                  labelStyle: (checklang == "Eng")
                      ? TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          height: 0,
                          fontWeight: FontWeight.w300)
                      : TextStyle(fontSize: 14, color: Colors.black, height: 0),
                ),
                style: TextStyle(height: 2.0),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: mybillamount,
                enabled: false,
                decoration: InputDecoration(
                  labelText: (checklang == "Eng") ? textEng[6] : textMyan[6],
                  labelStyle: (checklang == "Eng")
                      ? TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          height: 0,
                          fontWeight: FontWeight.w300)
                      : TextStyle(fontSize: 14, color: Colors.black, height: 0),
                ),
                style: TextStyle(height: 2.0),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: mypeamount,
                enabled: false,
                decoration: InputDecoration(
                  labelText: (checklang == "Eng") ? textEng[7] : textMyan[7],
                  labelStyle: (checklang == "Eng")
                      ? TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          height: 0,
                          fontWeight: FontWeight.w300)
                      : TextStyle(fontSize: 14, color: Colors.black, height: 0),
                ),
                style: TextStyle(height: 2.0),
              ),
              TextFormField(
                controller: mycommamount,
                enabled: false,
                decoration: InputDecoration(
                  labelText: (checklang == "Eng") ? textEng[8] : textMyan[8],
                  labelStyle: (checklang == "Eng")
                      ? TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          height: 0,
                          fontWeight: FontWeight.w300)
                      : TextStyle(fontSize: 14, color: Colors.black, height: 0),
                ),
                style: TextStyle(height: 2.0),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: mytotalamount,
                enabled: false,
                decoration: InputDecoration(
                  labelText: (checklang == "Eng") ? textEng[9] : textMyan[9],
                  labelStyle: (checklang == "Eng")
                      ? TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          height: 0,
                          fontWeight: FontWeight.w300)
                      : TextStyle(fontSize: 14, color: Colors.black, height: 0),
                ),
                style: TextStyle(height: 2.0),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: mytaxdesc,
                enabled: false,
                decoration: InputDecoration(
                  labelText: (checklang == "Eng") ? textEng[10] : textMyan[10],
                  labelStyle: (checklang == "Eng")
                      ? TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          height: 0,
                          fontWeight: FontWeight.w300)
                      : TextStyle(fontSize: 14, color: Colors.black, height: 0),
                ),
                style: TextStyle(height: 2.0),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: mydueDate,
                enabled: false,
                decoration: InputDecoration(
                  labelText: (checklang == "Eng") ? textEng[11] : textMyan[11],
                  labelStyle: (checklang == "Eng")
                      ? TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          height: 0,
                          fontWeight: FontWeight.w300)
                      : TextStyle(fontSize: 14, color: Colors.black, height: 0),
                ),
                style: TextStyle(height: 2.0),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: mynarrative,
                enabled: false,
                decoration: InputDecoration(
                  labelText: (checklang == "Eng") ? textEng[12] : textMyan[12],
                  labelStyle: (checklang == "Eng")
                      ? TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          height: 0,
                          fontWeight: FontWeight.w300)
                      : TextStyle(fontSize: 14, color: Colors.black, height: 0),
                ),
                style: TextStyle(height: 2.0),
              ),
            ],
          ),
        ),
      ],
    );

    var bodyProgress = new Container(
      child: new Stack(
        children: <Widget>[
          scanbody,
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
      appBar: AppBar(
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
        backgroundColor: colorgreen,
      ),
      body: isLoading ? bodyProgress : scanbody,
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.90,
              height: 43.0,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                onPressed: () {
                  var route = new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new UtilityPaymentConfirm(
                              value: '$beneId',
                              value1: myrefno.text,
                              value2: mybillId.text,
                              value3: mycuname.text,
                              value4: mybillamount.text,
                              value5: mypeamount.text,
                              value6: mycommamount.text,
                              value7: mytotalamount.text,
                              value8: mydename.text,
                              value9: mytaxdesc.text,
                              value10: mydueDate.text,
                              value11: '$belatedDays'));
                  Navigator.of(context).push(route);
                },
                child: (checklang == "Eng")
                    ? Text(
                        (checklang == "Eng") ? textEng[13] : textMyan[13],
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      )
                    : Text(
                        (checklang == "Eng") ? textEng[13] : textMyan[13],
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                color: colorgreen,
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
