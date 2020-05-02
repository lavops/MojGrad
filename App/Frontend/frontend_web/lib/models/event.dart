class Events{

  int _id;
  int _institutionId;
  int _adminId;
  String _organizeName;
  int _cityId;
  String _cityName;
  String _startDate;
  String _endDate;
  String _shortDescription;
  double _latitude;
  double _longitude;
  String _address;
  String _title;
  String _description;
  int _userNum;
  int _isGoing;


  Events();
  Events.withId(this._id);

  Map<String, dynamic> toMap()
  {
    var map = Map<String, dynamic>();
    
    map["id"] = _id;
    map["institutionId"] = _institutionId;
    map["adminId"] = _adminId;
    map["organizeName"] = _organizeName;
    map["cityId"] = _cityId;
    map["cityName"] = _cityName;
    map["startDate"] = _startDate;
    map["endDate"] = _endDate;
    map["shortDescription"] = _shortDescription;
    map["latitude"] = _latitude;
    map["longitude"] = _longitude;
    map["address"] = _address;
    map["title"] = _title;
    map["description"] = _description;
    map["userNum"] = _userNum;
    map["isGoing"] = _isGoing;
    return map;
  }

  //pretvaramo iz json-a u object 
  Events.fromObject(dynamic data)
  {
    this._id = data["id"];
    this._institutionId = data["institutionId"];
    this._adminId = data["adminId"];
    this._organizeName = data["organizeName"];
    this._cityId = data["cityId"];
    this._cityName = data["cityName"];
    this._startDate = data["startDate"];
    this._endDate = data["endDate"];
    this._shortDescription = data["shortDescription"];
    this._latitude = data["latitude"];
    this._longitude = data["longitude"];
    this._address = data["address"];
    this._title = data["title"];
    this._description = data["description"];
    this._userNum = data["userNum"];
    this._isGoing = data["isGoing"];
  }
}