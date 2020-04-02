
import 'package:flutter/material.dart';
import 'package:frontend/ui/homePage.dart';
import 'package:frontend/ui/solvedPostsPage.dart';
import 'package:frontend/ui/unsolvedPostsPage.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: Colors.lightGreen,
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 80,
                    margin: EdgeInsets.only(top:60),
                    child: Text("Moj Grad", style: TextStyle(color:Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                  )
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.format_list_numbered),
            title: Text('Nerešeni slučajevi', style: TextStyle(fontSize: 16),),
            onTap: () { 
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UnsolvedPostsPage(publicUser)),
                  );
            },
          ),
          ListTile(
            leading: Icon(Icons.done_outline),
            title: Text('Rešeni slučajevi', style: TextStyle(fontSize: 16),),
            onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SolvedPostsPage(publicUser)),
                    );
            },
          ),
          ListTile(
            leading: Icon(Icons.filter_vintage),
            title: Text('Ostalo', style: TextStyle(fontSize: 16),),
            onTap: () {
              Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
            },
          ),
        ],
      ),
    );
  }
}