import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/widgets/collapsingInsNavigationDrawer.dart';
import 'package:frontend_web/widgets/postWidget.dart';
import './navDrawer.dart';

int insId;

class InstitutionPage extends StatefulWidget {
  InstitutionPage(this.jwt, this.payload);
  factory InstitutionPage.fromBase64(String jwt) => InstitutionPage(
      jwt,
      json.decode(
          ascii.decode(base64.decode(base64.normalize(jwt.split(".")[1])))));

  final String jwt;
  final Map<String, dynamic> payload;

  @override
  _InstitutionPageState createState() => new _InstitutionPageState(jwt, payload);

}

class _InstitutionPageState extends State<InstitutionPage> {

  final String jwt;
  final Map<String, dynamic> payload;

  _InstitutionPageState(this.jwt, this.payload);


  _getInstitutionId() async {
    int inId = int.parse(payload['sub']);
    setState(() {
      insId = inId;
    });
  }

  @override
  void initState() {
    super.initState();
    _getInstitutionId();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Institucija',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Institucija'),
        ),
        body: Row(
          children: <Widget>[
              CollapsingInsNavigationDrawer(),
              Center(

        )
      ],
    )
    ));
    }
  }


