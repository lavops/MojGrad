import 'package:flutter/material.dart';
import 'package:frontend_web/models/user.dart';
import 'package:frontend_web/ui/homePage.dart';
import 'package:frontend_web/services/api.services.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  final formKey = GlobalKey<FormState>();
  String _email, _password;
  String pogresanLoginText = '';

  User user;

  _saveToken(Map<String, dynamic> jsonObject) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', jsonObject['token']);
    await prefs.setString('user', json.encode(jsonObject));
  }

  @override
  Widget build(BuildContext context){

    //logo
    final logo = Hero(
      tag: 'hero',
      child: Center(
        child: Image.asset('assets/mojGrad4.png', width: 500,)
      ),
    );

    //text box for email
    final emailText = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      initialValue: '',
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email,color: Colors.green[800]),
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide(width: 2,color: Colors.green[800]),
        ),
      ),
      onSaved: (input) => _email = input,
    );


    //text box for password
    final passwordText = TextFormField(
      autofocus: false,
      initialValue: '',
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock,color: Colors.green[800],),
        hintText: 'Sifra',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide(width: 2,color: Colors.green[800]),
        ),
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
                  _saveToken(jsonObject);
                  User extractedUser = new User();
                  extractedUser = User.fromObject(jsonObject);
                  setState(() {
                    user = extractedUser;
                    pogresanLoginText = "";
                  });
                  if(user != null){
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
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
        onTap: (){
           Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => null),
        );
        },
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
        width: 500,
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