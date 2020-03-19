import 'dart:convert' as convert;
import 'package:frontend/models/like.dart';
import 'package:frontend/models/post.dart';
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
	
  
    //this method returns list of post types
    static Future<List<String>> getPostTypes() async{
    String postTypeURL = serverURL + 'postType';
    
    var data = await http.get(postTypeURL);

    var jsonBody = convert.jsonDecode(data.body);

    List<String> categories = [];

    for(var type in jsonBody)
    {
      categories.add(type['typeName']);
    }

    return categories;
  } 


  static Future<int> getPostType(String type) async
  {
    String postTypeURL = serverURL + 'postType';
    var data = await http.get(postTypeURL);
    var jsonBody = convert.jsonDecode(data.body);

    /*
    var data = Map();
    data['postType'] = type;

    var jsonBody = convert.jsonEncode(data);
    */

    for(var pt in jsonBody)
    {
      if( pt['typeName'] == type )
      {
        return pt['id'];
      }
    }

    return -1;
  }

  static Future setPost(Post post) async
  {
    String postURL = serverURL + 'Posts';
    var postMap = post.toMap();
    var jsonBody = convert.jsonEncode(postMap);

    var res = await http.post(postURL, headers: header, body: jsonBody);

    return res;
  }

 
}