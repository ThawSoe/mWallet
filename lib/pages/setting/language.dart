import 'package:flutter/material.dart';
import 'package:nsb/global.dart';
import 'package:nsb/pages/Wallet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguagePage extends StatefulWidget {
  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String checklang = '';
  List textMyan = ["ဘာသာစကားပြင်​​ရန်", "English", "မြန်မာ​"];
  List textEng = ["Language Setting", "English", "Myanmar"];

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
  void initState() {
    super.initState();
    checkLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorgreen,
        centerTitle: true,
        title: Text(
          checklang == "Eng" ? textEng[0] : textMyan[0],
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 19),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(children: <Widget>[
          SizedBox(height: 10),
          ListTile(
            // leading:CircleAvatar(
            //   radius: 30.0,
            //   ) ,
            title: Text(checklang == "Eng" ? textEng[1] : textMyan[1],
                style: TextStyle(
                    fontSize: 15,
                    color: colorblack,
                    fontWeight: checklang == "Eng"
                        ? FontWeight.w500
                        : FontWeight.w300)),
            trailing: Container(
              // width: 60,
              // child: Image.asset('assets/images/eng.png')
              child: Icon(
                Icons.done_all,
                color: checklang == "Eng" ? colorgreen : colorwhite,
                size: 30.0,
              ),
            ),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              checklang = "Eng";
              prefs.setString("Lang", checklang);
              setState(() {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WalletPage()));
              });
              print(prefs.getString("Lang"));
            },
          ),
          Divider(
            color: Colors.blue,
            indent: 20,
            endIndent: 20,
          ),
          SizedBox(height: 5),
          ListTile(
            // leading:CircleAvatar(
            //   radius: 30.0,
            //   ),
            title: Text(checklang == "Eng" ? textEng[2] : textMyan[2],
                style: TextStyle(
                    fontSize: 15,
                    color: colorblack,
                    fontWeight: checklang == "Myan"
                        ? FontWeight.w500
                        : FontWeight.w300)),
            trailing: Container(
              // width: 65,
              // child: Image.asset('assets/images/myan.png')
              child: Icon(
                Icons.done_all,
                color: checklang == "Myan" ? colorgreen : colorwhite,
                size: 30.0,
              ),
            ),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              checklang = "Myan";
              prefs.setString("Lang", checklang);
              setState(() {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WalletPage()));
              });
              print(prefs.getString("Lang"));
            },
          ),
          Divider(
            color: Colors.blue,
            indent: 20,
            endIndent: 20,
          ),
        ]),
      ),
    );
  }
}
