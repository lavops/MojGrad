import 'package:flutter/material.dart';
import 'package:frontend/ui/CameraPage.dart';
import 'package:frontend/ui/NavDrawer.dart';
import 'package:frontend/ui/SponsorshipPage.dart';

class MyBottomBar extends StatefulWidget {
  @override
  _MyBottomBarState createState() => _MyBottomBarState();
}

class _MyBottomBarState extends State<MyBottomBar> {
  int _currentIndex=0;
  final List<Widget> _pages=[
    HomePage(),
    HomePage(),
    CameraPage(),
    SponsorshipPage(),
    
  ];

  void onTappedBar(int index)
  {
    setState(() {
      _currentIndex=index;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body:_pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black87,
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        items:[
          BottomNavigationBarItem(
            icon:new Icon(Icons.home),
            title: Text("Početna strana"),
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon:new Icon(Icons.check),
            title: Text("Rešeno"),
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon:new Icon(Icons.camera),
            title: Text("Kamera"),
            backgroundColor: Colors.white,
          ),

          BottomNavigationBarItem(
            icon:new Icon(Icons.attach_money),
            title: Text("Sponzorstvo"),
            backgroundColor: Colors.white,
          ),
         
        ],
         onTap: onTappedBar,
        selectedItemColor: Colors.green[800],
        
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: NavDrawer(),
      appBar: new AppBar(    
        backgroundColor: Colors.white,
        leading: Builder(
            builder: (BuildContext context){
              return IconButton(
                icon: Icon(Icons.menu),
                color: Colors.black87,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NavDrawer()),
                  );
                },
              );
            }),
        title: Text(
          "MOJ GRAD",
          style: TextStyle(
            color: Colors.green,
            fontSize: 22.0,
            fontFamily: 'pirulen rg',
          ),
          
        ),
        actions: <Widget>[
        // action button
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.black87,
            onPressed: () {

          },
        ),
        // action button
         
          IconButton(
            icon: Icon(Icons.notifications),
            color: Colors.black87,
            onPressed: () {

            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            color: Colors.black87,
            onPressed: () {

            },
          ),
       ],
      ),
    );
  }
}