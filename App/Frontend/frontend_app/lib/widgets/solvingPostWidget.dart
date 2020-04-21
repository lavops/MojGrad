import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/models/challengeSolving.dart';
import 'package:frontend/models/constantsDeleteEdit.dart';
import 'package:frontend/models/likeViewModel.dart';
import 'package:frontend/models/reportType.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/models/fullPost.dart';
import 'package:frontend/ui/challengeSolvingPage.dart';
import 'package:frontend/ui/commentsPage.dart';
import 'package:frontend/ui/homePage.dart';
import 'package:frontend/ui/likesPage.dart';
import 'package:frontend/ui/mapPage.dart';
import 'package:frontend/ui/othersProfilePage.dart';
import 'package:frontend/widgets/circleImageWidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:frontend/models/constants.dart';
import 'dart:convert';
import '../services/api.services.dart';

class SolvingPostWidget extends StatefulWidget {
  final ChallengeSolving solvingPost;

  SolvingPostWidget(this.solvingPost);

  @override
  _SolvingPostWidgetState createState() => _SolvingPostWidgetState(solvingPost);
}

class _SolvingPostWidgetState extends State<SolvingPostWidget> {
  ChallengeSolving solvingPost;

  _SolvingPostWidgetState(ChallengeSolving solvingPost1) {
    this.solvingPost = solvingPost1;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (solvingPost == null) ? Center() : newPost(); //buildPostList()
  }

  Widget newPost() {
    return Card(
        child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          userInfoRow(),
          imageGallery(),
          SizedBox(height: 2.0),
          description(),
          SizedBox(height: 10.0),
        ]));
  }

  Widget userInfoRow() =>
      Row(
        children: <Widget>[
          InkWell(
              onTap: () {
                if (userId != solvingPost.userId)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OthersProfilePage(solvingPost.userId)),
                  );
              },
              child: CircleImage(
                serverURLPhoto + solvingPost.userPhoto,
                imageSize: 36.0,
                whiteMargin: 2.0,
                imageMargin: 6.0,
              )),
          InkWell(
              onTap: () {
                if (userId != solvingPost.userId)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OthersProfilePage(solvingPost.userId)),
                  );
              },
              child: Text(
                solvingPost.username,
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Expanded(child: SizedBox()),
        ],
      );

  Widget imageGallery() => Container(
        constraints: BoxConstraints(
          maxHeight: 300.0, // changed to 400
          minHeight: 200.0, // changed to 200
          maxWidth: double.infinity,
          minWidth: double.infinity,
        ),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey[200],
              width: 1.0,
            ),
          ),
        ),
        child: Image(image: NetworkImage(serverURLPhoto + solvingPost.solvingPhoto)),
      );

  Widget description() =>
      Container(
          child: Row(
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          InkWell(
              onTap: () {
                if (userId != solvingPost.userId)
                  Navigator.push(
                    context,
                    MaterialPageRoute( builder: (context) => OthersProfilePage(solvingPost.userId)),
                  );
              },
              child: Text(solvingPost.username, style: TextStyle(fontWeight: FontWeight.bold))),
          SizedBox(
            width: 10,
          ),
          Flexible(child: Text(solvingPost.description),
          )
        ],
      ));
}