// class updateProfileResponse{
//   String syskey;
//   String t1;
//   String t2;
//   String t3;
//   String t9;
  

//   updateProfileResponse({
//     this.syskey,
//     this.t1,
//     this.t2,
//     this.t3,
//     this.t9,

//   });

//   factory updateProfileResponse.fromJson(Map<String, dynamic> parsedJson){
//     return updateProfileResponse(
//         syskey: parsedJson['syskey'],
//         t1 : parsedJson['t1'],
//         t2: parsedJson['t2'],
//         t3 : parsedJson['t3'],
//         t9 : parsedJson['t9'],
 
        
//     );
//   }

//   Map toMap() {
//     var map = new Map<String, dynamic>();
//     map["syskey"] = this.syskey;
//     map["t1"] = this.t1;
//     map["t2"] = this.t2;
//     map["t3"] = this.t3;
//     map["t9"] = this.t9;

    
//     return map;
//   }
 
// }

class updateProfileResponse{
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
  String errMsg;
  String t1;
  String t2;
  String t3;
  String t4;
  String t5;
  String t6;
  String t7;
  String t8;
  String t9;
  String t10;
  String t11;
  String t12;
  String t13;
  String t14;
  String t15;
  String t16;
  String t17;
  String t18;
  String t19;
  String t20;
  String t66;
  String errCode;

  updateProfileResponse({
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
    this.errMsg,
    this.t1,
    this.t2,
    this.t3,
    this.t4,
    this.t5,
    this.t6,
    this.t7,
    this.t8,
    this.t9,
    this.t10,
    this.t11,
    this.t12,
    this.t13,
    this.t14,
    this.t15,
    this.t16,
    this.t17,
    this.t18,
    this.t19,
    this.t20,
    this.t66,
    this.errCode
});

  updateProfileResponse.fromJson(Map<String, dynamic> json) {
    syskey = json['syskey'];
    autokey = json['autokey'];
    createddate = json['createddate'];
    modifieddate = json['modifieddate'];
    userid = json['userid'];
    username = json['username'];
    recordStatus = json['recordStatus'];
    syncStatus = json['syncStatus'];
    syncBatch = json['syncBatch'];
    usersyskey = json['usersyskey'];
    sessionKey = json['sessionKey'];
    sessionStatus = json['sessionStatus'];
    errMsg = json['errMsg'];
    t1 = json['t1'];
    t2 = json['t2'];
    t3 = json['t3'];
    t4 = json['t4'];
    t5 = json['t5'];
    t6 = json['t6'];
    t7 = json['t7'];
    t8 = json['t8'];
    t9 = json['t9'];
    t10 = json['t10'];
    t11 = json['t11'];
    t12 = json['t12'];
    t13 = json['t13'];
    t14 = json['t14'];
    t15 = json['t15'];
    t16 = json['t16'];
    t17 = json['t17'];
    t18 = json['t18'];
    t19 = json['t19'];
    t20 = json['t20'];
    t66 = json['t66'];
    errCode = json['errCode'];

  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['syskey'] = this.syskey;
    data['autokey'] = this.autokey;
    data['createddate'] = this.createddate;
    data['modifieddate'] = this.modifieddate;
    data['userid'] = this.userid;
    data['username'] = this.username;
    data['recordStatus'] = this.recordStatus;
    data['syncStatus'] = this.syncStatus;
    data['syncBatch'] = this.syncBatch;
    data['usersyskey'] = this.usersyskey;
    data['sessionKey'] = this.sessionKey;
    data['sessionStatus'] = this.sessionStatus;
    data['errMsg'] = this.errMsg;
    data['t1'] = this.t1;
    data['t2'] = this.t2;
    data['t3'] = this.t3;
    data['t4'] = this.t4;
    data['t5'] = this.t5;
    data['t6'] = this.t6;
    data['t7'] = this.t7;
    data['t8'] = this.t8;
    data['t9'] = this.t9;
    data['t10'] = this.t10;
    data['t11'] = this.t11;
    data['t12'] = this.t12;
    data['t13'] = this.t13;
    data['t14'] = this.t14;
    data['t15'] = this.t15;
    data['t16'] = this.t16;
    data['t17'] = this.t17;
    data['t18'] = this.t18;
    data['t19'] = this.t19;
    data['t20'] = this.t20;
    data['t66'] = this.t66;
    data['errCode'] = this.errCode;

    return data;
  }

}