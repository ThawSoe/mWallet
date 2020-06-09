import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:nsb/global.dart';
import 'package:nsb/pages/Wallet.dart';
import 'package:nsb/utils/crypt_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QRConfirm extends StatefulWidget {
  final String value, value1, value2, value3;

  QRConfirm(
      {Key key,
      this.value,
      Key key1,
      this.value1,
      Key key2,
      this.value2,
      Key key3,
      this.value3})
      : super(key: key);
  @override
  _CashInConfirmState createState() => _CashInConfirmState();
}

class _CashInConfirmState extends State<QRConfirm> {
  GlobalKey globalKey = new GlobalKey();
  String _scanBarcode = "";
  String _dataString = "Hello from this QR";
  String _inputErrorText;
  String res;
  String checklang = '';
  List textMyan = [
    "ငွေလက်ခံရန်",
    "မိမိထံ ငွေပေးချေရန် QR Scan လုပ်ပါ။",
    "ပိတ်မည်"
  ];
  List textEng = ["Cash In Confirm", "QR scan to pay me", "Close"];

  void initState() {
    setState(() {
      _dataString = '{"amt":"' +
          widget.value +
          '","name":"' +
          widget.value1 +
          '","pay":"' +
          widget.value2 +
          '","ref":"' +
          widget.value3 +
          '"}';
      _inputErrorText = null;
      final iv = AesUtil.random(16);
      print("iv :" + iv);
      final dm = AesUtil.random(16);
      print("dm :" + dm);
      final salt = AesUtil.random(16);
      print("salt :" + salt);
      res = AesUtil.encrypt(salt, iv, this._dataString);
      print("res is :" + res);
    });
    super.initState();
    checkLanguage();
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: colorgreen,
        centerTitle: true,
        title: (checklang == "Eng")
            ? Text(
                (checklang == "Eng") ? textEng[0] : textMyan[0],
                style: TextStyle(fontSize: 19, color: Colors.white,fontWeight: FontWeight.w500),
              )
            : Text(
                (checklang == "Eng") ? textEng[0] : textMyan[0],
                style: TextStyle(fontSize: 17, color: Colors.white,fontWeight: FontWeight.w500),
              ),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(
                Icons.share,
                color: Colors.white,
              ),
              onPressed: _captureAndSharePng)
        ],
      ),
      body: Container(
        color: colorwhite,
        child: new Form(
          key: globalKey,
          child: new ListView(
            children: <Widget>[
              Center(
                child: new Container(
                  padding: EdgeInsets.only(left: 30.0, right: 30.0),
                ),
              ),
              SizedBox(height: 10.0),
              Center(
                  child: Text("${widget.value3}",
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.w500))),
              SizedBox(height: 15.0),
              Center(
                  child: Text("${widget.value2}",
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.w500))),
              SizedBox(height: 30.0),
              Center(
                  child: Text((checklang == "Eng") ? textEng[1] : textMyan[1],
                      style: TextStyle(fontSize: 15.0))),
              SizedBox(height: 30.0),
              Center(
                  child: RepaintBoundary(
                child: QrImage(
                  data: _dataString,
                  backgroundColor: colorwhite,
                  size: 200,
                  gapless: true,
                ),
              )),
              SizedBox(height: 25.0),
              Center(
                  child: Text("${widget.value}" + ".00 MMK",
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.w500))),
              SizedBox(height: 40.0),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  height: 43,
                  child: RaisedButton(
                     shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(10.0),
                     ),
                    color: colorgreen,
                    elevation: 10.0,
                    splashColor: colorblack,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => WalletPage()));
                    },
                    child: (checklang == "Eng")
                        ? Text(
                            (checklang == "Eng") ? textEng[2] : textMyan[2],
                            style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
                          )
                        : Text(
                            (checklang == "Eng") ? textEng[2] : textMyan[2],
                            style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),
                          ),
                    textColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);

      final channel = const MethodChannel('channel:me.alfian.share/share');
      channel.invokeMethod('shareFile', 'image.png');
    } catch (e) {
      print(e.toString());
    }
  }
}
