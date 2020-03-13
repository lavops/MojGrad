class User{
  int id;
  String username;
  String password;
  String email;

  User({this.username, this.password, this.email});

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      username: json['username'],
      password: json['password'],
      email: json['email']
    );
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map["username"] = username;
    map["password"] = password;
    map["email"] = email;

    if(id != null){
      map["id"] = id;
    }
    return map;
  }

  User.fromObject(dynamic o){
    this.id = o["id"];
    this.username = o["username"];
    this.password = o["password"];
    this.email = o["email"];
  }

}