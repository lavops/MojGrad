import 'package:flutter/material.dart';
import 'package:frontend_web/models/user.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import './navDrawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}
User globalUser;

class _HomePageState extends State<HomePage> {
  String token = '';
  User user;

  _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _token = prefs.getString('token');
    Map<String, dynamic> jsonObject = json.decode(prefs.getString('user'));
    User extractedUser = new User();
    extractedUser = User.fromObject(jsonObject);
    setState(() {
      token = _token;
      user = extractedUser;
      globalUser = extractedUser;
    });
  }

  @override
  void initState() {
    super.initState();
    _getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Moj Grad"),
      ),
      drawer: NavDrawer(),
      body: Center(
        child: Text('Admin: ' + user.firstName),
      ),
    );
  }
}
