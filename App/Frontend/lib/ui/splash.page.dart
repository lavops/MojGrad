import 'package:flutter/material.dart';

import 'package:frontend/ui/homePage.dart';

class SplashPage extends StatefulWidget{

  @override
  _SplashPageState createState() => new _SplashPageState();
}

class _SplashPageState extends State<SplashPage>{

  // This function needs to be done again once we implement login & register
  // It will check if we have logged user in our session/memory
  // If we have user in memory we will redirect to Homescreen
  // If not it will be reddirected to Login Page
  void initState(){
    super.initState();
    Future.delayed(
      Duration(seconds: 2),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyBottomBar()),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context){

    // Image element with our logo
    // If we get new logo we will just change it here
    final logo = Hero(
      tag: 'hero',
      child: Center(
        child: Image.asset('assets/mojGrad4.png', width: 300),
      ),
    );

    final fromAnts = Align(
      alignment: Alignment.bottomCenter,
      child: Image.asset('assets/fromAnts1.png', width: 150)
    );
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child:Container(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(color: Colors.white),
                flex: 1,
              ),
              Expanded(
                child: logo,
                flex: 3,
              ),
              Expanded(
                child: fromAnts,
                flex: 1,
              ),
            ],
          ),
        )
      )
    );
  }
}