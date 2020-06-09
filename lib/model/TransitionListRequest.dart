class TransitionListRequest {
  String userID;
  String sessionID;
  String customerNo;
  int durationType;
  String fromDate;
  String toDate;
  int totalCount;
  String acctNo;
  int currentPage;
  int pageSize;
  int pageCount;
  
  TransitionListRequest({
    this.userID,
    this.sessionID,
    this.customerNo,
    this.durationType,
    this.fromDate,
    this.toDate,
    this.totalCount,
    this.acctNo,
    this.currentPage,
    this.pageSize,
    this.pageCount,
  });
  factory TransitionListRequest.fromJson(Map<String, dynamic> parsedJson) {
    return TransitionListRequest(
        userID: parsedJson['userID'],
        sessionID: parsedJson['sessionID'],
        customerNo: parsedJson['customerNo'],
        durationType: parsedJson['durationType'],
        fromDate: parsedJson['fromDate'],
        toDate: parsedJson['toDate'],
        totalCount: parsedJson['totalCount'],
        acctNo: parsedJson['acctNo'],
        currentPage: parsedJson['currentPage'],
        pageSize: parsedJson['pageSize'],
        pageCount: parsedJson['pageCount'],
       );
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["userID"] = this.userID;
    map["sessionID"] = this.sessionID;
    map["customerNo"] = this.customerNo;
    map["durationType"] = this.durationType;
    map["fromDate"] = this.fromDate;
    map["toDate"] = this.toDate;
    map["totalCount"] = this.totalCount;
    map["acctNo"] = this.acctNo;
    map["currentPage"] = this.currentPage;
    map["pageSize"] = this.pageSize;
    map["pageCount"] = this.pageCount;
    return map;
  }
}
