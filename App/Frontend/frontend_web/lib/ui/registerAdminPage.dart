import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:frontend_web/models/admin.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/homePage.dart';

import '../models/city.dart';
import '../models/user.dart';
import '../services/api.services.dart';

class RegisterAdminPage extends StatefulWidget {
  @override
  _RegisterAdminPageState createState() => _RegisterAdminPageState();
}

class _RegisterAdminPageState extends State<RegisterAdminPage> {
  String wrongRegText = "";

  TextEditingController firstName = new TextEditingController();
  TextEditingController lastName = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(
        "OK",
        style: TextStyle(color: Colors.green),
      ),
      onPressed: () {
        String jwt = TokenSession.getToken;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage.fromBase64(jwt)),
        );
        ;
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Uspešna registracija"),
      content: Text("Prijavi se da bi nastavio."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _register(String firstName, String lastName, String email,String password) {
    final flNameRegex = RegExp(r'^[a-zA-Z]{1,10}$');
    final passRegex = RegExp(r'[a-zA-Z0-9.!]{6,}');
    final emailRegex = RegExp(r'^[a-z0-9._]{2,}[@][a-z]{3,6}[.][a-z]{2,3}$');
   
    if (flNameRegex.hasMatch(firstName)) {
      if (flNameRegex.hasMatch(lastName)) {
            if (emailRegex.hasMatch(email)) {
              if (passRegex.hasMatch(password)) {
                var pom = utf8.encode(password);
                var pass = sha1.convert(pom);
                Admin adm = Admin.without(
                    firstName,
                    lastName,
                    pass.toString(),
                    email);
                APIServices.registration(adm).then((response) {
                  if (response.statusCode == 200) {
                    Map<String, dynamic> jsonObject =
                        json.decode(response.body);
                    User extractedUser = new User();
                    extractedUser = User.fromObject(jsonObject);
                    User user1;
                    setState(() {
                      user1 = extractedUser;
                      wrongRegText = "";
                    });
                    if (user1 != null) {
                      showAlertDialog(context);
                    }
                  } else {
                    setState(() {
                      wrongRegText = "Podaci nisu ispravni".toUpperCase();
                    });
                    throw Exception('Email ili username već zauseti');
                  }
                });
              } else {
                setState(() {
                  wrongRegText =
                      "Loša šifra. Šifra mora imati najmanje 6 karaktera."
                          .toUpperCase();
                });
                throw Exception(
                    "Loša sifra. Sifra mora imati najmanje 6 karaktera.");
              }
            } else {
              setState(() {
                wrongRegText = "Neispravan email.".toUpperCase();
              });
              throw Exception("Neispravan email.");
            }  
      } else {
        setState(() {
          wrongRegText = "Unesite ispravno prezime.".toUpperCase();
        });
        throw Exception("Unesite drugo prezime.");
      }
    } else {
      setState(() {
        wrongRegText = "Unestite ispravno ime.".toUpperCase();
      });
      throw Exception("Unesite drugo ime.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstNameWidget = Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      elevation: 6.0,
      child: TextField(
        controller: firstName,
        style: TextStyle(
          //color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 20, right: 15),
            child: Icon(Icons.person, color: Colors.green[800]),
          ),
          contentPadding: EdgeInsets.all(18),
          labelText: "Ime",
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(width: 2, color: Colors.green[800]),
          ),
        ),
      ),
    );

    final lastNameWidget = Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      elevation: 6.0,
      child: TextField(
        controller: lastName,
        style: TextStyle(
          //color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 20, right: 15),
            child: Icon(Icons.person, color: Colors.green[800]),
          ),
          contentPadding: EdgeInsets.all(18),
          labelText: "Prezime",
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(width: 2, color: Colors.green[800]),
          ),
        ),
      ),
    );

    
    final emailWidget = Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      elevation: 6.0,
      child: TextField(
        controller: email,
        style: TextStyle(
          //color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 20, right: 15),
            child: Icon(Icons.email, color: Colors.green[800]),
          ),
          contentPadding: EdgeInsets.all(18),
          labelText: "E-mail",
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(width: 2, color: Colors.green[800]),
          ),
        ),
      ),
    );

    

    final passwordWidget = Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      elevation: 6.0,
      child: TextField(
        obscureText: _secureText,
        controller: password,
        style: TextStyle(
          //color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
          suffixIcon: IconButton(
            onPressed: showHide,
            icon: Icon(_secureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.green[800]),
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 20, right: 15),
            child: Icon(Icons.phonelink_lock, color: Colors.green[800]),
          ),
          contentPadding: EdgeInsets.all(18),
          labelText: "Šifra",
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(width: 2, color: Colors.green[800]),
          ),
        ),
      ),
    );

    final registerButtonWidget = SizedBox(
      height: 48.0,
      child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: Text(
            "Registruj novog admina",
            style: TextStyle(fontSize: 16.0),
          ),
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          textColor: Colors.white,
          color: Colors.green[800],
          onPressed: () {
               _register(firstName.text, lastName.text, email.text, password.text);
          }),
    );

    final wrongReg = Center(
        child: Text(
      '$wrongRegText',
      style: TextStyle(color: Colors.red),
    ));

    return Scaffold(
      appBar: AppBar(
        title: Text("Registrovanje novog admina"),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 600,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(15.0),
            children: <Widget>[
              SizedBox(
                height: 30.0,
              ),
              firstNameWidget,
              lastNameWidget,
              emailWidget,
              passwordWidget,
              SizedBox(
                height: 12.0,
              ),
              registerButtonWidget,
              SizedBox(
                height: 12.0,
              ),
              SizedBox(
                height: 12.0,
              ),
              wrongReg,
            ],
          ),
        ),
      ),
    );
  }
}
