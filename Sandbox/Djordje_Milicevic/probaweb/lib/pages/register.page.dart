import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:probaweb/models/user.dart';
import 'package:probaweb/functions/api.services.dart';
import 'package:probaweb/pages/login.page.dart';
import 'package:probaweb/pages/profile.page.dart';



class RegisterPage extends StatefulWidget{
  static String tag = "login-page";
  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>{

  final formKey = GlobalKey<FormState>();

  String mail, sifra, ime, prezime, korisnickoIme;
  User userRcv;
  String pogresanRegisterText = '';

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
          hintText: 'Sifra',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0)
          )
      ),
      onSaved: (input) => sifra = input,
    );

    final imeText = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      initialValue: '',
      decoration: InputDecoration(
        hintText: 'Ime',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0)
        ),
      ),
      onSaved: (input) => ime = input,
    );

    final prezimeText = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      initialValue: '',
      decoration: InputDecoration(
        hintText: 'Prezime',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0)
        ),
      ),
      onSaved: (input) => prezime = input,
    );

    final korisnickoImeText = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      initialValue: '',
      decoration: InputDecoration(
        hintText: 'Korisnicko Ime',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0)
        ),
      ),
      onSaved: (input) => korisnickoIme = input,
    );

    final registerButton = Padding(
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
              if(emailText != '' && sifra != '' && korisnickoIme != '' && ime != '' && prezime != '')
              {
                APIServices.register(mail, sifra, korisnickoIme, ime, prezime).then((response){
                  if (response.statusCode == 200) {
                    Map<String, dynamic> jsonObject = json.decode(response.body);
                    User extractedUser = new User();
                    extractedUser = User.fromObject(jsonObject);
                    setState(() {
                      userRcv = extractedUser;
                      pogresanRegisterText = '';
                    });
                    if(userRcv != null){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage(userRcv)),
                      );
                    }
                  } else {
                    setState(() {
                      pogresanRegisterText = 'Postoji korisnik sa tim mail-om u bazi!';
                    });
                    throw  Exception('Already Exists');
                  }
                });
              }
              else{
                setState(() {
                  pogresanRegisterText = 'Pogresni podaci!';
                });
              }
            },
            color: Colors.lightBlueAccent,
            child: Text(
              'Register',
              style: TextStyle(
                  color: Colors.white
              ),
            )
        ),
      ),
    );

    final registerLabel = FlatButton(
      child: Text(
        "Already have account? Log in!",
        style: TextStyle(
            color: Colors.black54
        ),
      ),
      onPressed: (){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },
    );

    final pogresanRegister = Center( child: Text(
      '$pogresanRegisterText',
      style: TextStyle(color: Colors.red),
    ));

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
                        SizedBox(height: 8.0,),
                        korisnickoImeText,
                        SizedBox(height: 8.0,),
                        imeText,
                        SizedBox(height: 8.0,),
                        prezimeText,
                        SizedBox(height: 24.0,),
                        registerButton,
                        pogresanRegister
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