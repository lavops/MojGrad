class Korisnik
{
  int _id;
  String _ime;
  String _prezime;
  String _email;
  String _sifra;
  
  Korisnik(this._id, this._ime, this._prezime, this._email, this._sifra);
  Korisnik.WithOut(this._ime, this._prezime, this._email, this._sifra);

  int get id => _id;
  String get ime => _ime;
  String get prezime => _prezime;
  String get email => _email;
  String get sifra => _sifra;

 //saljemo kao json fajl
  Map<String, dynamic> toMap()
  {
    var map = Map<String, dynamic>();
    
    map["email"] = _email;
    map["sifra"] = _sifra;
    map["ime"] = _ime;
    map["prezime"] = _prezime;
   

    if(_id != null)
      map["id"] = _id;

    return map;
  }

  //pretvaramo iz json-a u object 
  Korisnik.fromObject(dynamic data)
  {
    this._id = data["id"];
    this._ime = data["ime"];
    this._prezime = data["prezime"];
    this._email = data["email"];
    this._sifra = data["sifra"];

  }
}