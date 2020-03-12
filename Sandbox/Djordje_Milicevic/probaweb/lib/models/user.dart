class User{
  int idUser;
  String mail;
  String sifra;
  String korisnickoIme;
  String ime;
  String prezime;
  String token;

  User();

  int get _idUser => idUser;
  String get _mail => mail;
  String get _sifra => sifra;
  String get _korisnickoIme => korisnickoIme;
  String get _ime => ime;
  String get _prezime => prezime;
  String get _token => token;

  set _korisnickoIme(String newKorisnickoIme){
    korisnickoIme = newKorisnickoIme;
  }

  set _ime(String newIme){
    ime = newIme;
  }

  set _prezime(String newPrezime){
    prezime = newPrezime;
  }

  set _mail(String newMail){
    mail = newMail;
  }

  set _sifra(String newSifra){
    sifra = newSifra;
  }

  set _token(String newToken){
    token = newToken;
  }

  Map<String, dynamic> toMap(){
    var map = Map<String,dynamic>();
    map['idUser'] = idUser;
    map['mail'] = mail;
    map['sifra'] = sifra;
    map['korisnickoIme'] = korisnickoIme;
    map['ime'] = ime;
    map['prezime'] = prezime;
    map['token'] = token;

    return map;
  }

  User.fromObject(dynamic o){
    this.idUser = o['idUser'];
    this.mail = o['mail'];
    this.sifra = o['sifra'];
    this.korisnickoIme = o['korisnickoIme'];
    this.ime = o['ime'];
    this.prezime = o['prezime'];
    this.token = o['token'];
  }
}