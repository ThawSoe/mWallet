import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nsb/Link.dart';
import 'package:nsb/global.dart';
import 'package:nsb/pages/Wallet.dart';
import 'package:nsb/pages/billTabPage.dart';
import 'package:nsb/pages/skyNet/skynetBeneficiary.dart';
import 'package:nsb/pages/skyNetTest/SkynetPayment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SkyNetPage extends StatefulWidget {
  String mID;
  String mName;
  String cardNo;

  SkyNetPage({Key key, this.mID, this.mName, this.cardNo}) : super(key: key);

  @override
  _SkyNetPageState createState() => _SkyNetPageState();
}

class _SkyNetPageState extends State<SkyNetPage> {
  TextEditingController cardNo = TextEditingController();
  String userId = '';
  String sId = '';
  String checklang = '';
  bool isLoading = false;
  List textMyan = ["Skynet ငွေပေးချေမှု", "ကဒ်နံပါတ်"];
  List textEng = ["Skynet Payment", "Card No."];
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    print(widget.mID);
    print(widget.mName);
    getUIDandSID();
    checkLanguage();
    super.initState();
    if (widget.cardNo == "" ||
        widget.cardNo == null ||
        widget.cardNo.length == 0) {
      cardNo.text = "";
    } else {
      cardNo.text = widget.cardNo;
    }
    setState(() {});
    // this.phone = widget.phoneNo;
  }

  _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Warning! "),
          content: new Text("Invalid Card No !"),
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

  getUIDandSID() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('userId');
    userId = value.toString();
    final value1 = prefs.getString('sessionID');
    sId = value1.toString();
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

  getVoucher() {
    isLoading = true;
    setState(() {});
    var cardN = cardNo.text;
    final url =
        '$linkapi' + '/AppService/module001/serviceskynet/getServiceAndVoucher';
    var body =
        jsonEncode({"userid": userId, "sessionid": sId, "cardno": cardN});
    print(url);
    print(body);
    http.post(Uri.encodeFull(url), body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((dynamic res) {
      var result = json.decode(res.body);
      print("Hello =+=+=+ $result");
      if (result['code'] == "0000") {
        isLoading = false;
        setState(() {});
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SkyNetPayment(
                    result: result,
                    cardNo: cardN,
                    cycleState: result['life_cycle_state_for_catalog_list'],
                    provisioningprovider: result[
                        'alternative_code_provisioning_for_catalog_list'],
                    identifierNumber: result['subscriptionno'],
                    serviceidentifier:
                        result['alternative_code_termed_for_catalog_list'],
                    mID: widget.mID,
                    mName: widget.mName,
                    subscriptionno: result['subscriptionno'],
                    bankCharges: result['bankCharges'])));
      } else {
        isLoading = false;
        _showDialog();
        setState(() {});
        // showErrorFloatingFlushbar(context, result['desc'], 3);
      }
    }).catchError((Object error) {
      print(error.toString());
      snackbarfalse(error.toString());
    });
    //       Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => SecondRoute()),
    // );
    // Navigator.push(context, MaterialPageRoute(builder: (context) => SkyNetPayment()));
  }

  @override
  Widget build(BuildContext context) {
    var body = SingleChildScrollView(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding:
                    EdgeInsets.only(right: 10, top: 10, left: 10, bottom: 10),
                child: Row(
                  children: [
                    new Flexible(
                      child: TextFormField(
                        onChanged: (value) {},
                        controller: cardNo,
                        decoration: new InputDecoration(
                          labelText:
                              (checklang == "Eng") ? textEng[1] : textMyan[1],
                          labelStyle: (checklang == "Eng")
                              ? TextStyle(
                                  fontSize: 15, color: colorblack, height: 0)
                              : TextStyle(
                                  fontSize: 14, color: colorblack, height: 0),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please fill Card No.';
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
                          if (_formKey.currentState.validate()) {
                            getVoucher();
                          }
                          // print("button click!");
                        }),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(1),
              child: Image.asset("assets/images/skynetinfo3.png"),
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
    return Form(
      child: Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => billTabPage()));
            },
          ),
          // iconTheme: IconThemeData(color: Colors.white),
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
          actions: [
            IconButton(
              iconSize: 40,
              icon: Icon(
                Icons.comment,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SkynetBeneficiary(),
                  ),
                );
              },
            ),
          ],
        ),
        body: isLoading ? bodyProgress : body,
      ),
    );
  }
}
