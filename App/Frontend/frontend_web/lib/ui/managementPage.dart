import 'package:flutter/material.dart';
import 'package:frontend_web/ui/adminPages/registerAdminPage/registerAdminPage.dart';
import 'package:frontend_web/ui/homePage.dart';
import 'package:frontend_web/ui/institutionProfilesPage.dart';
import 'package:frontend_web/ui/postPage.dart';
import 'package:frontend_web/widgets/collapsingNavigationDrawer.dart';
import './navDrawer.dart';
import 'package:frontend_web/ui/usersProfilePage.dart';


class ManagementPage extends StatefulWidget {
  @override
  _ManagementPageState createState() => _ManagementPageState();
}

class _ManagementPageState extends State<ManagementPage> {

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        //drawer: CollapsingNavigationDrawer(),
        appBar: AppBar(
          title: Text("Upravljanje"),
        ),
        body: Row(
          children: <Widget>[
          CollapsingNavigationDrawer(),
          SizedBox(width: 300,),
          Center(
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
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => UsersProfilePage())
                          );
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
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => PostPage(globalUser))
                          );
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
                            Icon(Icons.business ,size:150),
                            Text("Upravljanje institucijama", style: TextStyle(color: Colors.white, fontSize: 17.0)),
                          ],
                        ),
                        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        textColor: Colors.white,
                        color: Color(0xff33691e),
                        onPressed: () {
                           Navigator.push(context,
                              MaterialPageRoute(builder: (context) => InstitutionProfilesPage())
                          );
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
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => RegisterAdminPage())
                          );
                        }
                        ),
                  ),
                ],
              ),
            ],
            ),
          ),
          ],
        ),
      );
}