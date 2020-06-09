// class updateProfileRequest{
//   String syskey;
//   String t1;
//   String t2;
//   String t3;
//   String t4;
//   String t9;
//   String t16;
  
  

//   updateProfileRequest({
//     this.syskey,
//     this.t1,
//     this.t2,
//     this.t3,
//     this.t4,
//     this.t9,
//     this.t16,
    
//   });

//   factory updateProfileRequest.fromJson(Map<String, dynamic> parsedJson){
//     return updateProfileRequest(
//         syskey: parsedJson['syskey'],
//         t1 : parsedJson['t1'],
//         t2: parsedJson['t2'],
//         t3 : parsedJson['t3'],
//         t4: parsedJson['t4'],
//         t9 : parsedJson['t9'],
//         t16: parsedJson['t16'],
        
      
        
//     );
//   }

//   Map toMap() {
//     var map = new Map<String, dynamic>();
//     map["syskey"] = this.syskey;
//     map["t1"] = this.t1;
//     map["t2"] = this.t2;
//     map["t3"] = this.t3;
//     map["t4"] = this.t4;
//     map["t9"] = this.t9;
//     map["t16"] = this.t16;
    
    
//     return map;
//   }
  

// }

class updateProfileRequest {
  String syskey;
  String t1;
  String t2;
  String t3;
  String t4;
  String t9;
  String t16;
  // String t18;

  updateProfileRequest(
      {
        this.syskey,
         this.t1,
          this.t2,
           this.t3,
            this.t4,
             this.t9,
              this.t16,
              //  this.t18,
               });

  updateProfileRequest.fromJson(Map<String, dynamic> json) {
    syskey = json['syskey'];
    t1 = json['t1'];
    t2 = json['t2'];
    t3 = json['t3'];
    t4 = json['t4'];
    t9 = json['t9'];
    t16 = json['t16'];
    // t18 = json['t18'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['syskey'] = this.syskey;
    data['t1'] = this.t1;
    data['t2'] = this.t2;
    data['t3'] = this.t3;
    data['t9'] = this.t9;
    data['t16'] = this.t16;
    // data['t18'] = this.t18;
    return data;
  }
}
