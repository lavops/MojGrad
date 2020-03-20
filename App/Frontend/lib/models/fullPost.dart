class FullPost
{
   
  int _postId;
  int _userId; 
  String _username;
  int _postTypeId;
  String _typeName;
  DateTime _createAt; //time the post was posted
  String _description;
  String _photoPath; 
  int _statusId;
  String _status; // 'reseno' or 'nereseno'
  int _likeNum; //number of likes
  int _dislikeNum; //number of dislikes
  int _commNum;
  
  FullPost(this._postId, this._userId, this._username,this._postTypeId,this._typeName,this._createAt,this._description,this._photoPath,this._statusId,this._status,this._likeNum,this._dislikeNum, this._commNum );
 

  int get postId => _postId;
  int get userId => _userId;
  String get username => _username;
  int get postTypeId => _postTypeId;
  String get typeName => _typeName;
  DateTime get createAt => _createAt;
  String get description => _description;
  String get photoPath => _photoPath;
  int get statusId => _statusId;
  String get status => _status;
  int get likeNum => _likeNum;
  int get dislikeNum => _dislikeNum;
  int get commNum => _commNum;
  

 //saljemo kao json fajl
  Map<String, dynamic> toMap()
  {
    var map = Map<String, dynamic>();
    
    map["postId"] = _postId;
    map["userId"] = _userId;
    map["username"] = _username;
    map["postTypeId"] = _postTypeId;
    map["typeName"] = _typeName;
    map["createAt"] = _createAt;
    map["description"] = _description;
    map["photoPath"] = _photoPath;
    map["statusId"] = _statusId;
    map["status"] = _status;
    map["likeNum"] = _likeNum;
    map["dislikeNum"] = _dislikeNum;
    map["commNum"] = _commNum;
    
   
    return map;
  }

  //pretvaramo iz json-a u object 
  FullPost.fromObject(dynamic data)
  {
    this._postId = data["postId"];
    this._userId = data["userId"];
    this._username = data["username"];
    this._postTypeId = data["postTypeId"];
    this._typeName = data["typeName"];
    this._createAt = data["createAt"];
    this._description = data["description"] ;
    this._photoPath = data["photoPath"];
    this._statusId = data["statusId"];
    this._status = data["status"];
    this._likeNum = data["likeNum"];
    this._dislikeNum = data["dislikeNum"];
    this._commNum = data["commNum"];
    

  }
}