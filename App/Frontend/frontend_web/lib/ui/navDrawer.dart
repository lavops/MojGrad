import 'package:flutter/material.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/home/homeView.dart';
import 'package:frontend_web/ui/managementPage.dart';
import 'package:frontend_web/ui/statisticsPage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import './homePage.dart';

class NavDrawer extends StatelessWidget {
  _removeToken() async {
    TokenSession.setToken = "";
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
              onTap: () {
                String jwt = TokenSession.getToken;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage.fromBase64(jwt)),
                );
              }),
          ListTile(
            leading: Icon(MdiIcons.chartAreaspline),
            title: Text('Statistika'),
            onTap: () {
              Navigator.push(
                context,
                 MaterialPageRoute(builder: (context) => StatisticsPage()),
              );
            }),
          ListTile(
            leading: Icon(Icons.timer),
            title: Text('Zadavanje misija'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Upravljanje'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManagementPage()),
              ),
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Odjavite se'),
            onTap: () => {
              _removeToken(),
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeView()),
              )
            },
          ),
        ],
      ),
    );
  }
}
