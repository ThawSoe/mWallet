class NotificationRequest{
String userID;
String sessionID;
String customerNo;
String totalCount;
String currentPage;
String pageSize;
String pageCount;
NotificationRequest({
    this.userID,
    this.sessionID,
    this.customerNo,
    this.totalCount,
    this.currentPage,
    this.pageSize,
    this.pageCount,
  });

 factory NotificationRequest.fromJson(Map<String, dynamic> parsedJson){
    return NotificationRequest(
        userID: parsedJson['userID'],
        sessionID: parsedJson['sessionID'],
        customerNo: parsedJson['customerNo'],
        totalCount: parsedJson['totalCount'],
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
    map["totalCount"] = this.totalCount;
    map["currentPage"] = this.currentPage;
    map["pageSize"] = this.pageSize;
    map["pageCount"] = this.pageCount;
    return map;
  }
}
