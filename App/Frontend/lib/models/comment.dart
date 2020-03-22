class Comment{
  int _id;
  int _postId;
  int _userId;
  String _description;
  String _username;

  Comment(this._id, this._username, this._postId, this._userId, this._description);

  int get id => _id;
  String get username => _username;
  int get postId => _postId;
  int get userId => _userId;
  String get description => _description;

  Map<String, dynamic> toMap(){
    var data = Map<String, dynamic>();

    data["postId"] = _postId;
    data["userId"] = _userId;
    data["description"] = _description;

    if(_id != null){
      data["id"] = _id;
    }

    return data;
  }

  Comment.fromObject(dynamic data){
    this._id = data["id"];
    this._postId = data["postId"];
    this._userId = data["userId"];
    this._description = data["description"];
    this._username = data["username"];
  }
}