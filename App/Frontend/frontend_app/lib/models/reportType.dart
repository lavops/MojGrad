class ReportType
{
  int _id;
  String _typeName;

  ReportType(this._id, this._typeName);

  int get id => _id;
  String get typeName => _typeName;

  Map<String, dynamic> toMap()
  {
    var map = Map<String, dynamic>();
    
    map["id"] = _id;
    map["typeName"] = _typeName;
    
    return map;
  }

  //pretvaramo iz json-a u object 
  ReportType.fromObject(dynamic data)
  {
    this._id = data["id"];
    this._typeName = data["typeName"];
  }
}