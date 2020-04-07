import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/ui/homePage.dart';
import 'package:frontend/ui/registrationPage.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  String pogresanLoginText = '';

  User user;

  _login(String _email, String _password) {
    if (_email == '' || _password == '') {
      _emailController.text = "";
      _passwordController.text = "";
      setState(() {
        pogresanLoginText = "Podaci nisu ispravni";
      });
      throw Exception('Los email/sifra');
    } else {
      var pom = utf8.encode(_password);
      var pass = sha1.convert(pom);
      APIServices.login(_email, pass.toString()).then((response) {
        if (response != null) {
          storage.write(key: "jwt", value: response);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage.fromBase64(response)));
        } else {
          _passwordController.text = "";
          setState(() {
            pogresanLoginText = "PODACI NISU ISPRAVNI";
          });
          throw Exception('Bad username/password');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //logo
    final logo = Hero(
      tag: 'hero',
      child: Center(
          child: Image.asset(
        'assets/mojGrad4.png',
        width: 300,
      )),
    );

    //text box for email
    final emailText = TextField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email, color: Colors.green[800]),
        hintText: 'E-mail',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide(width: 2, color: Colors.green[800]),
        ),
      ),
      controller: _emailController,
    );

    //text box for password
    final passwordText = TextField(
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.lock,
          color: Colors.green[800],
        ),
        hintText: 'Šifra',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide(width: 2, color: Colors.green[800]),
        ),
      ),
      controller: _passwordController,
    );

    //button for login
    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(50.0),
        shadowColor: Colors.lightGreenAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 50.0,
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(50.0),
              side: BorderSide(color: Colors.transparent)),
          onPressed: () {
            // Call login function
            _login(_emailController.text, _passwordController.text);
          },
          color: Colors.green[800],
          child: Text(
            'Uloguj se',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

    //redirection to page for new users
    final registerLabel = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Novi korisnik?'),
        SizedBox(
          width: 5.0,
        ),
        InkWell(
          child: Text(
            'Registrujte se ovde.',
            style: TextStyle(
                color: Colors.green[800], fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RegisterPage()),
            );
          },
        ),
      ],
    );

    //in case of wrong login
    final pogresanLogin = Center(
        child: Text(
      '$pogresanLoginText',
      style: TextStyle(color: Colors.red),
    ));

    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Container(
          width: 400,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              logo,
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 48.0,
                  ),
                  emailText,
                  SizedBox(
                    height: 8.0,
                  ),
                  passwordText,
                  SizedBox(
                    height: 24.0,
                  ),
                  loginButton,
                ],
              ),
              registerLabel,
              SizedBox(
                height: 8.0,
              ),
              pogresanLogin,
            ],
          ),
        )));
  }
}
