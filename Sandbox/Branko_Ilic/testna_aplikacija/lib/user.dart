class User{
  int idUser;
  String email;
  String password;
  String username;
  String firstName;
  String lastName;
  String token;

  User();

  int get _idUser => idUser;
  String get _email => email;
  String get _password => password;
  String get _username => username;
  String get _firstName => firstName;
  String get _lastName => lastName;
  String get _token => token;

  set _username(String nUsername){
    username = nUsername;
  }

  set _firstName(String nFirstName){
    firstName = nFirstName;
  }

  set _lastName(String nLastName){
    lastName = nLastName;
  }

  set _email(String newMail){
    email = newMail;
  }

  set _password(String nPassword){
    password = nPassword;
  }

  set _token(String nToken){
    token = nToken;
  }

  Map<String, dynamic> toMap(){
    var map = Map<String,dynamic>();
    map['idUser'] = idUser;
    map['email'] = email;
    map['password'] = password;
    map['username'] = username;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['token'] = token;

    return map;
  }

  User.fromObject(dynamic o){
    this.idUser = o['idUser'];
    this.email = o['email'];
    this.password = o['password'];
    this.username = o['username'];
    this.firstName = o['firstName'];
    this.lastName = o['lastName'];
    this.token = o['token'];
  }
}
