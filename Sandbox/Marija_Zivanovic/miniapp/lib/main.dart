import 'dart:convert';
//import 'dart:js';
import 'package:miniapp/home.dart';
import 'package:flutter/material.dart';
import 'package:miniapp/user.dart';
import 'package:http/http.dart' as http;
import 'package:miniapp/widgets.dart';


Future<User> login(String username, String password) async {
  final response = await http.post('http://10.0.2.2:5001/api/Users/login',
  headers: <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String> {
      'email': username,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    throw  Exception("RADI");
    //Navigator.of(context).pushNamed('/home');
    //return User.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    //throw Exception('Bad username/password');
    throw  Exception("Pogresna adresa/lozinka");
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context)=>Home(),
         
      },
      title: 'Flutter Demo',
      theme: ThemeData(
       
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
final TextEditingController email = TextEditingController();
final TextEditingController password = TextEditingController();
Future<User> _futureUser;
  @override
  Widget build(BuildContext context) {
    
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(50.0, 80.0, 0.0, 0.0),
                  child: new Slika(),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: email,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintText: "Korisničko ime",
                    border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: password,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintText: "Lozinka",
                      border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                      obscureText: true,
                ),
                
                SizedBox(height: 40.0),
                Container(
                  height: 40.0,
                  child: Material(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Color(0xff8bc34a),
                    elevation: 7.0,
                    child: GestureDetector(
                      onTap: () {
                      setState(() {
                          _futureUser = login(email.text, password.text);
                        });
                        
                      } ,
                      child: Center(
                        child: Text(
                          'Uloguj se',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat'
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

