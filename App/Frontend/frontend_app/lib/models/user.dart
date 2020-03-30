class User{
  int _id;
  int _userTypeId;
  String _firstName;  
  String _lastName;
  String _createdAt;
  String _username;
  String _password;
  String _email;
  String _phone;  
  int _cityId;
  String _cityName;
  String _token;
  String _typeName;

  User();
  User.without(this._userTypeId, this._firstName, this._lastName, this._username, this._password, this._email, this._phone, this._cityId);
  

  int get id => _id;
  int get userTypeId => _userTypeId;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get createdAt => _createdAt;
  String get username => _username;
  String get password => _password;
  String get email => _email;
  String get phone => _phone;
  int get cityId => _cityId;
  String get cityName => _cityName;
  String get token => _token;
  String get typeName => _typeName;

  //Convert a User into a Map object
  Map<String, dynamic> toMap(){
    var data = Map<String, dynamic>();

    data["userTypeId"] = _userTypeId;
    data["firstName"] = _firstName;
    data["lastName"] = _lastName;
    data["createdAt"] = _createdAt;
    data["username"] = _username;
    data["password"] = _password;
    data["email"] = _email;
    data["phone"] = _phone;
    data["cityId"] = _cityId;
    data["cityName"]=_cityName;
    data["token"] = _token;
    data["typeName"] = _typeName;
 
    if(_id != null){
      data["id"] = _id;
    }

    return data;
  }

  //Extract a User object from a Map object
  User.fromObject(dynamic data){
    this._id = data["id"];
    this._firstName = data["firstName"];
    this._lastName = data["lastName"];
    this._createdAt = data["createdAt"];
    this._username = data["username"];
    this._password = data["password"];
    this._email = data["email"];
    this._phone = data["phone"];
    this._cityId = data["cityId"];
    this._token = data["token"];
    this._userTypeId = data["userTypeId"];
    this._typeName = data["typeName"];
    this._typeName = data["typeName"];
  }

}