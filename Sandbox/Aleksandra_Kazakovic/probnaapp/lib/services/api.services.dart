import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:probnaapp/models/Knjiga.dart';
import 'package:probnaapp/models/Korisnik.dart';


class APIServices
{
  static String serverURL = 'http://10.0.2.2:51247/api/';

  static Future dajKnjige() async
  {
    return await http.get(serverURL +'Knjiges');
    /*
    http.Response res = await http.get(serverURL +'Knjiges');

    if(res.statusCode == 200)
    {
      var data = convert.jsonDecode(res.body);
      var itemCount = data['totalItems'];
      print(data);
      print(itemCount);
      return data;
    }
    */
  }

/*
  static Future<List<Korisnik>> dajKorisnike() async
  {
    http.Response res = await http.get(serverURL +'Korisniks');

    if(res.statusCode == 200)
    {
      var data = convert.jsonDecode(res.body);

      
    }
  }

*/
  static Map<String, String> header = { 
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };

  static Future<String> proveriLogin(String email, String sifra) async
  {
    String url = 'http://10.0.2.2:51247/api/korisniks/login';
    var data = Map();
    data["email"] = email;
    data["sifra"] = sifra;
    var jsonBody = convert.jsonEncode(data);

    var res = await http.post(url, headers: header, body: jsonBody);
    String data2 = res.body.toString();
    return data2;
  }

  static Future<bool> registrujKorisnika(Korisnik korisnik) async
  {
    String url = 'http://10.0.2.2:51247/api/Korisniks';

    var userMap = korisnik.toMap();
    var jsonBody = convert.jsonEncode(userMap);
    print(jsonBody);
    if(proveriLogin(korisnik.email, korisnik.sifra).toString() == "true")
      return false;
    else
    {
      var res = await http.post(url, headers: header, body: jsonBody);
      return true;
    }
  }
}