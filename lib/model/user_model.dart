class UserModel {
  String? email;
  String? nickname;
  String? gender;
  String? dead;
  String? squart;
  String? bench;
  String? photoUrl;
  String? loginProvider;
  UserModel({
    this.email,
    this.bench,
    this.dead,
    this.gender,
    this.nickname,
    this.squart,
    this.photoUrl,
    this.loginProvider,
  });



  UserModel.fromJson(dynamic json) {
    email = json['email'];
    nickname = json["nickname"];
    gender = json["gender"];
    dead = json['deadLift'];
    squart = json['squart'];
    bench =json['bench'];
    photoUrl=json['photoUrl'];
    loginProvider=json['login_provider'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["email"] = email;
    map["deadLift"] = dead;
    map["squart"] = squart;
    map["bench"] = bench;
    map["nickname"] = nickname;
    map["gender"] = gender;
    map['photoUrl'] = photoUrl;
    map['login_provider']=loginProvider;
    return map;
  }
}
