import 'dart:convert';
import 'package:condition/condition.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nsb/Link.dart';
import 'package:nsb/pages/News/newsFeedsDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NewFeedsPage extends StatefulWidget {
  @override
  _NewFeedsPageState createState() => _NewFeedsPageState();
}

class _NewFeedsPageState extends State<NewFeedsPage> {
  var newsList = [];
  var newCount = [];
  var t0;
  var t1;
  var ans0;
  var ans1;
  var like0;
  var playlike;
  bool isActive = true;
  var color = Colors.blue;
  var userSysKey;
  void initState() {
    super.initState();
    setState(() {
      getInfo();
    });
  }

  getInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userId');
    String sKey = prefs.getString('sKey');
    String url = '$link' +
        "/serviceConfiguration/getMenuOrderList?usersk=$sKey&regionCode=00000000";
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"start": "' +
        '0' +
        '", "end":"' +
        '10' +
        '","userPhone":"' +
        userID +
        '","usersk":"' +
        sKey +
        '"}';
    http.Response response = await http.post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      var data = jsonDecode(body);
      setState(() {
        newsList = data["menu_arr"];
        newCount = newsList[0]["menu_arr"];
        print(newsList);
        // t0 = newsList[0]["menu_arr"][0]["t1"];
        // date = DateFormat.yMMMd().format(DateTime.parse(newsList[0]["menu_arr"][0]["createdDate"]));
        // ans0 = newsList[0]["menu_arr"][0]["t2"];

        // like0 = newsList[0]["menu_arr"][0]["n2"];
        // photo=newsList[0]["menu_arr"][0]["uploadPhoto"][0]["t6"];
      });
    } else {
      print("Connection Fail");
    }
  }

  clickLike() {
    setState(() {});
    if (isActive == true) {
      setState(() {
        isActive == true ? isActive = false : isActive = true;
        getLike();
      });
    } else {
      setState(() {
        isActive == false ? isActive = true : isActive = false;
        getUnLike();
      });
    }
  }

  getLike() async {
    final prefs = await SharedPreferences.getInstance();
    String sKey = prefs.getString('sKey');
    final url = '$link'
        "/serviceArticle/clickLikeArticle?key=$userSysKey&userSK=$sKey&type=News";
    http.get(Uri.encodeFull(url), headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((dynamic res) {
      var result = json.decode(utf8.decode(res.bodyBytes));
      print("result ===> $result");
      setState(() {
        print("Like");
        playlike = result["keyResult"].toString();
      });
    });
  }

  getUnLike() async {
    final prefs = await SharedPreferences.getInstance();
    String sKey = prefs.getString('sKey');
    final url = '$link'
        "/serviceArticle/clickUnlikeArticle?key=$userSysKey&userSK=$sKey&type=News";
    http.get(Uri.encodeFull(url), headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((dynamic res) {
      var result = json.decode(utf8.decode(res.bodyBytes));
      print("result ===> $result");
      setState(() {
        print("UnLike");
        playlike = result["keyResult"].toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                // child: Padding(
                //   padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                itemCount: newCount.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                      ),
                      SizedBox(
                        height: 0,
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     var route = new MaterialPageRoute(
                      //         builder: (BuildContext context) =>
                      //             new NewFeedsDetailPage(
                      //               value: newsList[0]["menu_arr"][index]["t1"],
                      //             ));
                      //     Navigator.of(context).push(route);
                      //   },
                      makeFeed(
                        userName: newsList[0]["menu_arr"][index]["t1"],
                        feedTime: DateFormat.yMMMd().format(DateTime.parse(
                            newsList[0]["menu_arr"][index]["createdDate"])),
                        feedText: newsList[0]["menu_arr"][index]["t2"]
                            .toString()
                            .replaceAll('<p>', '')
                            .replaceAll('</p>', '')
                            .replaceAll('&nbsp;', ''),
                        feedImage: newsList[0]["menu_arr"][index]
                                ["uploadedPhoto"][0]["t7"]
                            .toString(),
                        like: newsList[0]["menu_arr"][index]["n2"].toString(),
                        cmt: newsList[0]["menu_arr"][index]["n3"].toString(),
                        keys: userSysKey = newsList[0]["menu_arr"][index]
                                ["userSyskey"]
                            .toString(),
                      ),
                    ],
                  );
                }
                // ),
                ),
          ),
        ],
      ),
    );
  }

  Widget makeFeed({userName, feedTime, feedText, feedImage, like, cmt, keys}) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 5),
                      Container(
                        width: 380,
                        child: Text(
                          userName,
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[900],
                              height: 1.5,
                              fontWeight: FontWeight.bold,
                              letterSpacing: .7),
                          softWrap: true,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        feedTime,
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    ],
                  )
                ],
              ),
              // IconButton(
              //   icon: Icon(
              //     Icons.more_horiz,
              //     size: 30,
              //     color: Colors.grey[600],
              //   ),
              //   onPressed: () {},
              // )
            ],
          ),
          Divider(
            color: Colors.grey,
            indent: 10,
            endIndent: 10,
          ),
          SizedBox(
            height: 10,
          ),
          Text(feedText,
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                  height: 1.5,
                  letterSpacing: .7)),
          GestureDetector(
            onTap: () {
              setState(() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewFeedsDetailPage(
                              value1: userName,
                              value2: feedTime,
                              value3: feedText,
                              value4: feedImage,
                              // value5: like,
                              // value6: cmt,
                            )));
              });
            },
            child: Text("Continued Reading...",
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.black87,
                    height: 1.5,
                    fontWeight: FontWeight.w300,
                    letterSpacing: .9)),
          ),
          SizedBox(
            height: 20,
          ),
          feedImage != ''
              ? Container(
                  height: 250,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      image: DecorationImage(
                          image: NetworkImage(feedImage),
                          // image: NetworkImage(feedImage),
                          // image: Image.network(feedImage),
                          fit: BoxFit.cover)),
                )
              : Container(),

          SizedBox(
            height: 10,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(width: 10),
                  makeLike(),
                  Transform.translate(
                    offset: Offset(-5, 0),
                    // child: makeLove()
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    isActive == true ? like : playlike,
                    style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                  ),
                  SizedBox(width: 20),
                ],
              ),
              Conditioned(
                cases: [
                  Case(
                    cmt == "1",
                    builder: () => Container(child: Text(cmt + "Comment")),
                  ),
                  Case(
                    cmt != "0",
                    builder: () => Container(child: Text(cmt + "Comments")),
                  ),
                  Case(
                    cmt == "0",
                    builder: () => Container(child: Text("")),
                  ),
                ],
                defaultBuilder: () => null,
              ),
            ],
          ),
          // SizedBox(
          //   height: 10,
          // ),
          Divider(
            color: Colors.grey,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                children: <Widget>[
                  makeLikeButton(isActive: true),
                  new Container(
                    width: 190,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[200]),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewFeedsDetailPage(
                                          value1: userName,
                                          value2: feedTime,
                                          value3: feedText,
                                          value4: feedImage,
                                          // value5: like,
                                          // value6: cmt,
                                        )));
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Comment",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          Divider(
            color: Color.fromRGBO(40, 103, 178, 1),
            height: 5,
            thickness: 3,
            indent: 0,
            endIndent: 0,
          ),
        ],
      ),
      //   );
      // })
    );
  }

  Widget makeLike() {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
          color: Color.fromRGBO(40, 103, 178, 1),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white)),
      child: Center(
        child: Icon(Icons.thumb_up, size: 12, color: Colors.white),
      ),
    );
  }

  Widget makeLikeButton({isActive}) {
    return Container(
      padding: EdgeInsets.all(0),
      width: 190,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]),
        borderRadius: BorderRadius.circular(0),
      ),
      child: Center(
        child: GestureDetector(
          onTap: () {
            clickLike();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.thumb_up,
                color: isActive ? Colors.blue : Colors.red,
                size: 18,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "Like",
                style: TextStyle(color: isActive ? Colors.blue : Colors.red),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Widget makeCommentButton() {
  //   return Container(
  //     // padding: EdgeInsets.symmetric(horizontal: 70, vertical: 10),
  //     width: 190,
  //     height: 50,
  //     decoration: BoxDecoration(
  //       border: Border.all(color: Colors.grey[200]),
  //       borderRadius: BorderRadius.circular(0),
  //     ),

  //     child: Center(
  //       child: GestureDetector(
  //         onTap: () {
  //           setState(() {
  //             Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                     builder: (context) => NewFeedsDetailPage()));
  //           });
  //         },
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             SizedBox(
  //               width: 5,
  //             ),
  //             Text(
  //               "Comment",
  //               style: TextStyle(color: Colors.grey),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget makeShareButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.share, color: Colors.grey, size: 18),
            SizedBox(
              width: 5,
            ),
            Text(
              "Share",
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
