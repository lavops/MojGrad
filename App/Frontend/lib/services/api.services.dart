import 'dart:convert' as convert;
import 'package:frontend/models/comment.dart';
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

   static Future<String> insertLike(Like like) async
  {
    String url = serverURL+'Likes';

    var likeMap = like.toMap();
    var jsonBody = convert.jsonEncode(likeMap);
    print(jsonBody);
    var res = await http.post(url, headers: header, body: jsonBody);
    return res.body.toString();
    
  }
<<<<<<< HEAD
	
  
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
=======


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

>>>>>>> 5c5cd5d546e1d783a589e20fb9b16c428be47ef7

 
}