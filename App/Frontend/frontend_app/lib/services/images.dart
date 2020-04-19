import 'dart:convert';
import 'package:async/async.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

  final  String imageUploadURL = 'http://10.0.2.2:60676/api/ImageUpload';
  //final  String imageUploadURL = 'http://192.168.1.2:45455/api/ImageUpload';
  //final  String imageUploadURL = 'http://192.168.1.4:45455/api/ImageUpload';

  final  String imageUploadURLProfilePhoto = 'http://10.0.2.2:60676/api/ImageUpload/ProfilePhoto';
  //final  String imageUploadURLProfilePhoto = 'http://192.168.1.2:45455/api/ImageUpload/ProfilePhoto';
  //final  String imageUploadURLProfilePhoto = 'http://192.168.1.4:45455/api/ImageUpload/ProfilePhoto';

imageUpload(File imageFile) async {
 
  var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
  var length= await imageFile.length();

  var uri = Uri.parse(imageUploadURL);

  var request= new http.MultipartRequest("POST", uri);
  var mulipartFile = new http.MultipartFile('files', stream, length, filename: basename(imageFile.path));

  request.files.add(mulipartFile);
  var response =await request.send();
  print(response.statusCode);
  response.stream.transform(utf8.decoder).listen((value){
    print(value);
  });

}

imageUploadProfilePhoto(File imageFile) async {
 
  var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
  var length= await imageFile.length();

  var uri = Uri.parse(imageUploadURLProfilePhoto);

  var request= new http.MultipartRequest("POST", uri);
  var mulipartFile = new http.MultipartFile('files', stream, length, filename: basename(imageFile.path));

  request.files.add(mulipartFile);
  var response =await request.send();
  print(response.statusCode);
  response.stream.transform(utf8.decoder).listen((value){
    print(value);
  });

}
