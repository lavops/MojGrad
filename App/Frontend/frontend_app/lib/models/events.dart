class Events{

  int _eventId;
  int _sponsorId;
  String _sponsorName;
  int _eventType; //da li je okupljanje ili skupljanje sredstava
  DateTime _createDate;
  DateTime _endDate;
  String _description;
  double _latitude; //ako je okupljanje gde ce da se dogodi
  double _longitude; //ako je okupljanje gde ce da se dogodi
  String _address; //ako je okupljanje gde ce da se dogodi
  int _pointsNeeded; //ako je skupljanje sredstava za nesto pa koliki je cilj
  int _pointsCollected; //ako je skupljanje sredstava za nesto pa koliko je skupljeno do sad
  int _status; //da li je gotovo ili ne



  Events();
  Events.withId(this._eventId, this._eventType);

  int get eventId => _eventId;
  set eventId(int eventId){_eventId = eventId;}
  int get sponsorId => _sponsorId;
  set sponsorId(int sponsorId){_sponsorId = sponsorId;}
  String get sponsorName => _sponsorName;
  set sponsorName(String sponsorName){_sponsorName = sponsorName;}
  int get eventType => _eventType;
  set eventType(int eventType){_eventType = eventType;}
  DateTime get createDate => _createDate;
  set createDate(DateTime createDate){_createDate = createDate;}
  DateTime get endDate => _endDate;
  set endDate(DateTime endDate){_endDate = endDate;}
  String get description => _description;
  set description(String description){_description = description;}
  double get latitude => _latitude;
  set latitude(double latitude){_latitude = latitude;}
  double get longitude => _longitude;
  set longitude(double longitude){_longitude = longitude;}
  String get address => _address;
  set address(String address){_address = address;}
  int get pointsNeeded => _pointsNeeded;
  set pointsNeeded(int pointsNeeded){_pointsNeeded = pointsNeeded;}
  int get pointsCollected => _pointsCollected;
  set pointsCollected(int pointsCollected){_pointsCollected = pointsCollected;}
  int get status => _status;
  set status(int status){_status = status;}

  Map<String, dynamic> toMap()
  {
    var map = Map<String, dynamic>();
    
    map["postId"] = _eventId;
    map["sponsorId"] = _sponsorId;
    map["sponsorName"] = _sponsorName;
    map["eventType"] = _eventType;
    map["createDate"] = _createDate;
    map["endDate"] = _endDate;
    map["description"] = _description;
    map["status"] = _status;
    map["latitude"] = _latitude;
    map["longitude"] = _longitude;
    map["address"] = _address;
    map["pointsNeeded"] = _pointsNeeded;
    map["pointsCollected"] = _pointsCollected;

    return map;
  }

  //pretvaramo iz json-a u object 
  Events.fromObject(dynamic data)
  {
    this._eventId = data["eventId"];
    //this._sponsorId = data["sponsorId"];
    //this._sponsorName = data["sponsorName"];
    this._eventType = data["eventType"];
    //this._createDate = data["createDate"];
    //this._endDate = data["endDate"];
    //this._description = data["description"];
    //this._status = data["status"];
    //this._latitude = data["latitude"];
    //this._longitude = data["longitude"];
    //this._address = data["address"];
    //this._pointsCollected = data["pointsCollected"];
    //this._pointsNeeded = data["pointsNeeded"];
  }
}