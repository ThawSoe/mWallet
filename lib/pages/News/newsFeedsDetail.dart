import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nsb/Link.dart';
import 'package:nsb/pages/Scan/GenerateQR/QR.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NewFeedsDetailPage extends StatefulWidget {
  final String value1;
  final String value2;
  final String value3;
  final String value4;

  NewFeedsDetailPage({
    Key key,
    this.value1,
    this.value2,
    this.value3,
    this.value4,
  }) : super(key: key);

  @override
  _NewFeedsDetailPageState createState() => _NewFeedsDetailPageState();
}

class _NewFeedsDetailPageState extends State<NewFeedsDetailPage> {
  var newsList = [];
  var newCom = [];
  TextEditingController _controller;

  @override
  void initState() {
    setState(() {
      getComInfo();
    });
    super.initState();
    print("${widget.value1}");
  }

  getComInfo() async {
    final prefs = await SharedPreferences.getInstance();

    String sessionID = prefs.getString('sKey');
    final url = '$link' +
        "/serviceQuestion/getCommentmobile?id=1055136&userSK=$sessionID";
    http.get(Uri.encodeFull(url), headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((dynamic res) {
      var result = json.decode(utf8.decode(res.bodyBytes));
      print("result ===> $result");
      setState(() {
        newCom = result["data"];
        print(newCom);
        print("vv");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // body: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: <Widget>[

      //     Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 crossAxisAlignment: CrossAxisAlignment.baseline,
      //                 textBaseline: TextBaseline.alphabetic,
      //               ),
      //               SizedBox(
      //                 height: 0,
      //               ),
      //               makeFeed(
      //                   userName: "${widget.value1}",

      //                   feedTime: "${widget.value2}",
      //                   feedText:
      //                       "${widget.value3}",
      //                   feedImage: "${widget.value4}",

      //                   // like: newsList[0]["menu_arr"][index]["n2"].toString() ,
      //                   // cmt: newsList[0]["menu_arr"][index]["n3"].toString() + "  comments" ,
      //                   ),

      //   ],
      // ),

      body: new Column(
        children: <Widget>[
          Expanded(
            child: new ListView(
              children: <Widget>[
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  height: 880,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    elevation: 3.0,
                    child: Column(
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
                        makeFeed(
                          userName: "${widget.value1}",

                          feedTime: "${widget.value2}",
                          feedText: "${widget.value3}",
                          feedImage: "${widget.value4}",

                          // like: newsList[0]["menu_arr"][index]["n2"].toString() ,
                          // cmt: newsList[0]["menu_arr"][index]["n3"].toString() + "  comments" ,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Container _buildBottomBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 1.0,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(5.0),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 10.0,
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              size: 30,
            ),
            color: Color.fromRGBO(40, 103, 178, 1),
            onPressed: _save,
          ),
          Expanded(
            child: TextField(
              textInputAction: TextInputAction.send,
              controller: _controller,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 15.0,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: "Write message here ..."),
              onEditingComplete: _save,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            color: Color.fromRGBO(40, 103, 178, 1),
            onPressed: _save,
          )
        ],
      ),
    );
  }

  _save() async {
    if (_controller.text.isEmpty) return;
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      // messages.insert(0, Message(rand.nextInt(2), _controller.text));
      _controller.clear();
    });
  }

  Widget makeFeed({userName, feedTime, feedText, feedImage}) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),

      // child: ListView.builder(
      // separatorBuilder: (context, index) => Row(
      // children: <Widget>[
      //   Text(
      //     "--------------------------",
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   Expanded(
      //     child: new Container(
      //         margin: const EdgeInsets.only(
      //             left: 0.0, right: 10.0),
      //         child: Divider(
      //           color: Colors.grey,
      //         )),
      //   ),
      // ],
      // ),
      // itemCount: newsList.length,
      // itemBuilder: (context, index) {
      //   return SizedBox(
      //     height: 70,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  // SizedBox(
                  //   width: 10,
                  // ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 5),
                      Container(
                      width: 380,
                      child:Text(
                        userName,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[900],
                            height: 1.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: .7),
                        softWrap: true,
                      ),),
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
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[800],
                  height: 1.5,
                  letterSpacing: .7)),
          SizedBox(
            height: 20,
          ),
          feedImage != ''
              ? Container(
                  height: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      image: DecorationImage(
                          image: AssetImage(feedImage),
                          // image: NetworkImage(feedImage),
                          // image: Image.network(feedImage),
                          fit: BoxFit.cover)),
                )
              : Container(),
          SizedBox(
            height: 0,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: <Widget>[
          //     Row(
          //       children: <Widget>[
          //         SizedBox(width: 10),
          //         makeLike(),
          //         Transform.translate(
          //           offset: Offset(-5, 0),
          //           // child: makeLove()
          //         ),
          //         SizedBox(
          //           width: 5,
          //         ),

          //         SizedBox(width: 20),
          //       ],
          //     ),
          //     // Text(
          //     //   cmt,
          //     //   style: TextStyle(fontSize: 13, color: Colors.grey[800]),
          //     // ),
          //   ],
          // ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                children: <Widget>[
                  makeLikeButton(isActive: true),
                  makeCommentButton(),
                ],
              )
            ],
          ),
          Divider(
            color: Colors.grey[500],
            height: 5,
            thickness: 3,
            indent: 0,
            endIndent: 0,
          ),
          SizedBox(
            height: 5,
          ),
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
                "8",
                style: TextStyle(fontSize: 15, color: Colors.grey[800]),
              ),
              SizedBox(width: 20),
            ],
          ),

          // ListView.builder(

          //     itemCount: 1,
          //     itemBuilder: (context, index) {
          //       return SizedBox(
          //         height: 70,
          //         child: ListTile(
          //           leading: ClipRRect(
          //               borderRadius: BorderRadius.circular(20.0),
          //               child: Image.asset(
          //                 // 'assets/flag/' + fromList[index] + '.jpg',
          //                 'assets/flag/',
          //                 width: 80,
          //                 // height: 200,
          //                 fit: BoxFit.cover,
          //               )),
          //           title: Text(
          //               "fromList[index] + ' - ' + toList[index]"
          //               ),
          //           subtitle: Text('Buy Rate - ' +
          //               '\n' +
          //               'Sell Rate - ' ),
          //         ),
          //       );

          //     })
          //  SizedBox(
          //   height: 70,
          //   child: ListTile(
          //     leading: ClipRRect(
          //         borderRadius: BorderRadius.circular(20.0),
          //         child: Image.asset(
          //           // 'assets/flag/' + fromList[index] + '.jpg',
          //           'assets/flag/',
          //           width: 80,
          //           height: 200,
          //           fit: BoxFit.cover,
          //         )),
          //     title: Text(
          //         "fromList[index] + ' - ' + toList[index]"
          //         ),
          //     subtitle: Text('Buy Rate - ' +
          //         '\n' +
          //         'Sell Rate - ' ),
          //   ),
          // ),

          Container(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            height: 280,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              elevation: 3.0,
              child: ListView.separated(
                padding: EdgeInsets.all(5.0),
                separatorBuilder: (context, index) => Divider(
                  color: Colors.black,
                ),
                // key: _formKey,
                itemCount: newCom.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CircleAvatar(
                      // borderRadius: BorderRadius.circular(80.0),
                      radius: 30,

                      // 'assets/flag/' + fromList[index] + '.jpg',
                      child: Text("T".substring(0, 1)),
                    ),
                    title: Text(
                      newCom[index]["userName"],
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(newCom[index]["t2"] +
                        '\n' +
                        DateFormat.yMMMd().format(
                            DateTime.parse(newCom[index]["createdDate"])) +
                        " Like1"),
                  );
                },
              ),
            ),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.thumb_up,
              color: isActive ? Color.fromRGBO(40, 103, 178, 1) : Colors.grey,
              size: 18,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Like",
              style: TextStyle(
                  color:
                      isActive ? Color.fromRGBO(40, 103, 178, 1) : Colors.grey),
            )
          ],
        ),
      ),
    );
  }

  Widget makeCommentButton() {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 70, vertical: 10),
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
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => QRPage()));
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
    );
  }

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
