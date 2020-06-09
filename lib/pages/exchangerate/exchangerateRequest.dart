class ExchangeRateRequest{
String userID;
String sessionID;
ExchangeRateRequest({
    this.userID,
    this.sessionID,
  });

 factory ExchangeRateRequest.fromJson(Map<String, dynamic> parsedJson){
    return ExchangeRateRequest(
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
