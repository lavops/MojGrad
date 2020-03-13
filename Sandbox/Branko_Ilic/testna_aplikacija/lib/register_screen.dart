import 'dart:convert';
import 'package:flutter/material.dart';
import 'user.dart';
import 'api_servcies.dart';
import 'user_info_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState()
  {
    return RegisterScreenState();
  }
}

class RegisterScreenState extends State<RegisterScreen> {
  String _username;
  String _email;
  String _password;
  String _firstName;
  String _lastName;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  User userRcv;


  registerUser(email, password, username, firstName, lastName){
    APIServices.register(email, password, username, firstName, lastName).then((response){
      Map<String, dynamic> jsonObject = json.decode(response.body);
      User extractedUser = new User();
      extractedUser = User.fromObject(jsonObject);
      setState(() {
        userRcv = extractedUser;
      });
    });
  }


  Widget _buildUsernameField() {
    return TextFormField (
      decoration: InputDecoration(labelText: 'Korisnicko ime'),
      maxLength: 16,
      validator: (String value)
      {
        if(value.isEmpty)
        {
          return 'Unesite korisnicko ime';
        }
      },
      onSaved: (String value) {
        _username = value;
      },
    );
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
      maxLength: 32,
      obscureText: true,
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


  Widget _buildFirstNameField() {
    return TextFormField (
      decoration: InputDecoration(labelText: 'Ime'),
      maxLength: 16,
      validator: (String value)
      {
        if(value.isEmpty)
        {
          return 'Unesite ime';
        }
      },
      onSaved: (String value) {
        _firstName = value;
      },
    );
  }

  Widget _buildLastNameField()
  {
    return TextFormField (
      decoration: InputDecoration(labelText: 'Prezime'),
      maxLength: 16,
      validator: (String value)
      {
        if(value.isEmpty)
        {
          return 'Unesite prezime';
        }
      },
      onSaved: (String value) {
        _lastName = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Moj grad")),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildUsernameField(),
                _buildEmailField(),
                _buildPasswordField(),
                _buildFirstNameField(),
                _buildLastNameField(),

                SizedBox(height: 100),
                RaisedButton(
                  child: Text(
                    'Registruj se',
                    style: TextStyle(color: Colors.teal, fontSize: 16),
                  ),
                  onPressed: () {
                    if (!_formKey.currentState.validate()) {
                      return;
                    }

                    _formKey.currentState.save();

                    print("Uspesna registracija!");
                    

                    registerUser(_email, _password, _username, _firstName, _lastName);
                    if(userRcv != null){
                      print('Prijavio se korisnik');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserScreen(userRcv)),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}