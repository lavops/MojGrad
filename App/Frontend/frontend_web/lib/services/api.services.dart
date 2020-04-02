import 'dart:convert' as convert;
import 'dart:convert';
import 'package:frontend_web/models/user.dart';
import 'package:http/http.dart' as http;


class APIServices
{

  //static String serverURL = 'http://10.0.2.2:52739/api/';
  static String serverURL = 'http://127.0.0.1:44732/api/';


  static Map<String, String> header = { 
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };

  static Future getUser(int userId) async{
    return await http.get(serverURL +'User/'+userId.toString());
    
  }

  // Login funtion
  static Future login(String mail, String password) async{
    String url = serverURL + 'User/Login';

    var body = jsonEncode({ 'email': mail, 'password': password });

    return await http.post(url,headers: {"Content-Type": "application/json"},body: body);
  }

  static Future registration(User user) async  {
   String url = serverURL + 'User/Register';
    var data = Map();
    data["firstName"] = user.firstName;
    data["lastName"] = user.lastName;
    data["username"] = user.username;
    data["password"] = user.password;
    data["email"] = user.email;
    data["phone"] = user.phone;
    data["cityId"] = user.cityId;
    data["userTypeId"] = user.userTypeId; 
    var jsonBody = convert.jsonEncode(data);
    print(jsonBody);
    return await http.post(url, headers: header, body: jsonBody);
  }

  //fetch method for cities
  static Future getCity() async
  {
    return await http.get(serverURL + 'City');
  }

  //returns user with specific id for deletion
  static Future deleteUser(int id) async {
    String url = serverURL + 'User/Delete';
    return await http.post(url, headers: header, body: convert.jsonEncode({ 'id' : id, }));
  }

  //returns post with specific id for deletion
  static Future deletePost(int id) async {
    String url = serverURL + 'Post/Delete';
    
    return await http.post(url, headers: header,body: jsonEncode({ 'id': id, }),);
  }

}