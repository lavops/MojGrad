import 'dart:convert' as convert;
<<<<<<< HEAD
import 'package:frontend/models/comment.dart';
import 'package:frontend/models/like.dart';
import 'package:frontend/models/post.dart';
=======
>>>>>>> d46b548576f1b6263ce6f3e2c697f8b8f344dca7
import 'package:http/http.dart' as http;


class APIServices
{

  //static String serverURL = 'http://10.0.2.2:52739/api/';
  static String serverURL = 'http://127.0.0.1:52739/api/';


  static Map<String, String> header = { 
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };

  //function returns class FullPost
  static Future getPost() async{
    return await http.get(serverURL +'FullPosts');
    
  }

  //function for new like
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

  static Future<String> setPost(Post post) async
  {
    String postURL = serverURL + 'Posts';
    var postMap = post.toMap();
    var jsonBody = convert.jsonEncode(postMap);

    var res = await http.post(postURL, headers: header, body: jsonBody);

    return res.body.toString();
  }

  //function returns class comment
  static Future getComments(int id) async
  {
    return await http.get(serverURL +'FullComment/'+id.toString());
    
  }

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

  static Future getPostType() async
  {
    return await http.get(serverURL +'postType');
    

  }

 
}