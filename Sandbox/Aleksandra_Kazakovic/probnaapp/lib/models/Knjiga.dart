class Knjiga
{
  int _id;
  String _naziv;
  String _autor;
  int _cena;
  
 Knjiga(this._id, this._naziv, this._autor, this._cena);
 

  int get id => _id;
  String get naziv => _naziv;
  String get autor => _autor;
  int get cena => _cena;

  Map<String, dynamic> toMap()
  {
    var data = Map<String, dynamic>();
    
    data["naziv"] = _naziv;
    data["autor"] = _autor;
    data["cena"]=_cena;

    if(_id != null)
      data["id"] = _id;

    return data;
  }

  Knjiga.fromObject(dynamic data)
  {
    this._id = data["id"];
    this._naziv = data["naziv"];
    this._autor = data["autor"];
    this._cena = data["cena"];
  }
}