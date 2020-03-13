import 'dart:convert';

import 'package:app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  @override
  Widget build(BuildContext context) {

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
            children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                    child: Text(
                      'SignUp',
                      style:
                          TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(260.0, 125.0, 0.0, 0.0),
                    child: Text(
                      '.',
                      style: TextStyle(
                          fontSize: 80.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  )
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(
                              Icons.email,
                              color: Colors.green,
                            ),
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                              //hintText: 'EMAIL',
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                          labelText: 'Password ',
                            prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.green,
                          ),
                          //hintText: 'password',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                      obscureText: true,
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(
                            Icons.account_circle,
                            color: Colors.green,
                          ),
                          //hintText: 'Enter your username',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                    ),
                    Container(
                        child: RaisedButton(
                          onPressed: () {
                              Navigator.of(context).pushNamed('/piva');
                              },
                            padding: EdgeInsets.only(right: 0.0),
                            color: Colors.green,

                        child: GestureDetector(
                            onTap: () async{
                              String myUrl = "http://192.168.8.105:45457/registracija";
                              User u = User();

                              u.username = usernameController.text;
                              u.password = passwordController.text;
                              u.email = emailController.text;

                              Map<String, dynamic> mapa = u.toMap();

                              var bodyy = jsonEncode(mapa);
                              print(bodyy);
                              var body = jsonEncode({
                                "username" : usernameController.text,
                                "password" : passwordController.text,
                                "email": emailController.text
                              });
                              Map<String, String> header = {
                                "Accept": "application/json",
                                "Content-type":"application/json"
                              };
                              http.post(myUrl, headers: header, body: body).then((response){
                                print(response.statusCode);
                                if(response.statusCode == 200){
                                  
                                  Navigator.of(context).pushNamed('/signin');
                                }else{
                                  //obavestenje da se lose registrovao
                                  Navigator.of(context).pushNamed('/signin');
                                }
                              });
                            Navigator.of(context).pushNamed('/signin');
                            },
                            child: Center(
                              child: Text(
                                'Sign up',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat'),
                              ),),
                            ),
                        )),
                    Container(
                      //height: 40.0,
                      //color: Colors.transparent,
                      child: Container(
                              child: RaisedButton(
                          onPressed: () {
                              Navigator.of(context).pushNamed('/signin');
                              },
                            padding: EdgeInsets.only(right: 0.0),
                            color: Colors.black,
                          child: Text(
                            'Go back',
                             style:
                          TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      ),
                  ],
                )),
        ]));
  }
}