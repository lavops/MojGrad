import 'package:flutter/material.dart';
import './managementPage.dart';
import './homePage.dart';

class NavDrawer extends StatelessWidget {
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
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/mg.png'))),
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
            MaterialPageRoute(builder: (context) => managementPage()),
            ),},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Odjavite se'),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}