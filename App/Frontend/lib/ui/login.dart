import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{

  @override
  Widget build(BuildContext context){


    // Just displaying simple text after splashscreen
    return Scaffold(
        body: Center(
          child: Text('Login Page')
        )
    );
  }
}