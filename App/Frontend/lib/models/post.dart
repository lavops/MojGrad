class Post{
  int _id;
  String _userId;
  int _postTypeId;
  DateTime  _createdAt;
  String _description;
  String _photoPath;
  int _statusId;


  Post(this._id, this._userId, this._postTypeId, this._createdAt, this._description, this._photoPath, this._statusId);
  Post.WithoutId(this._userId, this._postTypeId, this._createdAt, this._description, this._photoPath, this._statusId);

  int get id => _id;
  String get userId => _userId;
  int get postTypeId => _postTypeId;
  DateTime get createdAt => _createdAt;
  String get description => _description;
  String get photoPath => _photoPath;
  int get statusId => _statusId;


  //Convert a Post object into a Map object
  Map<String, dynamic> toMap(){
    var data = Map<String, dynamic>();

    data["userId"] = _userId;
    data["postTypeId"] = _postTypeId;
    data["createdAt"] = _createdAt;
    data["description"] = _description;
    data["photoPath"] = _photoPath;
    data["statusId"] = _statusId;
 
    if(_id != null){
      data["id"] = _id;
    }

    return data;
  }
  
  //Extract a Post object from a Map object
  Post.fromObject(dynamic data){
    this._id = data["id"];
    this._userId = data["userId"];
    this._postTypeId = data["postTypeId"];
    this._createdAt = data["createdAt"];
    this._description = data["description"];
    this._photoPath = data["photoPath"];
    this._statusId = data["statusId"];
  }

}