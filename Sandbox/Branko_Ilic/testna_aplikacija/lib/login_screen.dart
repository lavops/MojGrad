import 'dart:convert';
import 'package:flutter/material.dart';
import 'user.dart';
import 'api_servcies.dart';
import 'user_info_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState()
  {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  String _email;
  String _password;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  User user;

  loginUser(email, password){
    APIServices.login(email, password).then((response){
      Map<String, dynamic> jsonObject = json.decode(response.body);
      User extractedUser = new User();
      extractedUser = User.fromObject(jsonObject);

      setState(() {
        user = extractedUser;
      });
    });
  }

  Widget _buildEmailField() {
     return TextFormField(
      decoration: InputDecoration(labelText: 'Email'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Unesite email';
        }

        if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Molimo vas da unesete validan email';
        }

        return null;
      },
      onSaved: (String value) {
        _email = value;
      },
    );
  }  

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Sifra'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Unesite sifru';
        }

        return null;
      },
      onSaved: (String value) {
        _password = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Moj grad"),),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildEmailField(),
              _buildPasswordField(),

              SizedBox(height: 100,),
              RaisedButton(
                child: Text("Uloguj se", style: TextStyle(fontSize: 16),),
                onPressed: () {
                  if(!_formKey.currentState.validate()) {
                    return;
                  }

                  _formKey.currentState.save();
                  
                  loginUser(_email, _password);

                  if(user != null)
                  {
                    print('Prijavio se korisnik');
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => UserScreen(user)),
                    );
                  }
                },
              ),
              RaisedButton(
                child: Text("Registruj se", style: TextStyle(fontSize: 16),),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }

  
}