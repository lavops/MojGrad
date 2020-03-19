import 'dart:convert' as convert;
import 'package:frontend/models/comment.dart';
import 'package:frontend/models/like.dart';
import 'package:http/http.dart' as http;



class APIServices
{
  static String serverURL = 'http://10.0.2.2:52739/api/';



  static Map<String, String> header = { 
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };

  //the function returns class FullPost
   static Future getPost() async
  {
    return await http.get(serverURL +'FullPosts');
    
  }

   static Future<String> insertLike(Like like) async
  {
    String url = serverURL+'Likes';

    var likeMap = like.toMap();
    var jsonBody = convert.jsonEncode(likeMap);
    print(jsonBody);
    var res = await http.post(url, headers: header, body: jsonBody);
    return res.body.toString();
    
  }


  static Future getComments(int id) async
  {
    return await http.get(serverURL +'FullComment/'+id.toString());
    
  }

 static Future<String> addComment(
    String comm, int userId, int postId) async {
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


 
}