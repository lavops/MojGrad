import 'package:flutter/material.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/ui/CameraPage.dart';
import 'package:frontend/ui/SponsorshipPage.dart';
import 'package:frontend/ui/feedPage.dart';
import 'package:frontend/ui/mapPage.dart';
import 'package:frontend/ui/user_profile_page.dart';
import 'dart:convert';

User publicUser;
int userId;

class HomePage extends StatefulWidget {
  HomePage(this.jwt, this.payload);
  factory HomePage.fromBase64(String jwt) => HomePage(
      jwt,
      json.decode(
          ascii.decode(base64.decode(base64.normalize(jwt.split(".")[1])))));

  final String jwt;
  final Map<String, dynamic> payload;
  @override
  _HomePageState createState() => _HomePageState(jwt, payload);
}

class _HomePageState extends State<HomePage> {
  final String jwt;
  final Map<String, dynamic> payload;
  _HomePageState(this.jwt, this.payload);

  int _currentTabIndex = 0;
  String token = '';
  User user1;
  int ind = 0;

  _getUser() async {
     var jwt = await APIServices.jwtOrEmpty();
    userId = int.parse(payload['sub']);
    var res = await APIServices.getUser(jwt, userId);
    Map<String, dynamic> jsonUser = jsonDecode(res.body);
    User user = User.fromObject(jsonUser);
    setState(() {
      user1 = user;
      publicUser = user;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    final _kTabPages = <Widget>[
      FeedPage(user1),
      MapPage(),
      CameraPage(),
      SponsorshipPage(),
      UserProfilePage(user1),
    ];

    final _kBottomNavBarItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(Icons.list), title: Text("Početna")),
      BottomNavigationBarItem(icon: Icon(Icons.satellite), title: Text("Mapa")),
      BottomNavigationBarItem(
          icon: Icon(Icons.nature_people), title: Text("Kamera")),
      BottomNavigationBarItem(
          icon: Icon(Icons.attach_money), title: Text("Sponzorstva")),
      BottomNavigationBarItem(
          icon: Icon(Icons.account_circle), title: Text("Profil"))
    ];

    return Scaffold(
      body: _kTabPages[_currentTabIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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
          onTap: (int index) {
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
