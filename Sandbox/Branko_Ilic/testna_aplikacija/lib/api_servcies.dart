import 'dart:convert';
import 'package:http/http.dart' as http;

class APIServices{
  
  static Future fetchUser() async{
    String userURL = 'https://localhost:7420/api/User';

    return await http.get(userURL);
  }

  static Future register(String email, String password, String username, String firstName, String lastName) async{
    String registerURL = 'http://localhost:7420/api/User/Register';

    var body = jsonEncode({ 'email': email, 'passwrod': password, 'username': username, 'firstName': firstName, 'lastName': lastName });

    print(body);

    return await http.post(registerURL,headers: {"Content-Type": "application/json"},body: body);
  }

  static Future login(String email, String password) async{
    String loginURL = 'http://localhost:7420/api/User/Login';

    var body = jsonEncode({ 'email': email, 'password': password });

    return await http.post(loginURL,headers: {"Content-Type": "application/json"},body: body);
  }

  
}