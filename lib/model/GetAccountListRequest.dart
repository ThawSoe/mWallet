class GetAccountListRequest{
  String userID;
  String sessionID;
  
  

  GetAccountListRequest({
    this.userID,
    this.sessionID,
    
    
    
  });

  factory GetAccountListRequest.fromJson(Map<String, dynamic> parsedJson){
    return GetAccountListRequest(
        userID: parsedJson['userID'],
        sessionID : parsedJson['sessionID'],
        
      
        
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["userID"] = this.userID;
    map["sessionID"] = this.sessionID;
    
    
    return map;
  }
  

}