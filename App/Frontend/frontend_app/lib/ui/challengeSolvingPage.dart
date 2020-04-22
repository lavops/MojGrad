import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/models/challengeSolving.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/ui/ChallengeSolvingCameraPage.dart';
import 'package:frontend/ui/homePage.dart';
import 'package:frontend/widgets/solvingPostWidget.dart';

class ChallengeSolvingPage extends StatefulWidget {
  int postId;
  int ownerId;
  int solved;
  ChallengeSolvingPage(this.postId, this.ownerId, this.solved);
  @override
  _ChallengeSolvingPageState createState() => _ChallengeSolvingPageState(postId, ownerId, solved);
}

class _ChallengeSolvingPageState extends State<ChallengeSolvingPage> {
  int postId;
  int ownerId;
  int solved;
  String textForSolving = "RESI";
  List<ChallengeSolving> listChallengeSolving;

  _ChallengeSolvingPageState(int postId1, int ownerId1, int solved1) {
    this.postId = postId1;
    this.ownerId = ownerId1;
    this.solved = solved1;
  }

  _getChallengeSolving() async {
    var jwt = await APIServices.jwtOrEmpty();
    APIServices.getChallengeSolving(jwt, postId, userId).then((res) {
      if(res.statusCode == 200)
        print("RADI MI DOBRO");
      Iterable list = json.decode(res.body);
      List<ChallengeSolving> listP = List<ChallengeSolving>();
      listP = list.map((model) => ChallengeSolving.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          listChallengeSolving = listP;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getChallengeSolving();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          actions: <Widget>[
            IconButton(
              icon: Text(
                textForSolving,
                style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold)
              ),
              onPressed: (){
                _goToCameraPage();
              },
            ),
            SizedBox(width: 10.0,)
          ],
        ),
        body:ListView.builder(
          padding: EdgeInsets.only(bottom: 30.0),
          itemCount: listChallengeSolving == null ? 0 : listChallengeSolving.length,
          itemBuilder: (BuildContext context, int index) {
            return SolvingPostWidget(listChallengeSolving[index], ownerId);
          }
        )
    );
  }

  _goToCameraPage() async{
    int result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ChallengeSolvingCameraPage(postId, ownerId)),
    );

    _getChallengeSolving();
  }
}
