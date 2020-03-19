
import 'package:flutter/material.dart';

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
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: ExactAssetImage('assets/logo.png'),
                  fit: BoxFit.cover,
                )),
          ),
          ListTile(
            leading: Icon(Icons.format_list_numbered),
            title: Text('Nerešeni slučajevi'),
            onTap: () => { },
          ),
          ListTile(
            leading: Icon(Icons.done_outline),
            title: Text('Rešeni slučajevi'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.filter_vintage),
            title: Text('Ostalo'),
            onTap: () => {},
          ),
        ],
      ),
    );
  }
}