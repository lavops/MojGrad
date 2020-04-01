import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/ui/homePage.dart';
import 'package:frontend/ui/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget{

  @override
  _SplashPageState createState() => new _SplashPageState();
}

class _SplashPageState extends State<SplashPage>{

  String token = '';
  User user;


  _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _token = prefs.getString('token');
    print(prefs.getString("user"));
    Map<String, dynamic> jsonObject = json.decode(prefs.getString('user'));
     User extractedUser = new User();
     extractedUser = User.fromObject(jsonObject);
    setState(() {
      token = _token;
      user = extractedUser;
    });
  }
  // This function needs to be done again once we implement login & register
  // It will check if we have logged user in our session/memory
  // If we have user in memory we will redirect to Homescreen
  // If not it will be reddirected to Login Page
  void initState(){
    super.initState();
    _getToken();
    Future.delayed(
      Duration(seconds: 2),
      () {
        if(token != ''){
          var tokenSplit = token.split('.');
          var payload = json.decode(ascii.decode(base64.decode(base64.normalize(tokenSplit[1]))));
          var exp = payload["exp"] * 1000000;
          if(DateTime.fromMicrosecondsSinceEpoch(exp).isAfter(DateTime.now())){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          }
          else{
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          }
        }
        else{
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      }
    );
  }
/*
 void initState(){
    super.initState();
    Future.delayed(
      Duration(seconds: 2),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    );
  }
*/
  @override
  Widget build(BuildContext context){

    // Image element with our logo
    // If we get new logo we will just change it here
    final logo = Hero(
      tag: 'hero',
      child: Center(
        child: Image.asset('assets/mojGrad4.png', width: 300),
      ),
    );

    final fromAnts = Align(
      alignment: Alignment.bottomCenter,
      child: Image.asset('assets/fromAnts1.png', width: 150)
    );
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child:Container(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(color: Colors.white),
                flex: 1,
              ),
              Expanded(
                child: logo,
                flex: 3,
              ),
              Expanded(
                child: fromAnts,
                flex: 1,
              ),
            ],
          ),
        )
      )
    );
  }
}