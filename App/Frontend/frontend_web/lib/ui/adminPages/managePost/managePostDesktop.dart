import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_web/models/fullPost.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/widgets/centeredView/centeredViewPost.dart';
import 'package:frontend_web/widgets/collapsingNavigationDrawer.dart';
import 'package:frontend_web/widgets/post/singlePostWidget.dart';

class ManagePostDesktop extends StatefulWidget {
  @override
  _ManagePostDesktopState createState() => _ManagePostDesktopState();
}

class _ManagePostDesktopState extends State<ManagePostDesktop> {

  List<FullPost> listPosts;
  List<FullPost> listSolvedPosts;
  List<FullPost> listUnsolvedPosts;
  _getSolvedPosts() {
    APIServices.getSolvedPosts(TokenSession.getToken).then((res) {
      Iterable list = json.decode(res.body);
      List<FullPost> listP = List<FullPost>();
      listP = list.map((model) => FullPost.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          listSolvedPosts = listP;
        });
      }
    });
  }

  _getUnsolvedPosts() {
    APIServices.getUnsolvedPosts(TokenSession.getToken).then((res) {
      Iterable list = json.decode(res.body);
      List<FullPost> listP = List<FullPost>();
      listP = list.map((model) => FullPost.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          listUnsolvedPosts = listP;
        });
      }
    });
  }

  _getAllPosts() async {
    APIServices.getPost(TokenSession.getToken).then((res) {
      Iterable list = json.decode(res.body);
      List<FullPost> listP = List<FullPost>();
      listP = list.map((model) => FullPost.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          listPosts = listP;
        });
      }
    });
  }

  @override
  initState() {
    super.initState();
    _getAllPosts();
    _getSolvedPosts();
    _getUnsolvedPosts();
  }

  @override
  Widget build(BuildContext context) {
    
    return Stack(children: <Widget>[
      CenteredViewPost(
          child: TabBarView(children: <Widget>[
            ListView.builder(
              padding: EdgeInsets.only(bottom: 30.0),
              itemCount: listPosts == null ? 0 : listPosts.length,
              itemBuilder: (BuildContext context, int index) {
                return SinglePostWidget(listPosts[index]);
              }
            ),
            ListView.builder(
              padding: EdgeInsets.only(bottom: 30.0),
              itemCount: listSolvedPosts == null ? 0 : listSolvedPosts.length,
              itemBuilder: (BuildContext context, int index) {
                return SinglePostWidget(listSolvedPosts[index]);
              }
            ),
            ListView.builder(
              padding: EdgeInsets.only(bottom: 30.0),
              itemCount: listUnsolvedPosts == null ? 0 : listUnsolvedPosts.length,
              itemBuilder: (BuildContext context, int index) {
                return SinglePostWidget(listUnsolvedPosts[index]);
              }
            ),
          ]
          ),
      ),
      CollapsingNavigationDrawer(),
      ]
    );
  }
  
}