class ReadMessageRequest{
String type;
String userID;
String sessionID;
String merchantID;
String rKey;
String serviceType;
ReadMessageRequest({
    this.type,
    this.userID,
    this.sessionID,
    this.merchantID,
    this.rKey,
    this.serviceType,
  });

 factory ReadMessageRequest.fromJson(Map<String, dynamic> parsedJson){
    return ReadMessageRequest(
        type : parsedJson['type'],
        userID: parsedJson['userID'],
        sessionID: parsedJson['sessionID'],
        merchantID: parsedJson['merchantID'],
        rKey: parsedJson['rKey'],
        serviceType: parsedJson['serviceType'],
    );
  }
Map toMap() {
    var map = new Map<String, dynamic>();
    map["type"] = this.type;
    map["userID"] = this.userID;
    map["sessionID"] = this.sessionID;
    map["merchantID"] = this.merchantID;
    map["rKey"] = this.rKey;
    map["serviceType"] = this.serviceType;
    return map;
  }
}
