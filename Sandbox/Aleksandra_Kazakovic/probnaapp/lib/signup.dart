import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'package:probnaapp/services/api.services.dart';

import 'models/Korisnik.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  void getApi() async {
    //Response response = await get('http://10.0.2.2:57323/api/Users');
   // var data = jsonDecode(response.body);
    //print(data);
  }

  var email=TextEditingController();
  var sifra=TextEditingController();
  var ime=TextEditingController();
  var prezime=TextEditingController();


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.blueGrey,
      body:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 80.0, 0.0, 0.0),
                  child: Center(
                  child: Text(
                    'Registracija',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(51, 53, 54,1)
                    ),
                  ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(
                       fontFamily: 'Oswald-ExtraLight',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(38, 38, 38, 1),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5.0),
                TextField(
                   controller: sifra,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Šifra",
                    labelStyle: TextStyle(
                      fontFamily: 'Oswald-ExtraLight',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                       color: Color.fromRGBO(38, 38, 38, 1),
                      ),
                    ),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 5.0),
                TextField(
                   controller: ime,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Ime",
                    labelStyle: TextStyle(
                       fontFamily: 'Oswald-ExtraLight',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(38, 38, 38, 1),
                      ),
                    ),
                  ),
                ),
                 SizedBox(height: 5.0),
                TextField(
                   controller: prezime,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Prezime",
                    labelStyle: TextStyle(
                       fontFamily: 'Oswald-ExtraLight',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(38, 38, 38, 1),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.0),
                Container(
                  height: 40.0,
                  child: Material(
                    
                    borderRadius: BorderRadius.circular(40.0),
                    shadowColor: Colors.grey,
                    color: Color.fromRGBO(38, 38, 38, 1),
                    elevation: 7.0,
                    child: GestureDetector(
                      onTap: () async {
                       
                        
                        var pom = utf8.encode(sifra.text);
                        var pass = sha1.convert(pom);
                         Korisnik k = Korisnik.WithOut(ime.text, prezime.text,email.text,pass.toString());
                          APIServices.registrujKorisnika(k).then((res){
                            if(res)
                              Navigator.pushReplacementNamed(context, '/glavna');
                            else{
                               showDialog(
                            context: context,
                            builder: (BuildContext context){
                              return AlertDialog(
                              title: Text("Upozorenje!"),
                              content: Text("Niste ispravno popunili."),
                              actions: [
                                FlatButton(
                                  child: Text("OK"),
                                  onPressed: () {Navigator.of(context).pop();},
                                ),
                              ]);
                            });
                            }
                              
                          });
                        
                      },
                      child: Center(
                       
                        child: Text(
                          "Registruj se",
                          style: TextStyle(
                           color: Colors.grey,
                            
                            fontFamily: 'Oswald-Bold',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  height: 40.0,
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 1.0),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                       
                      },
                      child: Center(
                        child: Text(
                          "Nazad",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                             fontFamily: 'Oswald-ExtraLight',
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
     
    );
  }
}
