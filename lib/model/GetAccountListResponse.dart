class GetAccountListResponse{
  String code;
  String desc;
  List accountList;

  GetAccountListResponse({
    this.code,
    this.desc,
    this.accountList,
  });

  factory GetAccountListResponse.fromJson(Map<String, dynamic> parsedJson){
    return GetAccountListResponse(
        code: parsedJson['code'],
        desc : parsedJson['desc'],
        accountList: parsedJson['accountList'],
        
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["code"] = this.code;
    map["desc"] = this.desc;
    map["accountList"] = this.accountList;
    return map;
  }
 
}