  
import 'dart:convert';

import 'package:app/models/user.dart';
import 'package:app/signup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as  http;
import 'package:app/ui/piva.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/signup': (BuildContext context) => new SignupPage(),
        '/signin' : (BuildContext context) => new MyHomePage(),
        '/piva' : (BuildContext context) => new Piva()
      },
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      resizeToAvoidBottomPadding: false, //videti sta znaci?? da ne izlaze neke zute linije??
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, //da text ne bi otisao na desnu stranu, nego da bude u pravcu
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Center(
              child: Container(
                constraints: BoxConstraints.expand(
                      height: 200.0,
                      width: 200.0,
                    ),
                    child: Image.asset('assets/img/AntsLogo.png'),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                     prefixIcon: Icon(
                        Icons.account_circle,
                        color: Colors.orange,
                      ),
                    //hintText: 'Enter your Email',
                    labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green) //boja linije
                    )
                  ),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.orange,
                    ),
                    //hintText: 'Enter your Password',
                    labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green) //boja linije
                    )
                  ),
                  obscureText: true,
                ),               
                Container(
                    child: GestureDetector(
                      onTap:(){
                        
                      },
                      child: Center(
                        child: RaisedButton(
                          onPressed: () {

                              String url = "http://192.168.8.105:45457/login";
                              User u = User();
                              u.username = usernameController.text;
                              u.password = passwordController.text;
                              Map<String, dynamic> mapa = u.toMap();

                              var bodyy = jsonEncode(mapa);
                              print(bodyy);
                              var body = jsonEncode({
                                "username" : usernameController.text,
                                "password" : passwordController.text
                              });
                              Map<String, String> header = {
                                "Accept": "application/json",
                                "Content-type":"application/json"
                              };
                            http.post(url, headers: header, body: body).then((response){
                              if(response.statusCode == 200){
                                //print(response.statusCode);
                                Navigator.of(context).pushNamed('/piva');
                              }else{
                                Navigator.of(context).pushNamed('/signin');
                              }
                              });

                              },
                            padding: EdgeInsets.only(right: 0.0),
                            color: Colors.orange,
                          child: Text(
                            'Login'
                          ),
                        ),
                      ),
                    ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Don\'t have an Account?',
                style: TextStyle(fontFamily: 'Montserrat'),
              ),
              SizedBox(width: 5.0),
              InkWell(
                onTap: (){
                  Navigator.of(context).pushNamed('/signup');
                },
                child: Text('Register',
                style: TextStyle(
                  color: Colors.orange,
                  fontFamily: 'Montserrat',
                  decoration: TextDecoration.underline
                )
                ),
              )
            ],
          )
        ],
    ));
  }
}