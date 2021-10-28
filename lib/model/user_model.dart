class User {
  String? name;
  String? radioValue;
  String? picture;

  User(this.name, this.radioValue, this.picture);

  // DB GA YOZISH UCHUN
  Map<String, dynamic> toMapToDb() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['name'] = name;
    map['radioValue'] = radioValue;
    map['picture'] = picture;
    return map;
  }

  // DB DAN O'QISH UCHUN
  User.fromMapFromDb(Map<String, dynamic> map) {
    name = map['name'];
    radioValue = map['radioValue'];
    picture = map['picture'];
  }
}
