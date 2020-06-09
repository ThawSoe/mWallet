class RegisterUserResponse {
  int syskey;
  int autokey;
  String createddate;
  String modifieddate;
  String userid;
  String username;
  int recordStatus;
  int syncStatus;
  int syncBatch;
  int usersyskey;
  String sessionKey;
  int sessionStatus;
  String chatData;
  String person;
  int select;
  String errMsg;
  String t1;
  String t10;
  String t2;
  String t3;
  String t5;
  String t6;
  String t4;
  String t7;
  String t11;
  String t20;
  String t15;
  String t12;
  String t16;
  String t13;
  String t18;
  String t8;
  String t19;
  String t9;
  String t14;
  String t17;
  String t66;
  RegisterUserResponse({
    this.syskey,
    this.autokey,
    this.createddate,
    this.modifieddate,
    this.userid,
    this.username,
    this.recordStatus,
    this.syncStatus,
    this.syncBatch,
    this.usersyskey,
    this.sessionKey,
    this.sessionStatus,
    this.chatData,
    this.person,
    this.select,
    //this.upload=[], //array phyit yan
    this.errMsg,
    this.t1,
    this.t10,
    this.t2,
    this.t3,
    this.t5,
    this.t6,
    this.t4,
    this.t7,
    this.t11,
    this.t20,
    this.t15,
    this.t12,
    this.t16,
    this.t13,
    this.t18,
    this.t8,
    this.t19,
    this.t9,
    this.t14,
    this.t17,
    this.t66,
  });
  factory RegisterUserResponse.fromJson(Map<String, dynamic> parsedJson) {
    return RegisterUserResponse(
      syskey: parsedJson['syskey'],
      autokey: parsedJson['autokey'],
      createddate: parsedJson['createddate'],
      modifieddate: parsedJson['modifieddate'],
      userid: parsedJson['userid'],
      username: parsedJson['username'],
      recordStatus: parsedJson['recordStatus'],
      syncStatus: parsedJson['syncStatus'],
      syncBatch: parsedJson['syncBatch'],
      usersyskey: parsedJson['usersyskey'],
      sessionKey: parsedJson['sessionKey'],
      chatData: parsedJson['chatData'],
      sessionStatus: parsedJson['sessionStatus'],
      person: parsedJson['person'],
      select: parsedJson['select'],
     // upload: parsedJson['upload'],
      errMsg: parsedJson['errMsg'],
      t1: parsedJson['t1'],
      t10: parsedJson['t10'],
      t2: parsedJson['t2'],
      t3: parsedJson['t3'],
      t5: parsedJson['t5'],
      t6: parsedJson['t6'],
      t4: parsedJson['t4'],
      t7: parsedJson['t7'],
      t11: parsedJson['t11'],
      t20: parsedJson['t20'],
      t15: parsedJson['t15'],
      t12: parsedJson['t12'],
      t16: parsedJson['t16'],
      t13: parsedJson['t13'],
      t18: parsedJson['t18'],
      t19: parsedJson['t19'],
      t14: parsedJson['t14'],
      t17: parsedJson['t17'],
      t66: parsedJson['t66'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['syskey'] = this.syskey;
    map['autokey'] = this.autokey;
    map['createddate'] = this.createddate;
    map['modifieddate'] = this.modifieddate;
    map['userid'] = this.userid;
    map['username'] = this.username;
    map['recordStatus'] = this.recordStatus;
    map['syncStatus'] = this.syncStatus;
    map['syncBatch'] = this.syncBatch;
    map['usersyskey'] = this.usersyskey;
    map['sessionKey'] = this.sessionKey;
    map['chatData'] = this.chatData;
    map['sessionStatus'] = this.sessionStatus;
    map['person'] = this.person;
    map['select'] = this.select;
    //map['upload'] = this.upload;
    map['errMsg'] = this.errMsg;
    map['t1'] = this.t1;
    map['t10'] = this.t10;
    map['t2'] = this.t2;
    map['t3'] = this.t3;
    map['t5'] = this.t5;
    map['t6'] = this.t6;
    map['t4'] = this.t4;
    map['t7'] = this.t7;
    map['t11'] = this.t11;
    map['t20'] = this.t20;
    map['t15'] = this.t15;
    map['t12'] = this.t12;
    map['t16'] = this.t16;
    map['t13'] = this.t13;
    map['t18'] = this.t18;
    map['t19'] = this.t19;
    map['t14'] = this.t14;
    map['t17'] = this.t17;
    map['t66'] = this.t66;
    return map;
  }
}
