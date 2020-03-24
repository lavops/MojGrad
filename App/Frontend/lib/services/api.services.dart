import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;


class APIServices
{

  static String serverURL = 'http://10.0.2.2:52739/api/';
  //static String serverURL = 'http://127.0.0.1:52739/api/';


  static Map<String, String> header = { 
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };

  //return all posts
  static Future getPost() async{
    return await http.get(serverURL +'FullPosts');
    
  }

  //return all posts from a specific user
   static Future getPostsForUser(int userId) async{
    String url = serverURL + 'FullPosts/UsersPosts';
    var data = Map();
    data["id"] = userId;
    var jsonBody = convert.jsonEncode(data);
    return await http.post(url,headers:header,body: jsonBody);
  }

  static Future getUser(int userId) async{
    return await http.get(serverURL +'User/'+userId.toString());
    
  }

  //send a new post to the database
   static Future<String> addPost (String token, int userId, int postTypeId, String description, String photoPath,  int statusId, double latitude, double longitude) async {
    String url = serverURL + 'FullPosts';

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
    return await http.get(serverURL +'FullComment/'+postId.toString());
    
  }

  //send a new comment to the database
  static Future<String> addComment( String comm, int userId, int postId) async {
    String url = serverURL + 'FullComment';

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
    return await http.get(serverURL +'postType');

  }

  // Login funtion
  static Future login(String mail, String password) async{
    String url = serverURL + 'User/Login';

    var body = jsonEncode({ 'email': mail, 'password': password });

    return await http.post(url,headers: {"Content-Type": "application/json"},body: body);
  }



 
}