import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/ui/login.dart';


class registrationPage extends StatefulWidget {
  @override
  _registrationPageState createState() => _registrationPageState();
}

class _registrationPageState extends State<registrationPage> {
  String firstName, lastName, email, mobile, password;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
    }
  }

  List<String> _locations = ['Kragujevac', 'Beograd', 'Novi Sad', 'Niš'];
  String _selectedLocation;

  @override
  Widget build(BuildContext context) {
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
              /*        SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        height: 50,
                        child: Text(
                          "Registracija",
                          style: TextStyle(color: Colors.green, fontSize: 15.0),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
              */
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0)),
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "  Unesite ime.";
                            }
                          },
                          onSaved: (e) => firstName = e,
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
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "  Unesite prezime.";
                            }
                          },
                          onSaved: (e) => lastName = e,
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

                      //card for Email TextFormField
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "  Unesite e-mail.";
                            }
                          },
                          onSaved: (e) => email = e,
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

                      //card for Mobile TextFormField
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "  Unesite broj mobilnog telefona.";
                            }
                          },
                          onSaved: (e) => mobile = e,
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
                        child: TextFormField(
                          obscureText: _secureText,
                          onSaved: (e) => password = e,
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
                                color: Color(0xff4caf50),
                                onPressed: () {
                                  check();
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
          ],
        ),
      ),
    );
  }
}
