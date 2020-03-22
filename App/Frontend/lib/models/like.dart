class Like
{
  int _postId;
  int _userId;
  DateTime _time;
  int _likeTypeId;
  
  Like(this._postId, this._userId, this._time, this._likeTypeId);

  int get postId => _postId;
  int get userId => _userId;
  DateTime get time => _time;
  int get likeTypeId => _likeTypeId;

 //saljemo kao json fajl
  Map<String, dynamic> toMap()
  {
    var map = Map<String, dynamic>();
    
    map["postId"] = _postId;
    map["userId"] = _userId;
    map["time"] = _time;
    map["likeTypeId"] = _likeTypeId;
   
    return map;
  }

  //pretvaramo iz json-a u object 
  Like.fromObject(dynamic data)
  {
    this._postId = data["postId"];
    this._userId = data["userId"];
    this._time = data["time"];
    this._likeTypeId = data["likeTypeId"];
    

  }
}