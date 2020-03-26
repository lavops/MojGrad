import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:frontend/ui/login.dart';

import '../models/city.dart';
import '../models/user.dart';
import '../services/api.services.dart';


class registrationPage extends StatefulWidget {
  @override
  _registrationPageState createState() => _registrationPageState();
}

class _registrationPageState extends State<registrationPage> {
  final _key = new GlobalKey<FormState>();
  String wrongRegText= "";

  TextEditingController firstName = new TextEditingController();
  TextEditingController lastName = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController mobile = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController username = new TextEditingController();
  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }
  showAlertDialog(BuildContext context) {
      // set up the button
      Widget okButton = FlatButton(
        child: Text("OK", style: TextStyle(color: Colors.green),),
        onPressed: () {
          Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
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
  check(String firstName, String lastName, String email, String mobile, String password, String username) {
    final flNameRegex = RegExp(r'^[a-zA-Z]{1,10}$');
    final mobRegex = RegExp(r'^06[0-9]{7,8}$');
    final passRegex = RegExp(r'[a-zA-Z0-9.!]{6,}');
    final emailRegex = RegExp(r'^[a-z0-9._]{2,}[@][a-z]{3,6}[.][a-z]{2,3}$');
    final usernameRegex = RegExp(r'^[a-z0-9]{1,1}[._a-z0-9]{1,}');


    if (flNameRegex.hasMatch(firstName)) {
      if (flNameRegex.hasMatch(lastName)) {
        if (mobRegex.hasMatch(mobile)) {
          if (passRegex.hasMatch(password)) {
            if (emailRegex.hasMatch(email)) {
              if (usernameRegex.hasMatch(username)) {
                var pom = utf8.encode(password);
                var pass = sha1.convert(pom);
                User user = User.without(2, firstName, lastName, username, pass.toString(), email, mobile, 1); // visak 1
                   APIServices.registration(user).then((response){
                if (response.statusCode == 200) {
                  Map<String, dynamic> jsonObject = json.decode(response.body);
                  User extractedUser = new User();
                  extractedUser = User.fromObject(jsonObject);
                  User user1;
                  setState(() {
                    user1 = extractedUser;
                    wrongRegText = "";
                  });
                  if(user1 != null){
                      showAlertDialog(context);        
                  }
                } else {
                  setState(() {
                    wrongRegText = "Podaci nisu ispravni";
                  });
                  throw  Exception('Email ili username već zauseti');
                }
              });

              }
              else {
                setState(() {
                wrongRegText = "Unesite ponovo korisnocko ime";
              });
                throw Exception("Unesite ponovo korisnocko ime");
              }
            }
            else {
              setState(() {
                wrongRegText = "Neispravan email.";
              });
              throw Exception("Neispravan email.");
            }
          }
          else {
            setState(() {
                wrongRegText = "Loša sifra. Sifra mora imati najmanje 6 karaktera.";
              });
            throw Exception("Loša sifra. Sifra mora imati najmanje 6 karaktera.");
          }
        }
        else {
          setState(() {
                wrongRegText = "Unesite ponovo broj telefona.";
              });
          throw Exception("Unesite ponovo broj telefona.");
        }
      }
      else {
        setState(() {
                wrongRegText= "Unesite ispravno prezime";
              });
        throw Exception("Unesite drugo prezime.");
      }
    }
    else {
      setState(() {
                wrongRegText = "Unestite ispravno ime";
              });
      throw Exception("Unesite drugo ime.");
    }

  }

  List<String> _locations = ['Kragujevac', 'Beograd', 'Novi Sad', 'Niš'];
  String _selectedLocation;

/*
  //function that adds cities to list
  getLocations()
  {
    APIServices.getCity().then((res) {
      Iterable list = json.decode(res.body);
      List<City> cities = new List<City>();
      List<String> locations = new List<String>();
      cities = list.map((model) => City.fromObject(model)).toList();
      for(var city in cities )
      {
        locations.add(city.name);
      }
        setState(() {
          _locations = locations;
        });
    });
    
  }
*/
  @override
  Widget build(BuildContext context) {
    //getLocations();
    final wrongReg = Center( child: Text(
      '$wrongRegText',
      style: TextStyle(color: Colors.red),
    )
  );
  
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(15.0),
          children: <Widget>[
            Center(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.white,
                child: Form(
                  key: _key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                       SizedBox( height: 30,),                     
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0)),
                        elevation: 6.0,
                        child: TextField(
                          controller: firstName,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              border:
                              OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.person, color: Colors.grey
                                ),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Ime"),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        elevation: 6.0,
                        child: TextField(
                          controller: lastName,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              border:
                              OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.person, color: Colors.grey),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Prezime"),
                        ),
                      ),
                      //card for username TextField
                       Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        elevation: 6.0,
                        child: TextField(
                          controller: username,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              border:
                              OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.person, color: Colors.grey
                                ),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Korisnicko ime"),
                        ),
                      ),

                      //card for Email TextFormField
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        elevation: 6.0,
                        child: TextField(
                          controller: email,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              border:
                              OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.email, color: Colors.grey),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "E-mail"),
                        ),
                      ),

                      //card for Mobile TextField
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        elevation: 6.0,
                        child: TextField(
                          controller: mobile,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                            border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 20, right: 15),
                              child: Icon(Icons.phone, color: Colors.grey),
                            ),
                            contentPadding: EdgeInsets.all(18),
                            labelText: "Mobilni telefon",
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),

                      //card for Password TextFormField
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        elevation: 6.0,
                        child: TextField(
                          obscureText: _secureText,
                          controller: password,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              border:
                              OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
                              suffixIcon: IconButton(
                                onPressed: showHide,
                                icon: Icon(_secureText
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              ),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.phonelink_lock,
                                    color: Colors.grey),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Šifra"),
                        ),
                      ),
                      new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text("Izaberite svoj grad: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: Colors.grey)),
                          new Container(
                            padding: new EdgeInsets.all(16.0),
                          ),

                          new DropdownButton(
                            value: _selectedLocation,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedLocation = newValue;
                              });
                            },
                            items: _locations.map((location) {
                              return DropdownMenuItem(
                                child: new Text(location),
                                value: location,
                              );
                            }).toList(),
                          ),
                        ]
                      ),
                      Padding(
                        padding: EdgeInsets.all(12.0),
                      ),

                      new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                            height: 48.0,
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: Text(
                                  "Registruj se",
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                textColor: Colors.white,
                                color:  Colors.green[800],
                                onPressed: () {
                                 check(firstName.text, lastName.text, email.text, mobile.text, password.text, username.text);
                                  
                                }),
                          ),
                          
                          Padding(
                            padding: EdgeInsets.all(6.0),
                          ),
                          SizedBox(
                            height: 44.0,
                            child: GestureDetector(
                                child: Text("Već imate nalog? Prijavite se.", style: TextStyle(decoration: TextDecoration.underline, color: Colors.green)),
                                onTap: () {
                                   Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => LoginPage()),
                                  );
                                  }
                                 )
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            wrongReg,
          ],
        ),
      ),
    );
  }
}
