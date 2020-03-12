import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'package:probnaapp/services/api.services.dart';

import 'glavna.dart';
import 'signup.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/signup': (BuildContext context) => new SignupPage(),
        '/glavna': (context) => Podaci(),

        //'/glavna': (BuildContext context) => new GlavnaPage(),
      },
      home: MyHomePage(title: 'Login'),
    );
    /*
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      
    );
    */
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var email = TextEditingController();
  var sifra = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.blueGrey,
        body: Column(
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 30.0, left: 20.0),
                    child: Image.asset("assets/logo1.png"),
                  ),
                ],
              ),
            ),
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 30.0),
                    child: Text(
                      'Prijavi se',
                      style: TextStyle(
                          fontSize: 40.0,
                          fontStyle: FontStyle.italic,
                          color: Color.fromRGBO(77, 77, 77, 1)),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 30.0, left: 20, right: 20.0),
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: 45,
                    padding:
                        EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Color.fromRGBO(197, 199, 201, 1),
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 5)
                        ]),
                    child: TextField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.email,
                          color: Colors.grey,
                        ),
                        hintText: 'Email',
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0),
                 
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: 45,
                    padding:
                        EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Color.fromRGBO(197, 199, 201, 1),
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 5)
                        ]),
                    child: TextField(
                      controller: sifra,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.vpn_key,
                          color: Colors.grey,
                        ),
                        hintText: 'Šifra',
                      ),
                      obscureText: true,
                    ),
                  ),
              
                  SizedBox(height: 50.0),
                  Container(
                    height: 50.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(50.0),
                      //shadowColor: Color.fromRGBO(77, 77, 77, 1),
                      color: Color.fromRGBO(197, 199, 201, 1),
                      elevation: 7.0,
                      child: GestureDetector(
                        onTap: () async {
                          //print(email.text);
                          // print(sifra.text);
                          var pom = utf8.encode(sifra.text);
                          var pass = sha1.convert(pom);
                          APIServices.proveriLogin(email.text, pass.toString())
                              .then((res) {
                            if (res == "true") {
                              Navigator.of(context).pushNamed('/glavna');
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        title: Text("Greska"),
                                        content: Text(
                                            "Niste ispravno uneli email ili lozinku."),
                                        actions: [
                                          FlatButton(
                                            child: Text("OK"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              //runApp(MyApp());
                                            },
                                          ),
                                        ]);
                                  });
                            }
                          });
                        },
                        child: Center(
                          child: Text(
                            "Prijavi se",
                            style: TextStyle(
                              color: Color.fromRGBO(66, 66, 66, 1),
                              fontFamily: 'Oswald-Bold',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/signup');
                    },
                    child: Center(
                      child: Text(
                        "Nemaš nalog? Registruj se ovde",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Color.fromRGBO(216, 182, 92, 1),
                          fontFamily: 'Oswald-Bold',
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
