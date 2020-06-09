class GetBalanceRequest{
  String userID;
  String sessionID;
  GetBalanceRequest({
    this.sessionID,this.userID
  });
   factory GetBalanceRequest.fromJson(Map<String, dynamic> parsedJson){
    return GetBalanceRequest(
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