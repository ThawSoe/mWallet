import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nsb/Link.dart';
// import 'package:m_wallet/WalletDrawer/Drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  String checklang = '';
  List textMyan = ["သတင်းများ"];
  List textEng = ["News"];
  String userID = '';
  String sKey = '';
  List newsList = [];
  List newsCount = [];
  bool checklike = false;
  List postSkey = [];
  var userSysKey;
  List<bool> likes = new List<bool>();

  @override
  void initState() {
    checkLanguage();
    getNewFeeds();
    super.initState();
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

  getNewFeeds() async {
    final prefs = await SharedPreferences.getInstance();
    userID = prefs.getString("phone");
    sKey = prefs.getString("skey");
    print(sKey);
    final url = '$linkapi' +
        "/serviceConfiguration/getMenuOrderList?usersk=$sKey&regionCode=00000000";
    var body = json
        .encode({"start": 0, "end": 10, "userPhone": userID, "usersk": sKey});

    http.post(Uri.encodeFull(url), body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((dynamic res) {
      var result = json.decode(utf8.decode(res.bodyBytes));
      newsList = result['menu_arr'][0]['menu_arr'];
      for (int i = 0; i < newsList.length; i++) {
        likes.add(false);
      }
      print(" $likes");
      print(result['menu_arr'][0]['menu_arr']);
      setState(() {});
    });
  }

  payLike() async {
    final prefs = await SharedPreferences.getInstance();
    sKey = prefs.getString("skey");
    print(" SKEY $sKey");
    print("userSyskey  $userSysKey");
    // var sKey = value;
    final url = '$linkapi'+
        "/serviceArticle/clickLikeArticle?key=$userSysKey&userSK=$sKey&type=News";
    http.get(Uri.encodeFull(url), headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((dynamic res) {
      var result = json.decode(utf8.decode(res.bodyBytes));
      print("Likes ===> $result");
      setState(() {
      });
    });
  }

  unLike() async {
    final prefs = await SharedPreferences.getInstance();
    sKey = prefs.getString("skey");
    print(" SKEY $sKey");
    print("userSyskey  $userSysKey");
    // var sKey = value;
    final url = '$linkapi'+
        "/serviceArticle/clickUnlikeArticle?key=$userSysKey&userSK=$sKey&type=News";
    http.get(Uri.encodeFull(url), headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((dynamic res) {
      var result = json.decode(utf8.decode(res.bodyBytes));
      print("Likes ===> $result");
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: PageDrawer(),
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        centerTitle: true,
        title: (checklang == "Eng")
            ? Text(
                (checklang == "Eng") ? textEng[0] : textMyan[0],
                style: TextStyle(fontSize: 20, color: Colors.white),
              )
            : Text(
                (checklang == "Eng") ? textEng[0] : textMyan[0],
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, index) {
          return Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      newsList[index]['t1'],
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "Dec 18, 2019 at 3:14 pm",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    )
                  ],
                ),
              ),
              Divider(
                thickness: 1.1,
              ),
              Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                width: double.infinity,
                child: Text(
                  newsList[index]['t2']
                      .toString()
                      .replaceAll('<p>', "")
                      .replaceAll('&nbsp;', "   ")
                      .replaceAll('</p>', "")
                      .replaceAll("<br />", "\n"),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: TextStyle(
                    fontSize: 15,
                    letterSpacing: .7,
                  ),
                  // style: TextStyle(fontSize: 15),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  "Continued Reading",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                height: 270,
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new NetworkImage(
                        newsList[index]["uploadedPhoto"][0]["t7"]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: 1,
                color: Colors.grey,
                // thickness: 1.1,
              ),
              Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton.icon(
                      onPressed: null,
                      icon: Image.asset("images/liked.png",
                          width: 24, height: 24, color: Colors.grey),
                      label: Text('12K'),
                    ),
                    Text(
                      "7K Comments",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                height: 1,
                color: Colors.grey,
                // thickness: 1.1,
              ),
              Container(
                padding: EdgeInsets.only(left: 50, right: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    (likes[index] == true)
                        ? FlatButton.icon(
                            onPressed: () {
                              userSysKey = newsList[index]['userSyskey'];
                              unLike();
                              likes[index] = false;
                              setState(() {});
                            },
                            icon: Image.asset("images/liked.png",
                                width: 24, height: 24, color: Colors.lightBlue),
                            label: Text(
                              'Like',
                              style: TextStyle(color: Colors.lightBlue),
                            ),
                          )
                        : FlatButton.icon(
                            onPressed: () {
                             userSysKey = newsList[index]['userSyskey'];
                             print(userSysKey);
                              likes[index] = true;
                              payLike();
                              setState(() {});
                            },
                            icon: Image.asset("images/like.png",
                                width: 24, height: 24, color: Colors.grey),
                            label: Text(
                              'Like',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                    FlatButton.icon(
                      onPressed: null,
                      icon: Image.asset("images/comment.png",
                          width: 24, height: 24, color: Colors.grey),
                      label: Text('Comment'),
                    ),
                  ],
                ),
              ),
              // Container(
              //   width: double.infinity,
              //   height: 1,
              //   color: Colors.grey,
              // ),
              Container(
                width: double.infinity,
                height: 8,
                color: Color(0xFFEDF7FD),
              ),
            ],
          );
        },
        itemCount: newsList.length,
      ),
    );
  }
}

// {
//   "arr": null,
//   "totalCount": 0,
//   "currentPage": 0,
//   "pageSize": 0,
//   "state": false,
//   "sessionState": false,
//   "menu_arr": [
//     {
//       "menu_arr": [
//         {
//           "syskey": 1065255,
//           "autokey": 0,
//           "srno": 0,
//           "createdDate": "20200318",
//           "createdTime": "2:20 pm",
//           "modifiedDate": "20200318",
//           "modifiedTime": "2:20 pm",
//           "userId": "mitdemo",
//           "sessionId": "",
//           "userName": "Myanmar Information Technology (mitdemo)",
//           "photo": "",
//           "modifiedUserId": "",
//           "modifiedUserName": "",
//           "recordStatus": 1,
//           "syncStatus": 1,
//           "syncBatch": 0,
//           "userSyskey": 1065255,
//           "t1": "NEWS",
//           "t2": "NEWS",
//           "t3": "Video",
//           "t4": "",
//           "t5": "",
//           "t6": "7.91 KB",
//           "t7": "00:01:32",
//           "t8": "",
//           "t9": "",
//           "t10": "",
//           "t11": "",
//           "t12": "",
//           "t13": "",
//           "n1": 0,
//           "n2": 0,
//           "n3": 0,
//           "n4": 0,
//           "n5": 0,
//           "n6": 0,
//           "n7": 0,
//           "n8": 0,
//           "n9": 0,
//           "n10": 0,
//           "n11": 0,
//           "n12": 0,
//           "n13": 0,
//           "upload": [],
//           "answer": null,
//           "videoUpload": [
//             "20200318/VDO20200318141818.mp4"
//           ],
//           "comData": [],
//           "ansData": null,
//           "cropdata": [],
//           "agrodata": [],
//           "ferdata": [],
//           "towndata": [],
//           "crop": null,
//           "fert": null,
//           "agro": null,
//           "addTown": null,
//           "uploadlist": [],
//           "resizelist": [],
//           "uploadDatalist": [],
//           "uploadedPhoto": [
//             {
//               "syskey": 1065256,
//               "autokey": 0,
//               "createdDate": "20200318",
//               "createdTime": "2:20 pm",
//               "modifiedDate": "20200318",
//               "modifiedTime": "2:20 pm",
//               "userId": "",
//               "userName": "",
//               "recordStatus": 1,
//               "syncStatus": 1,
//               "syncBatch": 0,
//               "userSyskey": 0,
//               "t1": "20200318/IMG20200318142147.jpg",
//               "t2": "20200318/VDO20200318141818.mp4",
//               "t3": "",
//               "t4": "",
//               "t5": "",
//               "t6": "",
//               "t7": "20200318/IMG20200318142147.jpg",
//               "t8": "",
//               "n1": 0,
//               "n2": 1065255
//             }
//           ],
//           "person": [],
//           "replyComment": []
//         },
//         {
//           "syskey": 1065138,
//           "autokey": 0,
//           "srno": 0,
//           "createdDate": "20200107",
//           "createdTime": "2:22 pm",
//           "modifiedDate": "20200318",
//           "modifiedTime": "2:22 pm",
//           "userId": "mitdemo",
//           "sessionId": "",
//           "userName": "Myanmar Information Technology (mitdemo)",
//           "photo": "",
//           "modifiedUserId": "",
//           "modifiedUserName": "",
//           "recordStatus": 1,
//           "syncStatus": 1,
//           "syncBatch": 0,
//           "userSyskey": 1065138,
//           "t1": "NSB New 7Days ",
//           "t2": "7Day Daily - ၇ ရက် နေ့စဉ် သတင်းစာ |",
//           "t3": "Video",
//           "t4": "",
//           "t5": "00000000",
//           "t6": "7.91 KB",
//           "t7": "00:01:05",
//           "t8": "",
//           "t9": "",
//           "t10": "",
//           "t11": "",
//           "t12": "",
//           "t13": "",
//           "n1": 0,
//           "n2": 0,
//           "n3": 0,
//           "n4": 0,
//           "n5": 0,
//           "n6": 0,
//           "n7": 0,
//           "n8": 0,
//           "n9": 0,
//           "n10": 0,
//           "n11": 0,
//           "n12": 0,
//           "n13": 0,
//           "upload": [],
//           "answer": null,
//           "videoUpload": [
//             "20200107/VDO20200107115516.mp4"
//           ],
//           "comData": [],
//           "ansData": null,
//           "cropdata": [],
//           "agrodata": [],
//           "ferdata": [],
//           "towndata": [],
//           "crop": null,
//           "fert": null,
//           "agro": null,
//           "addTown": null,
//           "uploadlist": [],
//           "resizelist": [],
//           "uploadDatalist": [],
//           "uploadedPhoto": [
//             {
//               "syskey": 1065258,
//               "autokey": 0,
//               "createdDate": "20200318",
//               "createdTime": "2:22 pm",
//               "modifiedDate": "20200318",
//               "modifiedTime": "2:22 pm",
//               "userId": "",
//               "userName": "",
//               "recordStatus": 1,
//               "syncStatus": 1,
//               "syncBatch": 0,
//               "userSyskey": 0,
//               "t1": "20200318/IMG20200318142300.jpg",
//               "t2": "20200107/VDO20200107115516.mp4",
//               "t3": "",
//               "t4": "",
//               "t5": "00000000",
//               "t6": "",
//               "t7": "20200318/IMG20200318142300.jpg",
//               "t8": "",
//               "n1": 0,
//               "n2": 1065138
//             }
//           ],
//           "person": [],
//           "replyComment": []
//         },
//         {
//           "syskey": 1055136,
//           "autokey": 0,
//           "srno": 0,
//           "createdDate": "20191218",
//           "createdTime": "3:14 pm",
//           "modifiedDate": "20191218",
//           "modifiedTime": "3:14 pm",
//           "userId": "april",
//           "sessionId": "",
//           "userName": "april",
//           "photo": "",
//           "modifiedUserId": "",
//           "modifiedUserName": "",
//           "recordStatus": 1,
//           "syncStatus": 1,
//           "syncBatch": 0,
//           "userSyskey": 1055136,
//           "t1": "မြန်မာယူနီကုဒ် စံစနစ် ကူးပြောင်း အသုံးပြုရေး အခမ်းအနား",
//           "t2": "<p>မြန်မာ ယူနီကုဒ် စံစနစ် ကူးပြောင်း အသုံးပြုရေး အခမ်းအနားကို ၂၀၁၉ ခုနှစ်၊ အောက်တိုဘာလ (၁) ရက် (အင်္ဂါနေ့) တွင် နေပြည်တော်၊&nbsp; MICC - 2 ၌ ကျင်းပ&nbsp; &nbsp;ပြုလုပ်ခဲ့ရာ e-Government&nbsp; ဦးဆောင်&nbsp; ကော်မတီ&nbsp; နာယက နိုင်ငံတော်၏&nbsp; အတိုင်ပင်ခံ&nbsp; &nbsp;ပုဂ္ဂိုလ်&nbsp; &nbsp; ဒေါ်အောင်ဆန်းစုကြည် တက်ရောက် မိန့်ခွန်း ပြောကြား ခဲ့ပါသည်။</p>",
//           "t3": "News",
//           "t4": "",
//           "t5": "",
//           "t6": "",
//           "t7": "",
//           "t8": "",
//           "t9": "",
//           "t10": "",
//           "t11": "",
//           "t12": "",
//           "t13": "",
//           "n1": 0,
//           "n2": 8,
//           "n3": 2,
//           "n4": 0,
//           "n5": 0,
//           "n6": 0,
//           "n7": 0,
//           "n8": 0,
//           "n9": 0,
//           "n10": 0,
//           "n11": 0,
//           "n12": 0,
//           "n13": 0,
//           "upload": [],
//           "answer": [
//             "Thank",
//             "hi"
//           ],
//           "videoUpload": [],
//           "comData": [],
//           "ansData": null,
//           "cropdata": [],
//           "agrodata": [],
//           "ferdata": [],
//           "towndata": [],
//           "crop": null,
//           "fert": null,
//           "agro": null,
//           "addTown": null,
//           "uploadlist": [],
//           "resizelist": [],
//           "uploadDatalist": [],
//           "uploadedPhoto": [
//             {
//               "syskey": 1055143,
//               "autokey": 0,
//               "createdDate": "20191218",
//               "createdTime": "3:14 pm",
//               "modifiedDate": "20191218",
//               "modifiedTime": "3:14 pm",
//               "userId": "",
//               "userName": "",
//               "recordStatus": 1,
//               "syncStatus": 1,
//               "syncBatch": 0,
//               "userSyskey": 0,
//               "t1": "20191218/IMG20191218103259.jpg",
//               "t2": "",
//               "t3": "1",
//               "t4": "",
//               "t5": "",
//               "t6": "http://122.248.120.16:8080/DigitalMedia/upload/smallImage/contentImage/20191218/IMG20191218103259.jpg",
//               "t7": "http://122.248.120.16:8080/DigitalMedia/upload/smallImage/contentImage/20191218/IMG20191218103259.jpg",
//               "t8": "",
//               "n1": 1055136,
//               "n2": 0
//             }
//           ],
//           "person": [],
//           "replyComment": []
//         },
//         {
//           "syskey": 1045174,
//           "autokey": 0,
//           "srno": 0,
//           "createdDate": "20191214",
//           "createdTime": "4:26 pm",
//           "modifiedDate": "20191214",
//           "modifiedTime": "4:26 pm",
//           "userId": "mitdemo",
//           "sessionId": "",
//           "userName": "Myanmar Information Technology (mitdemo)",
//           "photo": "",
//           "modifiedUserId": "",
//           "modifiedUserName": "",
//           "recordStatus": 1,
//           "syncStatus": 1,
//           "syncBatch": 0,
//           "userSyskey": 1045174,
//           "t1": "What is housing loan?",
//           "t2": "<p>A home loan (or mortgage) is a contract between a borrower and a lender that allows someone to borrow money to buy a house, apartment, condo, or other livable property. A home loan is typically paid back over a term of 10, 15 or 30 years.</p>",
//           "t3": "News",
//           "t4": "",
//           "t5": "",
//           "t6": "",
//           "t7": "",
//           "t8": "",
//           "t9": "",
//           "t10": "",
//           "t11": "",
//           "t12": "",
//           "t13": "",
//           "n1": 0,
//           "n2": 5,
//           "n3": 0,
//           "n4": 0,
//           "n5": 0,
//           "n6": 0,
//           "n7": 0,
//           "n8": 0,
//           "n9": 0,
//           "n10": 0,
//           "n11": 0,
//           "n12": 0,
//           "n13": 0,
//           "upload": [],
//           "answer": null,
//           "videoUpload": [],
//           "comData": [],
//           "ansData": null,
//           "cropdata": [],
//           "agrodata": [],
//           "ferdata": [],
//           "towndata": [],
//           "crop": null,
//           "fert": null,
//           "agro": null,
//           "addTown": null,
//           "uploadlist": [],
//           "resizelist": [],
//           "uploadDatalist": [],
//           "uploadedPhoto": [
//             {
//               "syskey": 1045175,
//               "autokey": 0,
//               "createdDate": "20191214",
//               "createdTime": "4:26 pm",
//               "modifiedDate": "20191214",
//               "modifiedTime": "4:26 pm",
//               "userId": "",
//               "userName": "",
//               "recordStatus": 1,
//               "syncStatus": 1,
//               "syncBatch": 0,
//               "userSyskey": 0,
//               "t1": "20191214/IMG20191214162633.jpg",
//               "t2": "",
//               "t3": "1",
//               "t4": "",
//               "t5": "",
//               "t6": "IMG20191214162612.jpg",
//               "t7": "http://122.248.120.16:8080/DigitalMedia/upload/smallImage/contentImage/20191214/IMG20191214162633.jpg",
//               "t8": "",
//               "n1": 1045174,
//               "n2": 0
//             }
//           ],
//           "person": [],
//           "replyComment": []
//         },
//         {
//           "syskey": 1045172,
//           "autokey": 0,
//           "srno": 0,
//           "createdDate": "20191214",
//           "createdTime": "4:25 pm",
//           "modifiedDate": "20191214",
//           "modifiedTime": "4:25 pm",
//           "userId": "mitdemo",
//           "sessionId": "",
//           "userName": "Myanmar Information Technology (mitdemo)",
//           "photo": "",
//           "modifiedUserId": "",
//           "modifiedUserName": "",
//           "recordStatus": 1,
//           "syncStatus": 1,
//           "syncBatch": 0,
//           "userSyskey": 1045172,
//           "t1": "What is a Hire Purchase?",
//           "t2": "<p>Hire purchase is an arrangement for buying expensive consumer goods, where the buyer makes an initial down payment and pays the balance plus interest in installments. The term hire purchase is commonly used in the United Kingdom and it's more commonly known as an installment plan in the United States. However, there can be a difference between the two: With some installment plans, the buyer gets the ownership rights as soon as the contract is signed with the seller. With hire purchase agreements, the ownership of the merchandise is not officially transferred to the buyer until all the payments have been made.</p>",
//           "t3": "News",
//           "t4": "",
//           "t5": "",
//           "t6": "",
//           "t7": "",
//           "t8": "",
//           "t9": "",
//           "t10": "",
//           "t11": "",
//           "t12": "",
//           "t13": "",
//           "n1": 0,
//           "n2": 2,
//           "n3": 0,
//           "n4": 0,
//           "n5": 0,
//           "n6": 0,
//           "n7": 0,
//           "n8": 0,
//           "n9": 0,
//           "n10": 0,
//           "n11": 0,
//           "n12": 0,
//           "n13": 0,
//           "upload": [],
//           "answer": null,
//           "videoUpload": [],
//           "comData": [],
//           "ansData": null,
//           "cropdata": [],
//           "agrodata": [],
//           "ferdata": [],
//           "towndata": [],
//           "crop": null,
//           "fert": null,
//           "agro": null,
//           "addTown": null,
//           "uploadlist": [],
//           "resizelist": [],
//           "uploadDatalist": [],
//           "uploadedPhoto": [
//             {
//               "syskey": 1045173,
//               "autokey": 0,
//               "createdDate": "20191214",
//               "createdTime": "4:25 pm",
//               "modifiedDate": "20191214",
//               "modifiedTime": "4:25 pm",
//               "userId": "",
//               "userName": "",
//               "recordStatus": 1,
//               "syncStatus": 1,
//               "syncBatch": 0,
//               "userSyskey": 0,
//               "t1": "20191214/IMG20191214162612.jpg",
//               "t2": "",
//               "t3": "1",
//               "t4": "",
//               "t5": "",
//               "t6": "IMG20191214162612.jpg",
//               "t7": "http://122.248.120.16:8080/DigitalMedia/upload/smallImage/contentImage/20191214/IMG20191214162612.jpg",
//               "t8": "",
//               "n1": 1045172,
//               "n2": 0
//             }
//           ],
//           "person": [],
//           "replyComment": []
//         },
//         {
//           "syskey": 1045170,
//           "autokey": 0,
//           "srno": 0,
//           "createdDate": "20191214",
//           "createdTime": "4:24 pm",
//           "modifiedDate": "20191214",
//           "modifiedTime": "4:24 pm",
//           "userId": "mitdemo",
//           "sessionId": "",
//           "userName": "Myanmar Information Technology (mitdemo)",
//           "photo": "",
//           "modifiedUserId": "",
//           "modifiedUserName": "",
//           "recordStatus": 1,
//           "syncStatus": 1,
//           "syncBatch": 0,
//           "userSyskey": 1045170,
//           "t1": "What is a fixed account?",
//           "t2": "<p>Collection of Deposit from public is the main function of banks. Two types of accounts are opened by banks, Demand Deposit account and Time Deposit/Fixed account.When deposit is received for a certain period such account is called a fixed deposit account. Although amount of fixed Deposit account is payable after a fixed period but on request of customer, premature payment is made. On premature payment applicable rate of interest decreases.</p>",
//           "t3": "News",
//           "t4": "",
//           "t5": "",
//           "t6": "",
//           "t7": "",
//           "t8": "",
//           "t9": "",
//           "t10": "",
//           "t11": "",
//           "t12": "",
//           "t13": "",
//           "n1": 0,
//           "n2": 2,
//           "n3": 0,
//           "n4": 0,
//           "n5": 0,
//           "n6": 0,
//           "n7": 0,
//           "n8": 0,
//           "n9": 0,
//           "n10": 0,
//           "n11": 0,
//           "n12": 0,
//           "n13": 0,
//           "upload": [],
//           "answer": null,
//           "videoUpload": [],
//           "comData": [],
//           "ansData": null,
//           "cropdata": [],
//           "agrodata": [],
//           "ferdata": [],
//           "towndata": [],
//           "crop": null,
//           "fert": null,
//           "agro": null,
//           "addTown": null,
//           "uploadlist": [],
//           "resizelist": [],
//           "uploadDatalist": [],
//           "uploadedPhoto": [
//             {
//               "syskey": 1045171,
//               "autokey": 0,
//               "createdDate": "20191214",
//               "createdTime": "4:24 pm",
//               "modifiedDate": "20191214",
//               "modifiedTime": "4:24 pm",
//               "userId": "",
//               "userName": "",
//               "recordStatus": 1,
//               "syncStatus": 1,
//               "syncBatch": 0,
//               "userSyskey": 0,
//               "t1": "20191214/IMG20191214162516.jpg",
//               "t2": "",
//               "t3": "1",
//               "t4": "",
//               "t5": "",
//               "t6": "IMG20191214162516.jpg",
//               "t7": "http://122.248.120.16:8080/DigitalMedia/upload/smallImage/contentImage/20191214/IMG20191214162516.jpg",
//               "t8": "",
//               "n1": 1045170,
//               "n2": 0
//             }
//           ],
//           "person": [],
//           "replyComment": []
//         },
//         {
//           "syskey": 1045168,
//           "autokey": 0,
//           "srno": 0,
//           "createdDate": "20191214",
//           "createdTime": "4:23 pm",
//           "modifiedDate": "20191214",
//           "modifiedTime": "4:23 pm",
//           "userId": "mitdemo",
//           "sessionId": "",
//           "userName": "Myanmar Information Technology (mitdemo)",
//           "photo": "",
//           "modifiedUserId": "",
//           "modifiedUserName": "",
//           "recordStatus": 1,
//           "syncStatus": 1,
//           "syncBatch": 0,
//           "userSyskey": 1045168,
//           "t1": "What Is a Call Deposit Account?",
//           "t2": "<p>A call deposit account is a bank account for investment funds that offers the advantages of both a savings and a checking account. Like a checking account, a call deposit account has no fixed deposit period, provides instant access to funds and allows unlimited withdrawals and deposits. The call deposit also provides the benefits of a savings account through the accrual of interest.</p>",
//           "t3": "News",
//           "t4": "",
//           "t5": "",
//           "t6": "",
//           "t7": "",
//           "t8": "",
//           "t9": "",
//           "t10": "",
//           "t11": "",
//           "t12": "",
//           "t13": "",
//           "n1": 0,
//           "n2": 2,
//           "n3": 1,
//           "n4": 0,
//           "n5": 0,
//           "n6": 0,
//           "n7": 0,
//           "n8": 0,
//           "n9": 0,
//           "n10": 0,
//           "n11": 0,
//           "n12": 0,
//           "n13": 0,
//           "upload": [],
//           "answer": [
//             "Hi"
//           ],
//           "videoUpload": [],
//           "comData": [],
//           "ansData": null,
//           "cropdata": [],
//           "agrodata": [],
//           "ferdata": [],
//           "towndata": [],
//           "crop": null,
//           "fert": null,
//           "agro": null,
//           "addTown": null,
//           "uploadlist": [],
//           "resizelist": [],
//           "uploadDatalist": [],
//           "uploadedPhoto": [
//             {
//               "syskey": 1045169,
//               "autokey": 0,
//               "createdDate": "20191214",
//               "createdTime": "4:23 pm",
//               "modifiedDate": "20191214",
//               "modifiedTime": "4:23 pm",
//               "userId": "",
//               "userName": "",
//               "recordStatus": 1,
//               "syncStatus": 1,
//               "syncBatch": 0,
//               "userSyskey": 0,
//               "t1": "20191214/IMG20191214162428.jpeg",
//               "t2": "",
//               "t3": "1",
//               "t4": "",
//               "t5": "",
//               "t6": "IMG20191214162428.jpeg",
//               "t7": "http://122.248.120.16:8080/DigitalMedia/upload/smallImage/contentImage/20191214/IMG20191214162428.jpeg",
//               "t8": "",
//               "n1": 1045168,
//               "n2": 0
//             }
//           ],
//           "person": [],
//           "replyComment": []
//         },
//         {
//           "syskey": 1045166,
//           "autokey": 0,
//           "srno": 0,
//           "createdDate": "20191214",
//           "createdTime": "4:22 pm",
//           "modifiedDate": "20191214",
//           "modifiedTime": "4:22 pm",
//           "userId": "mitdemo",
//           "sessionId": "",
//           "userName": "Myanmar Information Technology (mitdemo)",
//           "photo": "",
//           "modifiedUserId": "",
//           "modifiedUserName": "",
//           "recordStatus": 1,
//           "syncStatus": 1,
//           "syncBatch": 0,
//           "userSyskey": 1045166,
//           "t1": "What Is a Savings Account?",
//           "t2": "<p>A savings account is an interest-bearing deposit account held at a bank or other financial institution. Though these accounts typically pay a modest interest rate, their safety and reliability make them a great option for parking cash you want available for short-term needs.</p>",
//           "t3": "News",
//           "t4": "",
//           "t5": "",
//           "t6": "",
//           "t7": "",
//           "t8": "",
//           "t9": "",
//           "t10": "",
//           "t11": "",
//           "t12": "",
//           "t13": "",
//           "n1": 0,
//           "n2": 1,
//           "n3": 0,
//           "n4": 0,
//           "n5": 0,
//           "n6": 0,
//           "n7": 0,
//           "n8": 0,
//           "n9": 0,
//           "n10": 0,
//           "n11": 0,
//           "n12": 0,
//           "n13": 0,
//           "upload": [],
//           "answer": null,
//           "videoUpload": [],
//           "comData": [],
//           "ansData": null,
//           "cropdata": [],
//           "agrodata": [],
//           "ferdata": [],
//           "towndata": [],
//           "crop": null,
//           "fert": null,
//           "agro": null,
//           "addTown": null,
//           "uploadlist": [],
//           "resizelist": [],
//           "uploadDatalist": [],
//           "uploadedPhoto": [
//             {
//               "syskey": 1045167,
//               "autokey": 0,
//               "createdDate": "20191214",
//               "createdTime": "4:22 pm",
//               "modifiedDate": "20191214",
//               "modifiedTime": "4:22 pm",
//               "userId": "",
//               "userName": "",
//               "recordStatus": 1,
//               "syncStatus": 1,
//               "syncBatch": 0,
//               "userSyskey": 0,
//               "t1": "20191214/IMG20191214162329.jpg",
//               "t2": "",
//               "t3": "1",
//               "t4": "",
//               "t5": "",
//               "t6": "IMG20191214162329.jpg",
//               "t7": "http://122.248.120.16:8080/DigitalMedia/upload/smallImage/contentImage/20191214/IMG20191214162329.jpg",
//               "t8": "",
//               "n1": 1045166,
//               "n2": 0
//             }
//           ],
//           "person": [],
//           "replyComment": []
//         },
//         {
//           "syskey": 1045164,
//           "autokey": 0,
//           "srno": 0,
//           "createdDate": "20191214",
//           "createdTime": "4:21 pm",
//           "modifiedDate": "20191214",
//           "modifiedTime": "4:21 pm",
//           "userId": "mitdemo",
//           "sessionId": "",
//           "userName": "Myanmar Information Technology (mitdemo)",
//           "photo": "",
//           "modifiedUserId": "",
//           "modifiedUserName": "",
//           "recordStatus": 1,
//           "syncStatus": 1,
//           "syncBatch": 0,
//           "userSyskey": 1045164,
//           "t1": "What Is the Current Account?",
//           "t2": "<p>What Is the Current Account?<br />The current account records a nation's transactions with the rest of the world&mdash;specifically its net trade in goods and services, its net earnings on cross-border investments, and its net transfer payments&mdash;over a defined period of time, such as a year or a quarter. According to Trading Economics, the quarter two 2019 current account of the United States is $-128.2 billion.</p>",
//           "t3": "News",
//           "t4": "",
//           "t5": "",
//           "t6": "",
//           "t7": "",
//           "t8": "",
//           "t9": "",
//           "t10": "",
//           "t11": "",
//           "t12": "",
//           "t13": "",
//           "n1": 0,
//           "n2": 1,
//           "n3": 0,
//           "n4": 0,
//           "n5": 0,
//           "n6": 0,
//           "n7": 0,
//           "n8": 0,
//           "n9": 0,
//           "n10": 0,
//           "n11": 0,
//           "n12": 0,
//           "n13": 0,
//           "upload": [],
//           "answer": null,
//           "videoUpload": [],
//           "comData": [],
//           "ansData": null,
//           "cropdata": [],
//           "agrodata": [],
//           "ferdata": [],
//           "towndata": [],
//           "crop": null,
//           "fert": null,
//           "agro": null,
//           "addTown": null,
//           "uploadlist": [],
//           "resizelist": [],
//           "uploadDatalist": [],
//           "uploadedPhoto": [
//             {
//               "syskey": 1045165,
//               "autokey": 0,
//               "createdDate": "20191214",
//               "createdTime": "4:21 pm",
//               "modifiedDate": "20191214",
//               "modifiedTime": "4:21 pm",
//               "userId": "",
//               "userName": "",
//               "recordStatus": 1,
//               "syncStatus": 1,
//               "syncBatch": 0,
//               "userSyskey": 0,
//               "t1": "20191214/IMG20191214162238.jpg",
//               "t2": "",
//               "t3": "1",
//               "t4": "",
//               "t5": "",
//               "t6": "IMG20191214162238.jpg",
//               "t7": "http://122.248.120.16:8080/DigitalMedia/upload/smallImage/contentImage/20191214/IMG20191214162238.jpg",
//               "t8": "",
//               "n1": 1045164,
//               "n2": 0
//             }
//           ],
//           "person": [],
//           "replyComment": []
//         }
//       ],
//       "menu": "news & media",
//       "menusk": 1
//     }
//   ]
// }
