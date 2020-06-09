import 'package:flutter/material.dart';
import 'package:nsb/global.dart';
import 'package:nsb/pages/setting/font.dart';
import 'package:nsb/pages/setting/language.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String checklang = '';
  List textMyan = ["ပြင်​ဆင်​ရန်", "ဘာသာစကား", "​ဖောင့်ပြောင်းရန်​"];
  List textEng = ["Setting", "Language", "Font"];

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
          ListTile(
            title: Text(checklang == "Eng" ? textEng[1] : textMyan[1],
                style: TextStyle(
                    fontSize: 15,
                    color: colorblack,
                    fontWeight: FontWeight.w300)),
            trailing: Icon(Icons.chevron_right, color: colorgreen),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LanguagePage()),
              );
            },
          ),
          Divider(
            color: Colors.blue,
            indent: 20,
            endIndent: 20,
          ),

          // ListTile(

          // title:Text(checklang=="Eng" ? textEng[2] : textMyan[2],style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w300)),

          // trailing:Icon(Icons.chevron_right,color: colorgreen),
          //   onTap: (){
          //     Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => FontPage()),
          //     );
          //   },
          // ),
          // Divider(color: Colors.grey,),
        ]),
      ),
    );
  }
}
