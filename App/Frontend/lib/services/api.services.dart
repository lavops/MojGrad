import 'dart:convert' as convert;
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

   static Future<bool> insertLike(Like like) async
  {
    String url = serverURL+'Likes';

    var likeMap = like.toMap();
    var jsonBody = convert.jsonEncode(likeMap);
    print(jsonBody);
   // if(checkLike(k.lik, k.password).toString() == "true")
     // return false;
    //else
    {
      var res = await http.post(url, headers: header, body: jsonBody);
      return true;
    }
  }
 

 
}