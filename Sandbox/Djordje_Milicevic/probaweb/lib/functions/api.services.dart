import 'dart:convert';
import 'dart:io';
import 'package:probaweb/models/user.dart';
import 'package:http/http.dart' as http;

class APIServices{
  
  static Future fetchUser() async{
    String userURL = 'https://localhost:44399/api/User'; //Za Web App
    //String userURL = 'https://192.168.0.17:45456/api/User'; //Za Mob App

    return await http.get(userURL);
  }

  static Future register(String mail, String sifra, String korisnickoIme, String ime, String prezime) async{
    String registerURL = 'https://localhost:44399/api/User/Register'; //Za Web App
    //String registerURL = 'https://192.168.0.17:45456/api/User/Register'; //Za Mob App

    var body = jsonEncode({ 'mail': mail, 'sifra': sifra, 'korisnickoIme': korisnickoIme, 'ime': ime, 'prezime': prezime });

    return await http.post(registerURL,headers: {"Content-Type": "application/json"},body: body);
  }

  static Future login(String mail, String password) async{
    String loginURL = 'https://localhost:44399/api/User/Login'; //Za Web App
    //String loginURL = 'https://192.168.0.17:45456/api/User/Login'; //Za Mob App

    var body = jsonEncode({ 'mail': mail, 'sifra': password });

    return await http.post(loginURL,headers: {"Content-Type": "application/json"},body: body);
  }

  static Future history(int id, String token) async{
    String historyUrl = 'https://localhost:44399/api/History/Count/' + id.toString(); //Za Web App
    //String historyUrl = 'https://192.168.0.17:45456/api/History/Count/' + id.toString(); //Za Mob App

    var response = await http.get(historyUrl,headers: {'Authorization': 'Bearer $token'});

    return response;
  }
}