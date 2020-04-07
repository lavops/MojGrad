import 'package:flutter/material.dart';
import 'package:frontend_web/models/user.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'dart:convert';
import './navDrawer.dart';

class HomePage extends StatefulWidget {
 HomePage(this.jwt, this.payload);
  factory HomePage.fromBase64(String jwt) => HomePage(
      jwt,
      json.decode(
          ascii.decode(base64.decode(base64.normalize(jwt.split(".")[1])))));

  final String jwt;
  final Map<String, dynamic> payload;
  @override
  _HomePageState createState() => new _HomePageState(jwt, payload);
}
User globalUser;
int userId;

class _HomePageState extends State<HomePage> {
    final String jwt;
  final Map<String, dynamic> payload;
  _HomePageState(this.jwt, this.payload);

  User user1;

  _getUser() async {
    userId = int.parse(payload['sub']);
    var res = await APIServices.getUser(TokenSession.getToken,userId);
    Map<String, dynamic> jsonUser = jsonDecode(res.body);
    User user = User.fromObject(jsonUser);
    setState(() {
      user1 = user;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Moj Grad"),
      ),
      drawer: NavDrawer(),
      body:  Center(
        child: Text('Admin: ' + user1.firstName),
      ),
    );
  }
}
