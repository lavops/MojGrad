import 'dart:convert' as convert;
import 'dart:convert';
import 'package:frontend_web/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

String userPhotoURL = "http://127.0.0.1:60676//";

class APIServices
{

  static String serverURL = 'http://127.0.0.1:60676/api/';


  static Map<String, String> header = { 
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };

  // returns reported users
  static Future getReportedUsers() async {
    return await http.get(serverURL + 'Report');
  }

  // reported users with id
  static Future getReportedUser(int userId) async {
    return await http.get(serverURL + 'Report/' + userId.toString());
  }


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

 
   static Future getUsers() async {
    return await http.get(serverURL + 'User');
  }

 //return all posts
  static Future getPost() async{
    return await http.get(serverURL +'Post');
    
  }

  //return all posts from a specific user
   static Future getPostsForUser(int userId) async{
    String url = serverURL + 'Post/UsersPosts';
    var data = Map();
    data["id"] = userId;
    var jsonBody = convert.jsonEncode(data);
    return await http.post(url,headers:header,body: jsonBody);
  }
  
  //send a new post to the database
   static Future<String> addPost (String token, int userId, int postTypeId, String description, String photoPath,  int statusId, double latitude, double longitude) async {
    String url = serverURL + 'Post';

    var data = Map();
    data["userId"] = userId;
    data["postTypeId"] = postTypeId;
    data["description"] = description;
    data["photoPath"] = photoPath;
    data["statusId"] = statusId;
    data["latitude"] = latitude;
    data["longitude"] = longitude;


    var jsonBody = convert.jsonEncode(data);
    var res = await http.post(url, headers: header, body: jsonBody);
    String data2 = res.body.toString();
    print(data2);
    return data2;
  }

  //send a new like to the database
  static Future<String> addLike( int postId, int userId, int typeId) async {
    String url = serverURL + 'Like';

    var data = Map();
    data["postId"] = postId;
    data["userId"] = userId;
    data["likeTypeId"] = typeId;

    var jsonBody = convert.jsonEncode(data);
    var res = await http.post(url, headers: header, body: jsonBody);
    String data2 = res.body.toString();
    return data2;
  }

  //return all comments on one post
  static Future getComments(int postId) async
  {
    return await http.get(serverURL +'Comment/'+postId.toString());
    
  }

  //send a new comment to the database
  static Future<String> addComment( String comm, int userId, int postId) async {
    String url = serverURL + 'Comment';

    var data = Map();
    data["description"] = comm;
    data["userId"] = userId;
    data["postId"] = postId;

    var jsonBody = convert.jsonEncode(data);
    var res = await http.post(url, headers: header, body: jsonBody);
    String data2 = res.body.toString();
    return data2;
  }

  //return types of posts (example smeće, rupe...)
  static Future getPostType() async
  {
    return await http.get(serverURL +'PostType');

  }

  static Future getSolvedPosts() async {
     return await http.get(serverURL +'Post/SolvedPosts');
  }

  static Future getUnsolvedPosts() async {
     return await http.get(serverURL +'Post/UnsolvedPosts');
  }

}