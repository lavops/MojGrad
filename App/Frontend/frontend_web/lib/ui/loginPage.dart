import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar( 
        backgroundColor: Colors.lightGreen,
        title: Text(
         "MOJ GRAD",
          style: TextStyle(
            color: Colors.white38,
            fontSize: 22.0,
          ),   
        ),
      ),
      body: Center(
        child: Text("Login page"),
      ),
    );
  }
}