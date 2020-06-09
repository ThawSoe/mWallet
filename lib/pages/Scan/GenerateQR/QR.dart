import 'package:flutter/material.dart';
import 'package:nsb/constants/rout_path.dart' as routes;
import 'package:nsb/global.dart';
import 'package:nsb/pages/Scan/GenerateQR/QRConfirm.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QRPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new CashInPage1();
}

class CashInPage1 extends State<QRPage> {
  final myController = TextEditingController();
  final myrefController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String checklang = '';
  bool _isvalidate=false;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  List textMyan = ["ငွေလက်ခံရန်", "ငွေပမာဏ", "အမှတ်စဥ်", "ကျပ်", "QR ပြမည်", "Please enter amount",];
  List textEng = ["Cash In", "Amount", "Reference", "MMK", "Display QR", "​ငွေပမာဏရိုက်​ထည့်​ပါ"];

  @override
  void initState() {
    super.initState();
    checkLanguage();
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
    final passwordField2 = new TextFormField(
      controller: myController,
      keyboardType: TextInputType.number,
      autofocus: true,
      decoration: InputDecoration(
        icon: Icon(Icons.attach_money),
        errorText: _isvalidate ? checklang=="Eng" ? textMyan[5] :textEng[5] : null,
        errorStyle: TextStyle(wordSpacing: 1,fontSize: 14,fontWeight: FontWeight.w400,color: colorerror),
        suffixText: (checklang == "Eng") ? textEng[3] : textMyan[3],
        labelText: (checklang == "Eng") ? textEng[1] : textMyan[1],
        hasFloatingPlaceholder: true,
        labelStyle: (checklang == "Eng")
            ? TextStyle(fontSize: 15, color: Colors.black,height: 0, fontWeight: FontWeight.w300)
            : TextStyle(fontSize: 14, color: Colors.black, height: 0),
        fillColor: colorblack,
      ),
    );
    final referenceField = new TextFormField(
      controller: myrefController,
      decoration: InputDecoration(
        icon: Icon(Icons.add_box),
        labelText: (checklang == "Eng") ? textEng[2] : textMyan[2],
        hasFloatingPlaceholder: true,
        labelStyle: (checklang == "Eng")
            ? TextStyle(fontSize: 15, color: Colors.black,height: 0, fontWeight: FontWeight.w300)
            : TextStyle(fontSize: 14, color: Colors.black, height: 0),
        fillColor: Colors.black87,
      ),
    );

    final transferbutton = new RaisedButton(
      splashColor: colorblack,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      onPressed: () async {
        final prefs = await SharedPreferences.getInstance();
        String userID = prefs.getString('userId');
        String name = prefs.getString('name');
        setState(() {
        if(myController.text=="" || myController.text==null){
           _isvalidate=true;
        }else{
        _isvalidate=false;
        var route = new MaterialPageRoute(
            builder: (BuildContext context) => new QRConfirm(
                value: myController.text,
                value1: myrefController.text,
                value2: userID,
                value3: name));
        Navigator.of(context).push(route);
        }          
        });
      },
      color: colorgreen,
      textColor: Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.90,
        height: 43,
        child: Center(
          child: (checklang == "Eng")
              ? Text(
                  (checklang == "Eng") ? textEng[4] : textMyan[4],
                  style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
                )
              : Text(
                  (checklang == "Eng") ? textEng[4] : textMyan[4],
                  style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),
                ),
        ),
      ),
    );

    return Scaffold(
      key: _scaffoldkey,
      appBar: new AppBar(
        elevation: 2.0,
        backgroundColor: colorgreen,
        centerTitle: true,
        title: (checklang == "Eng")
            ? Text(
                (checklang == "Eng") ? textEng[0] : textMyan[0],
                style: TextStyle(fontSize: 19, color: Colors.white,fontWeight:FontWeight.w500),
              )
            : Text(
                (checklang == "Eng") ? textEng[0] : textMyan[0],
                style: TextStyle(fontSize: 17, color: Colors.white,fontWeight:FontWeight.w500),
              ),
      ),
      body: Container(
        color: bgcolor,
        child: new Form(
          key: _formKey,
          child: new ListView(
            children: <Widget>[
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                height: _isvalidate==true ? 310 : 290,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 3.0,
                  child: ListView(
                    padding: EdgeInsets.all(5.0),
                    children: <Widget>[
                      Center(
                        child: new Container(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Center(
                        child: new Container(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: passwordField2,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Center(
                        child: new Container(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: referenceField,
                        ),
                      ),
                      SizedBox(height: 40.0),
                      Center(
                        child: new Container(
                          padding: EdgeInsets.only(left: 30.0, right: 30.0),
                          child: transferbutton,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
