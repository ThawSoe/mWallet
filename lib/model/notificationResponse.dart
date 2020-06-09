class NotiRemove{
  String code;
  String desc;
  int count;
  NotiRemove({
    this.code,
    this.desc,
    this.count,
  });
  factory NotiRemove.fromJson(Map<String, dynamic> parsedJson){
    return NotiRemove(
        code: parsedJson['code'],
        desc: parsedJson['desc'],
        count: parsedJson['count'],
    );
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["code"] = this.code;
    map["desc"] = this.desc;
    map["count"] = this.count;
  return map;
  }
}

class NotificationResponse{
  String sessionID;
  String userID;
  String msgCode;
  String msgDesc;
  String searchText;
  int totalCount;
  int currentPage;
  int pageSize;
  // String data;
  // dynamic data;
List<dynamic> data;
NotificationResponse({
    this.sessionID,
    this.userID,
    this.msgCode,
    this.msgDesc,
    this.searchText,
    this.totalCount,
    this.currentPage,
    this.pageSize,
    this.data,
  });

 factory NotificationResponse.fromJson(Map<String, dynamic> parsedJson){
    return NotificationResponse(
        sessionID: parsedJson['sessionID'],
        userID: parsedJson['userID'],
        msgCode: parsedJson['msgCode'],
        msgDesc: parsedJson['msgDesc'],
        searchText: parsedJson['searchText'],
        totalCount: parsedJson['totalCount'],
        currentPage: parsedJson['currentPage'],
        pageSize: parsedJson['pageSize'],
        // data: parsedJson['data'],
        data: parseData(parsedJson),

    );
  }

  static List<Data> parseData(dataJson){
    var list = dataJson['data'] as List;
    List<Data> dataList = list.map((data) => Data.fromJson(data)).toList();
    return dataList;
  }

 
Map toMap() {
    var map = new Map<String, dynamic>();
    map["sessionID"] = this.sessionID;
    map["userID"] = this.userID;
    map["msgCode"] = this.msgCode;
    map["msgDesc"] = this.msgDesc;
    map["searchText"] = this.searchText;
    map["totalCount"] = this.totalCount;
    map["currentPage"] = this.currentPage;
    map["pageSize"] = this.pageSize;
    map["data"] = this.data;
    return map;
  }
}

class Data{
   String description;
  //  String sessionid;
  //  String code;
  //  String desc;
  //  String autokey;
  //  String createddatetime;
  //  String modifieddatetime;
  //  String title;
  //  String toDescription;
  //  String type;
  //  String typedescription;
  //  String date;
  //  String time;
  //  String userid;
  //  String receiverID;
  //  String username;
  //  String lastuserid;
  //  String lastusername;
  //  String sendtofcmfirebase;
  //  String responsecode;
  //  String responsebody;
  //  String t1;
  //  String t2;
  //  String t3;
  //  String n1;
  //  String n2;
  //  String n3;
  //  String modifiedhistory;
  //  dynamic notiType;
  //  String serviceType;
  //  String functionType;
  //  String merchantID;
  //  dynamic amount;
  //  String refNo;
  //  String name;
  //  String transactionType;
  //  String merchantName;
  //  String receiverName;
   
  Data({
    this.description,
    // this.sessionid,
    // this.code,
    // this.desc,
    // this.autokey,
    // this.createddatetime,
    // this.modifieddatetime,
    // this.title,
    // this.toDescription,
    // this.type,
    // this.typedescription,
    // this.date,
    // this.time,
    // this.userid,
    // this.receiverID,
    // this.username,
    // this.lastuserid,
    // this.lastusername,
    // this.sendtofcmfirebase,
    // this.responsecode,
    // this.responsebody,
    // this.t1,
    // this.t2,
    // this.t3,
    // this.n1,
    // this.n2,
    // this.n3,
    // this.modifiedhistory,
    // this.notiType,
    // this.serviceType,
    // this.functionType,
    // this.merchantID,
    // this.amount,
    // this.refNo,
    // this.name,
    // this.transactionType,
    // this.merchantName,
    // this.receiverName,
    
  });
  factory Data.fromJson(Map<String, dynamic> parsedJson){
    return Data(
        description: parsedJson['description'],
        // sessionid: parsedJson['sessionid'],
        // code: parsedJson['code'],
        // desc: parsedJson['desc'],
        // autokey: parsedJson['autokey'],
        // createddatetime: parsedJson['createddatetime'],
        // modifieddatetime: parsedJson['modifieddatetime'],
        // title: parsedJson['title'],
        // toDescription: parsedJson['toDescription'],
        // type: parsedJson['type'],
        // typedescription: parsedJson['typedescription'],
        // date: parsedJson['date'],
        // time: parsedJson['time'],
        // userid: parsedJson['userid'],
        // receiverID: parsedJson['receiverID'],
        // username: parsedJson['username'],
        // lastuserid: parsedJson['lastuserid'],
        // lastusername: parsedJson['lastusername'],
        // sendtofcmfirebase: parsedJson['sendtofcmfirebase'],
        // responsecode: parsedJson['responsecode'],
        // responsebody: parsedJson['responsebody'],
        // t1: parsedJson['t1'],
        // t2: parsedJson['t2'],
        // t3: parsedJson['t3'],
        // n1: parsedJson['n1'],
        // n2: parsedJson['n2'],
        // n3: parsedJson['n3'],
        // modifiedhistory: parsedJson['modifiedhistory'],
        // notiType: parsedJson['notiType'],
        // serviceType: parsedJson['serviceType'],
        // functionType: parsedJson['functionType'],
        // merchantID: parsedJson['merchantID'],
        // amount: parsedJson['amount'],
        // refNo: parsedJson['refNo'],
        // name: parsedJson['name'],
        // transactionType: parsedJson['transactionType'],
        // merchantName: parsedJson['merchantName'],
        // receiverName: parsedJson['receiverName'],
       
    );
  }
Map toMap() {
    var map = new Map<String, dynamic>();
    map["description"] = this.description;
    // map["sessionid"] = this.sessionid;
    // map["code"] = this.code;
    // map["desc"] = this.desc;
    // map["autokey"] = this.autokey;
    // map["createddatetime"] = this.createddatetime;
    // map["modifieddatetime"] = this.modifieddatetime;
    // map["title"] = this.title;
    // map["toDescription"] = this.toDescription;
    // map["type"] = this.type;
    // map["typedescription"] = this.typedescription;
    // map["date"] = this.date;
    // map["time"] = this.time;
    // map["userid"] = this.userid;
    // map["receiverID"] = this.receiverID;
    // map["username"] = this.username;
    // map["lastuserid"] = this.lastuserid;
    // map["lastusername"] = this.lastusername;
    // map["sendtofcmfirebase"] = this.sendtofcmfirebase;
    // map["responsecode"] = this.responsecode;
    // map["responsebody"] = this.responsebody;
    // map["t1"] = this.t1;
    // map["t2"] = this.t2;
    // map["t3"] = this.t3;
    // map["n1"] = this.n1;
    // map["n2"] = this.n2;
    // map["n3"] = this.n3;
    // map["modifiedhistory"] = this.modifiedhistory;
    // map["notiType"] = this.notiType;
    // map["serviceType"] = this.serviceType;
    // map["functionType"] = this.functionType;
    // map["merchantID"] = this.merchantID;
    // map["amount"] = this.amount;
    // map["refNo"] = this.refNo;
    // map["name"] = this.name;
    // map["transactionType"] = this.transactionType;
    // map["merchantName"] = this.merchantName;
    // map["receiverName"] = this.receiverName;
    
    return map;
  }
}



  