import 'package:flutter/material.dart';
import './navDrawer.dart';

class managementPage extends StatefulWidget {
  @override
  _managementPageState createState() => _managementPageState();
}

class _managementPageState extends State<managementPage> {

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          title: Text("Upravljanje"),
        ),
        body: Center(
          child: Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 250.0,
                    width: 250.0,
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.group,size:150),
                          Text("Upravljanje korisnicima", style: TextStyle(color: Colors.white, fontSize: 17.0)),
                        ],
                      ),
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      textColor: Colors.white,
                      color: Color(0xff558b2f),
                      onPressed: () {

                      }
                      )
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                ),
                SizedBox(
                  height: 250.0,
                  width: 250.0,
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.library_books,size:150),
                          Text("Upravljanje objavama", style: TextStyle(color: Colors.white, fontSize: 17.0)),
                        ],
                      ),
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      textColor: Colors.white,
                      color: Color(0xff1b5e20),
                      onPressed: () {

                      }
                      ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 250.0,
                  width: 250.0,
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.monetization_on ,size:150),
                          Text("Upravljanje sponzorstvima", style: TextStyle(color: Colors.white, fontSize: 17.0)),
                        ],
                      ),
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      textColor: Colors.white,
                      color: Color(0xff33691e),
                      onPressed: () {

                      }
                      ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                ),
                SizedBox(
                  height: 250.0,
                  width: 250.0,
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.verified_user,size:150),
                          Text("Autentifikacija", style: TextStyle(color: Colors.white, fontSize: 17.0)),
                        ],
                      ),
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      textColor: Colors.white,
                      color: Color(0xff4caf50),
                      onPressed: () {

                      }
                      ),
                ),
              ],
            ),
          ],
          ),
        ),
      );
}