class RegisterUser{
  String t1;
  String t2;
  String t3;
  String t4;
  String t9;
  String t16;
  String t20;
  RegisterUser(
    {
      this.t1,this.t2,this.t3,this.t4,this.t9,this.t16,this.t20

    }
  );
  factory RegisterUser.fromJson(Map<String, dynamic> parsedJson){
    return RegisterUser(
        t1: parsedJson['t1'],
        t2: parsedJson['t2'],
        t3: parsedJson['t3'],
        t4: parsedJson['t4'],
        t9: parsedJson['t9'],
        t16: parsedJson['t16'],
        t20: parsedJson['t20'],
       
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["t1"] = this.t1;
    map["t2"] = this.t2;
    map["t3"] = this.t3;
    map["t4"] = this.t4;
    map["t9"] = this.t9;
    map["t16"] = this.t16;
    map["t20"] = this.t20;
    return map;
  }
}