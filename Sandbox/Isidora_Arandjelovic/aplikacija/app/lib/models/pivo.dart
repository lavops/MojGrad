class Pivo{
  int id;
  String naziv;
  int ocena;

  Pivo({this.naziv, this.ocena});

  factory Pivo.fromJson(Map<String, dynamic> json){
    return Pivo(
      naziv: json['naziv'],
      ocena: json['ocena']
    );
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map["naziv"] = naziv;
    map["ocena"] = ocena;

    if(id != null){
      map["id"] = id;
    }
    return map;
  }

  Pivo.fromObject(dynamic o){
    this.id = o["id"];
    this.naziv = o["naziv"];
    this.ocena = o["ocena"];
  }

}