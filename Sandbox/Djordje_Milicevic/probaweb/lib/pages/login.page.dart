import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:probaweb/models/user.dart';
import 'package:probaweb/functions/api.services.dart';
import 'package:probaweb/pages/profile.page.dart';
import 'package:probaweb/pages/register.page.dart';



class LoginPage extends StatefulWidget{
  static String tag = "login-page";
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{

  final formKey = GlobalKey<FormState>();

  String mail, sifra;
  User user;

  loginUser(mail, sifra){
    APIServices.login(mail, sifra).then((response){
      Map<String, dynamic> jsonObject = json.decode(response.body);
      User extractedUser = new User();
      extractedUser = User.fromObject(jsonObject);

      setState(() {
        user = extractedUser;
      });
    });
  }

  @override
  Widget build(BuildContext context){

    final logo = Hero(
      tag: 'hero',
      child: Center(
        child: Image.asset('assets/AntsLogo.png', width: 200,),
      ),
    );

    final emailText = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      initialValue: '',
      decoration: InputDecoration(
          hintText: 'Email',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0)
          ),
      ),
      onSaved: (input) => mail = input,
    );

    final passwordText = TextFormField(
      autofocus: false,
      initialValue: '',
      obscureText: true,
      decoration: InputDecoration(
          hintText: 'Password',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0)
          )
      ),
      onSaved: (input) => sifra = input,
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
            minWidth: 200.0,
            height: 50.0,
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
                side: BorderSide(color: Colors.transparent)
            ),
            onPressed: (){
              formKey.currentState.save();

              loginUser(mail, sifra);

              if(user != null){
                print('Prijavio se user');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage(user)),
                );
              }
            },
            color: Colors.lightBlueAccent,
            child: Text(
              'Log in',
              style: TextStyle(
                  color: Colors.white
              ),
            )
        ),
      ),
    );

    final registerLabel = FlatButton(
      child: Text(
        "Register",
        style: TextStyle(
            color: Colors.black54
        ),
      ),
      onPressed: (){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RegisterPage()),
        );
      },
    );

    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child:Container(
            width: 400,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                logo,
                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 48.0,),
                      emailText,
                      SizedBox(height: 8.0,),
                      passwordText,
                      SizedBox(height: 24.0,),
                      loginButton,
                    ],
                  ),
                ),
                registerLabel
              ],
            ),
          )
        )
    );
  }
}