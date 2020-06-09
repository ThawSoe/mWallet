class checkPhNoRequest{
  String userID;
  String sessionID;
  String loginID;
  
  

  checkPhNoRequest({
    this.userID,
    this.sessionID,
    this.loginID,
    
    
    
  });

  factory checkPhNoRequest.fromJson(Map<String, dynamic> parsedJson){
    return checkPhNoRequest(
        userID: parsedJson['userID'],
        sessionID : parsedJson['sessionID'],
        loginID: parsedJson['loginID']
        
      
        
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["userID"] = this.userID;
    map["sessionID"] = this.sessionID;
    
    
    return map;
  }
  

}