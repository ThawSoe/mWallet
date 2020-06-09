class ContactAddRequest{
  String userID;
  String sessionID;
  String phone;
  String name;
  String type;
  String t3;

  ContactAddRequest({
    this.userID,
    this.sessionID,
    this.phone,
    this.name,
    this.type,
    this.t3,
    
  });

  factory ContactAddRequest.fromJson(Map<String, dynamic> parsedJson){
    return ContactAddRequest(
        userID: parsedJson['userID'],
        sessionID : parsedJson['sessionID'],
        phone: parsedJson['phone'],
        name: parsedJson['name'],
        type: parsedJson['type'],
        t3: parsedJson['t3'],
        
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["userID"] = this.userID;
    map["sessionID"] = this.sessionID;
    map["phone"] = this.phone;
    map["name"] = this.name;
    map["type"] = this.type;
    map["t3"] = this.t3;
    return map;
  }
  //  Map toMapLogin() {
  //   var map = new Map<String, dynamic>();
  //   map["userID"] = this.userID;
  //   map["deviceID"] = this.deviceID;
  //   map["otpCode"]=this.otpCode;
  //   map["rKey"]=this.rKey;
  //   map["sessionID"]=this.sessionID;
  //   map["fcmToken"]=this.fcmToken;
  //   return map;
  // }

}