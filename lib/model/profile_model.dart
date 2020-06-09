class Profile{
  String userID;
  String password;
  String sessionID;
  String phoneno;
  bool otpcode;
  String otp;
  String code;
  String desc;

  Profile({
    this.userID,
    this.password,
    this.sessionID,
    this.phoneno,
    this.otpcode,
    this.otp,
    this.code,
    this.desc,
  });

  factory Profile.fromJson(Map<String, dynamic> parsedJson){
    return Profile(
        userID: parsedJson['userID'],
        password : parsedJson['password'],
        sessionID: parsedJson['sessionID'],
        phoneno: parsedJson['phoneno'],
        otpcode: parsedJson['otpcode'],
        otp: parsedJson['otp'],
        code: parsedJson['code'],
        desc: parsedJson['desc']
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["userID"] = this.userID;
    map["password"] = this.password;
    return map;
  }
}