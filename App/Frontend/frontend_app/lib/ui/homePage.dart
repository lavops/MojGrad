import 'package:flutter/material.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/ui/CameraPage.dart';
import 'package:frontend/ui/SponsorshipPage.dart';
import 'package:frontend/ui/feedPage.dart';
import 'package:frontend/ui/mapPage.dart';
import 'package:frontend/ui/user_profile_page.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  int _currentTabIndex = 0;
  String token = '';
  User user;

  _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _token = prefs.getString('token');
    Map<String, dynamic> jsonObject = json.decode(prefs.getString('user'));
     User extractedUser = new User();
     extractedUser = User.fromObject(jsonObject);
    setState(() {
      token = _token;
      user = extractedUser;
    });
  }
  
  @override
  void initState() {
    super.initState();
    _getToken();
  }

  @override
  Widget build(BuildContext context){
    final _kTabPages = <Widget>[
      FeedPage(user),
      MapPage(),
      CameraPage(),
      SponsorshipPage(),
      UserProfilePage(user),
    ];

    final _kBottomNavBarItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(Icons.list), title: Text("Pocetna")),
      BottomNavigationBarItem(icon: Icon(Icons.satellite), title: Text("Mapa")),
      BottomNavigationBarItem(icon: Icon(Icons.nature_people), title: Text("Kamera")),
      BottomNavigationBarItem(icon: Icon(Icons.attach_money), title: Text("Sponzorstva")),
      BottomNavigationBarItem(icon: Icon(Icons.account_circle), title: Text("Profil"))
    ];

    return Scaffold(
      body: _kTabPages[_currentTabIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {
            _currentTabIndex = 2;
          });
        },
        child: Icon(Icons.nature_people),
        backgroundColor: Colors.green[800],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          items: _kBottomNavBarItems,
          currentIndex: _currentTabIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (int index){
            setState(() {
              _currentTabIndex = index;
            });
          },
          selectedItemColor: Colors.green[800],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}