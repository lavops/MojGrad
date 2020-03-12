import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:probaweb/models/user.dart';
import 'package:probaweb/functions/api.services.dart';
import 'package:probaweb/pages/login.page.dart';

class ProfilePage extends StatefulWidget{
  User user;
  ProfilePage(User user){
    this.user = user;
  }

  @override
  _ProfilePageState createState() => _ProfilePageState(user);
}

class _ProfilePageState extends State<ProfilePage>{
  User user;
  int brojPrijava = 0;
  _ProfilePageState(User userdata){
    this.user = userdata;
  }
  
  history(){
    APIServices.history(user.idUser, user.token).then((response){
      int broj = int.parse(response.body);
      setState(() {
        brojPrijava = broj;
      });
    });
  }
  
  @override
  Widget build(BuildContext context){
    if(brojPrijava == 0)
      history();
    final appBarObject = AppBar(
      title: Row(
        children: [
          Image.asset(
            'assets/AntsLogo.png',
            fit: BoxFit.contain,
            height: 32,
          )
        ],
      ),
      backgroundColor: Colors.white,
    );

    final cardObject = Card(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 180.0,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Image.asset(
                    'assets/materialDesign.jpg',
                    fit: BoxFit.cover
                    ),
                ),
                Positioned(
                  bottom: 16.0,
                  left: 16.0,
                  right: 16.0,
                  child: FittedBox(
                    fit:BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '' + user.ime + ' ' + user.prezime,
                      style: Theme.of(context)
                      .textTheme.headline2.copyWith(color: Colors.black),
                    )
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Text('Mail: ', style: TextStyle(color: Colors.black),),
              Text(user.mail, style: TextStyle(color: Colors.blue),),
              Text(' Koliko puta se prijavio: ', style: TextStyle(color: Colors.black),),
              Text(brojPrijava.toString(), style: TextStyle(color: Colors.blue),),
              ButtonBar(
                alignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    color: Colors.green,
                    child: Text('Log out'),
                    onPressed: (){
                      user = null;
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                  )
                ],
              )
            ],
          )
        ],
      ),
    );

    return Scaffold(
      appBar: appBarObject,
      body: Center(
        child: Container(
          width: 500,
          child: ListView(
            children: <Widget>[
              cardObject
            ],
          ),
        ),
      )
    );
  }
}