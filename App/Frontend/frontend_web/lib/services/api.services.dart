import 'dart:convert' as convert;
import 'dart:convert';
import 'package:frontend_web/models/admin.dart';
import 'package:frontend_web/models/user.dart';
import 'package:frontend_web/models/institution.dart';
import 'package:frontend_web/ui/homePage.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:http/http.dart' as http;


String userPhotoURL = "http://127.0.0.1:60676//";

class APIServices {
  static String serverURL = 'http://127.0.0.1:60676/api/';

  static Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };

  static Future getReportedUsers(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    return await http.get(serverURL + 'Report', headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

  // reported users with id
  static Future getReportedUser(String jwt, int userId) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    return await http.get(serverURL + 'Report/' + userId.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

  // users from cityId
  static Future getUsersFromCity(String jwt, int cityId) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    var body = jsonEncode({'cityId' : cityId.toString()});
    return await http.post(serverURL + 'User/UsersByCityId', headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: body);
  }
  
  //reported users from cityId
  static Future getReportedUsersFromCity(String jwt, int cityId) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    var body = jsonEncode({'cityId' : cityId.toString()});
    return await http.post(serverURL + 'Report/ReportByCityId', headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: body);
  }

  static Future getAdmin(String jwt, int userId) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    return await http.get(serverURL + 'Admin/' + userId.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

  // Login funtion
  static Future login(String mail, String password) async {
    String url = serverURL + 'Admin/Login';
    var body = jsonEncode({'email': mail, 'password': password});
    var res = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);
    if (res.statusCode == 200) return res.body;
    return null;
  }

  static Future registration(Admin user) async {
    String url = serverURL + 'Admin/Register';
    var data = Map();
    data["firstName"] = user.firstName;
    data["lastName"] = user.lastName;
    data["password"] = user.password;
    data["email"] = user.email;
    var jsonBody = convert.jsonEncode(data);
    print(jsonBody);
    return await http.post(url, headers: header, body: jsonBody);
  }

  //fetch method for cities
  static Future getCity(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    return await http.get(serverURL + 'City',headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

   static Future getCity1() async {
        return await http.get(serverURL + 'City',headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    });
  }

  //returns user with specific id for deletion
  static Future deleteUser(String jwt, int id) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    String url = serverURL + 'User/Delete';
    return await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
      }, body: convert.jsonEncode({
          'id': id,
        }));
  }

  //returns post with specific id for deletion
  static Future deletePost(String jwt, int id) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    String url = serverURL + 'Post/Delete';
    return await http.post(
      url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    },  body: jsonEncode({
        'id': id,
      }),
    );
  }

  static Future getUsers(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    return await http.get(serverURL + 'User',  headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

  //return all posts
  static Future getPost(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    return await http.get(serverURL + 'Post/userID='+(0).toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

  //return all posts from a specific user
  static Future getPostsForUser(String jwt, int userId) async {
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'Post/UsersPosts';
    var data = Map();
    data["id"] = userId;
    data["userID"] = 0;
    var jsonBody = convert.jsonEncode(data);
    return await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
  }

   static Future deleteComment(String jwt, int id) async {
     var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'Comment/Delete';
    return await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: convert.jsonEncode({ 'id' : id, }));
  }

  //send a new like to the database
  static Future<String> addLike(String jwt, int postId, int userId, int typeId) async {
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'Like';
    var data = Map();
    data["postId"] = postId;
    data["userId"] = userId;
    data["likeTypeId"] = typeId;

    var jsonBody = convert.jsonEncode(data);
    var res = await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
    String data2 = res.body.toString();
    return data2;
  }

  //return all comments on one post
  static Future getComments(String jwt, int postId) async {
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    return await http.get(serverURL + 'Comment/' + postId.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

  //send a new comment to the database
  static Future<String> addComment(String jwt, String comm, int userId, int postId) async {
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
    String url = serverURL + 'Comment';

    var data = Map();
    data["description"] = comm;
    data["userId"] = userId;
    data["postId"] = postId;
    var jsonBody = convert.jsonEncode(data);
    var res = await http.post(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    }, body: jsonBody);
    String data2 = res.body.toString();
    return data2;
  }

  //return types of posts (example smeće, rupe...)
  static Future getPostType(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    return await http.get(serverURL + 'PostType',headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

  static Future getSolvedPosts(String jwt) async {
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
     return await http.get(serverURL +'Post/SolvedPosts/userID='+0.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

  static Future getUnsolvedPosts(String jwt) async {
    var datas = jsonDecode(jwt);
    jwt = datas['token'].toString();
     return await http.get(serverURL +'Post/UnsolvedPosts/userID='+ 0.toString(), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }
  
  
// institution registratiton
static Future registerInstitution(Institution ins) async {
  String url = serverURL + 'Institution/Register';
  var data = Map();
  data["name"] = ins.name;
  data["description"] = ins.description;
  data["email"] = ins.email;
  data["password"] = ins.password;
  data["cityId"]  = ins.cityId;
  data["phone"] = ins.phone;
  var jbody = convert.jsonEncode(data);
  print(jbody);
  return await http.post(url, headers: header, body: jbody);
  
  }


// login institution
 static Future loginInstitution(String mail, String password) async {
    String url = serverURL + 'Institution/Login';
    var jbody = jsonEncode({'email': mail, 'password': password});
     var res = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: jbody);
    if (res.statusCode == 200) return res.body;
    return null;
  }
}
