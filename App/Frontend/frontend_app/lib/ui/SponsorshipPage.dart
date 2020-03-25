import 'package:flutter/material.dart';

class SponsorshipPage extends StatefulWidget {
  @override
  _SponsorshipPageState createState() => _SponsorshipPageState();
}

class _SponsorshipPageState extends State<SponsorshipPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.transparent,
        title:Text("Sponzorstvo"),
      ),
      body: Container(
        child: Center(
          child: Text("Stranica za sponzore"),
        ),
      ),
    );
  }
}