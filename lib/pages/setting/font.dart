import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FontPage extends StatefulWidget {
  @override
  _FontPageState createState() => _FontPageState();
}

class _FontPageState extends State<FontPage> {
  String checklang='';
  List textMyan = ["ဖောင့်ချိန်းရန်","ယူနီကုဒ်","ဇော်ဂျီကုဒ်"];
  List textEng = ["Font Setting","Unicode","Zawgyi"];

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
        backgroundColor: Color.fromRGBO(40, 103, 178, 1),
        centerTitle: true,
        title: Text(checklang=="Eng" ? textEng[0] :textMyan[0],style: TextStyle(fontWeight: FontWeight.w300,fontSize: 18),),
      ),
      body: Container(
              color: Colors.white,
              child: Column(
         children: <Widget>[
           SizedBox(height: 10),
              ListTile(
                title:Text(checklang=="Eng" ? textEng[1] : textMyan[1],style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w300)),
                // trailing: Image.asset("assets/images/myan.png"),
                  onTap: (){
                    // Navigator.push(
                    // context,
                    // MaterialPageRoute(builder: (context) => ChangePassword()),
                    // );
                  },
                ),
                Divider(color: Colors.grey,),
                
                ListTile(
                title:Text(checklang=="Eng" ? textEng[2] : textMyan[2],style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w300)),
                // trailing:Icon(Icons.chevron_right,color: Color.fromRGBO(40, 103, 178, 1)),
                  onTap: (){
                    // Navigator.push(
                    // context,
                    // MaterialPageRoute(builder: (context) => ResetPassword()),
                    // );
                  },
                ),
                Divider(color: Colors.grey,),

            ]
              ),
            ),
    );
  }
}