import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testna_aplikacija/login_screen.dart';
import 'user.dart';



class UserScreen extends StatefulWidget{
  User user;
  UserScreen(User user){
    this.user = user;
  }

  @override
  UserScreenState createState() => UserScreenState(user);
}


class UserScreenState extends State<UserScreen> {
  User user;

  UserScreenState(User userdata) {
    this.user = userdata;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Moj grad")),
      body: Container(
        child: Row(
          children: <Widget>[
            Text("Ime i prezime: "+user.firstName+" "+user.lastName),
            Text("Korisnicko ime: "+user.username),
            RaisedButton(
              child: Text('Izloguj se'),
              onPressed: () {
                user = null;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            )
          ],
        )
      )
    );
  }

  
}