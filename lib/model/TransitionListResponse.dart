class TransitionListResponse {
  String code;
  String desc;
  String durationType;
  String fromDate;
  String toDate;
  String acctNo;
  String customerNo;
  int totalCount;
  int currentPage;
  int pageSize;
  int pageCount;
  List data;
  
  TransitionListResponse({
    this.code,
    this.desc,
    this.durationType,
    this.fromDate,
    this.toDate,
    this.acctNo,
    this.customerNo,
    this.totalCount,
    this.currentPage,
    this.pageSize,
    this.pageCount,
    List data,
  });
  factory TransitionListResponse.fromJson(Map<String, dynamic> parsedJson) {
    return TransitionListResponse(
        code: parsedJson['code'],
        desc: parsedJson['desc'],
        durationType: parsedJson['durationType'],
        fromDate: parsedJson['fromDate'],
        toDate: parsedJson['toDate'],
        acctNo: parsedJson['acctNo'],
        customerNo: parsedJson['customerNo'],
        totalCount: parsedJson['totalCount'],
        currentPage: parsedJson['currentPage'],
        pageSize: parsedJson['pageSize'],
        pageCount: parsedJson['pageCount'],
        data: parsedJson['data'],
       );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["code"] = this.code;
    map["desc"] = this.desc;
    map["durationType"] = this.durationType;
    map["fromDate"] = this.fromDate;
    map["toDate"] = this.toDate;
    map['acctNo'] = this.acctNo;
    map['customerNo'] = this.customerNo;
    map["totalCount"] = this.totalCount;
    map["currentPage"] = this.currentPage;
    map["pageSize"] = this.pageSize;
    map["pageCount"] = this.pageCount;
    map["data"] = this.data;
    return map;
  }
}
