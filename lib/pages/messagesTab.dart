import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nsb/Link.dart';
import 'package:nsb/pages/messagesDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class messagesTab extends StatefulWidget {
  @override
  _messagesTabState createState() => _messagesTabState();
}
class _messagesTabState extends State<messagesTab> {
  var contactList=[];
  var datas;
  bool isLoading = true;
    void initState(){
    super.initState();
    getInfo();
  }
  getInfo() async{
    final prefs = await SharedPreferences.getInstance();
    String sysKey=prefs.getString('sKey');
    print(sysKey);
    String url = '$linkapi'+"/chatting/api/v1/serviceChat/searchChatList1?syskey=218387&role=&domain=DC001&appId=010";
    print(url);
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{ "start": "' + "11" + '", "end":"' + "10" + '"}';
    http.Response response = await http.post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    print(statusCode);
    if (statusCode == 200) {
      isLoading = false;
      String body = utf8.decode(response.bodyBytes);
      var data = jsonDecode(body);
      // date1 = data["expirydate"];
      setState(() {
        contactList=data["data"];
        print(contactList);
       });
    }
    else {
      print("Connection Fail");
      isLoading = true;
    }
  }
  @override
  Widget build(BuildContext context) {

    var messagebody = ListView.builder(
              itemCount: contactList.length,
              itemBuilder: (BuildContext context,int index){
                return Column(
                children: <Widget>[
                ListTile(
                  leading:CircleAvatar(
                  radius: 35.0,
                  backgroundColor: Color.fromRGBO(40, 103, 178, 1),                 
                  ) ,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  title:Text(contactList[index]["person"][0]["t2"],style: TextStyle(fontSize: 16.0 ,fontWeight:FontWeight.w500,color: Colors.black)) ,
                  subtitle: Text(contactList[index]["t3"],style: TextStyle(fontSize: 14.0 ,fontWeight:FontWeight.w300,color: Colors.black)) ,
                  trailing: Text(contactList[index]["t8"]+"\n\n"+DateFormat.yMMMd().format(DateTime.parse(contactList[index]["modifiedDate"])),style: TextStyle(fontSize: 14.0 ,fontWeight:FontWeight.w300,color: Colors.black)),
                  onTap: () => {Navigator.push(context,MaterialPageRoute(builder: (context) => messageDetailPage()),),
                  },
                ),
                Divider(color: Colors.grey,),
                ],
                );
              },            
            );

    var bodyProgress = new Container(
      child: new Stack(
        children: <Widget>[
          messagebody,
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
      body: isLoading ? bodyProgress : messagebody
            //   body:ListView.builder(
            //   itemCount: contactList.length,
            //   itemBuilder: (BuildContext context,int index){
            //     return Column(
            //     children: <Widget>[
            //     ListTile(
            //       leading:CircleAvatar(
            //       radius: 35.0,
            //       backgroundColor: Color.fromRGBO(40, 103, 178, 1),                 
            //       ) ,
            //       contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            //       title:Text(contactList[index]["person"][0]["t2"],style: TextStyle(fontSize: 16.0 ,fontWeight:FontWeight.w500,color: Colors.black)) ,
            //       subtitle: Text(contactList[index]["t3"],style: TextStyle(fontSize: 14.0 ,fontWeight:FontWeight.w300,color: Colors.black)) ,
            //       trailing: Text(contactList[index]["t8"]+"\n\n"+DateFormat.yMMMd().format(DateTime.parse(contactList[index]["modifiedDate"])),style: TextStyle(fontSize: 14.0 ,fontWeight:FontWeight.w300,color: Colors.black)),
            //       onTap: () => {Navigator.push(context,MaterialPageRoute(builder: (context) => messageDetailPage()),),
            //       },
            //     ),
            //     Divider(color: Colors.grey,),
            //     ],
            //     );
            //   },            
            // ),
    );
  }
}