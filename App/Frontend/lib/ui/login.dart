import 'package:flutter/material.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/ui/homePage.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  final formKey = GlobalKey<FormState>();
  String _email, _password;
  String pogresanLoginText = '';

  User user;

  @override
  Widget build(BuildContext context){


    //logo
    final logo = Hero(
      tag: 'hero',
      child: Center(
        child: Image.asset('assets/mojGrad4.png', width: 200,)
      ),
    );

    //text box for email
    final emailText = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      initialValue: '',
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
        )
      ),
      onSaved: (input) => _email = input,
    );


    //text box for password
    final passwordText = TextFormField(
      autofocus: false,
      initialValue: '',
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Sifra',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
        )
      ),
      onSaved: (input) => _password = input,
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
            side: BorderSide(color: Colors.transparent)
          ),
          onPressed: (){
            formKey.currentState.save();
            
            //APIServices.login(_email, _password)
            if( _email == '' || _password == '' )
            {
              print("object");
              setState(() {
                pogresanLoginText = "Podaci nisu ispravni";
              });
              throw Exception('Los email/sifra');
            }
            else{
              // Checks for status code if is ok then it goes to homepage
              APIServices.login(_email, _password).then((response){
                if (response.statusCode == 200) {
                  Map<String, dynamic> jsonObject = json.decode(response.body);
                  User extractedUser = new User();
                  extractedUser = User.fromObject(jsonObject);
                  setState(() {
                    user = extractedUser;
                    pogresanLoginText = "";
                  });
                  if(user != null){
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MyBottomBar()),
                    );
                  }
                } else {
                  setState(() {
                    pogresanLoginText = "Podaci nisu ispravni";
                  });
                  throw  Exception('Bad username/password');
                }
              });

            }
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
      Text(
        'Novi korisnik?'
      ),
      SizedBox(width: 5.0,),
      InkWell(
        child: Text('Registrujte se ovde',
        style: TextStyle(
          color: Colors.green[800],
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline
          ),
        ),
      ),
    ],
  );


  //in case of wrong login
  final pogresanLogin = Center( child: Text(
      '$pogresanLoginText',
      style: TextStyle(color: Colors.red),
    )
  );


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
                registerLabel,
                pogresanLogin,
              ],
            ),
          )
        )
    );
  }
}