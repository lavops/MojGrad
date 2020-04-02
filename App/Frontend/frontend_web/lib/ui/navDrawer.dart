import 'package:flutter/material.dart';
import 'package:frontend_web/ui/loginPage.dart';
import 'package:frontend_web/ui/managementPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './homePage.dart';

class NavDrawer extends StatelessWidget {

  _removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('user');
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Moj grad',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            decoration: BoxDecoration(
                color: Colors.white,
             ),
          ),
          ListTile(
            leading: Icon(Icons.perm_identity),
            title: Text('Administrator'),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Početna strana'),
            onTap: () =>{ Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            ),},
          ),
          ListTile(
            leading: Icon(Icons.timer),
            title: Text('Zadavanje misija'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Upravljanje'),
            onTap: () => { Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ManagementPage()),
            ),},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Odjavite se'),
            onTap: () => {
              _removeToken(),
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              )
            },
          ),
        ],
      ),
    );
  }
}