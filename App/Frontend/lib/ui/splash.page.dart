import 'package:flutter/material.dart';
import 'package:frontend/ui/login.dart';

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
      Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
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
        child: Image.asset('assets/mojGrad3.png', width: 300),
      ),
    );

    // Text element with alignment
    final from = Align(
      alignment: Alignment.center,
      child: Text(
        'from',
      ),
    );

    // Text element with alignment
    final ants = Align(
      alignment: Alignment.center,
      child: Text(
        'A N T S',
        style: TextStyle(
          fontSize: 30.0,
          color: Colors.orange
        ),
      ),
    );

    // Returning how page should look
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child:Container(
          width: 400,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              logo,
              SizedBox(height: 48.0,),
              from,
              ants
            ],
          ),
        )
      )
    );
    
  }
}