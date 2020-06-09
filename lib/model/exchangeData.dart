class ExchangeData{
  String userID;
  String sessionID;
  ExchangeData({
    this.sessionID,this.userID
  });
   factory ExchangeData.fromJson(Map<String, dynamic> parsedJson){
    return ExchangeData(
        userID: parsedJson['userID'],
        sessionID: parsedJson['sessionID'],
    );
  }
   Map toMap() {
    var map = new Map<String, dynamic>();
    map["userID"] = this.userID;
    map["sessionID"] = this.sessionID;
    return map;
  }
}