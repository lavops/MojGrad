import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/models/filters.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/models/fullPost.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/widgets/postWidget.dart';

class FeedPage extends StatefulWidget {
  final User user;
  FeedPage(this.user);
  @override
  _FeedPageState createState() => _FeedPageState(user);
}

class _FeedPageState extends State<FeedPage> {
  User user;
  List<FullPost> listPosts;

  _FeedPageState(User user1) {
    this.user = user1;
  }

  _getPosts() async {
    var jwt = await APIServices.jwtOrEmpty();
    APIServices.getPost(jwt).then((res) {
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

  _getUnsolvedPosts() async {
    var jwt = await APIServices.jwtOrEmpty();
    APIServices.getUnsolvedPosts(jwt).then((res) {
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

  _getSolvedPosts() async {
    var jwt = await APIServices.jwtOrEmpty();
    var res = await APIServices.getSolvedPosts(jwt);
    print(res.body);
    Iterable list = json.decode(res.body);
    List<FullPost> listP = List<FullPost>();
    listP = list.map((model) => FullPost.fromObject(model)).toList();
    if (mounted) {
      setState(() {
        listPosts = listP;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.grey[50],
          title: Text(
            "MOJ GRAD",
            style: TextStyle(
              color: Colors.green[800],
              fontSize: 22.0,
              fontStyle: FontStyle.normal,
              fontFamily: 'pirulen rg',
            ),
          ),
          actions: <Widget>[
            SizedBox(width: 16.0),
            PopupMenuButton<String>(
                onSelected: choiceAction,
                icon: Icon(Icons.filter_list, color: Colors.black),
                itemBuilder: (BuildContext context) {
                  return Filteri.choices.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                }),
            Icon(
              Icons.notifications,
              color: Colors.black,
            ),
          ],
        ),
        body: RefreshIndicator(
            onRefresh: _handleRefresh,
            child: (listPosts != null)
                ? ListView.builder(
                    padding: EdgeInsets.only(bottom: 30.0),
                    itemCount: listPosts == null ? 0 : listPosts.length,
                    itemBuilder: (BuildContext context, int index) {
                      return PostWidget(listPosts[index]);
                    })
                : Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.green[800]),
                    ),
                  )));
  }
  
  Future<Null> _handleRefresh() async{
    await new Future.delayed(new Duration(seconds: 3));
    setState(() {
      listPosts = [];
    });
    _getPosts();
    return null;
  }

  Future<Null> choiceAction(String choice) async{
    setState(() {
      listPosts = null;
    });
    await new Future.delayed(new Duration(seconds: 1));
    if (choice == Filteri.reseni) {
      _getSolvedPosts();
    } else if (choice == Filteri.nereseni) {
      _getUnsolvedPosts();
    } else if (choice == Filteri.svi) {
      _getPosts();
    }

    return null;
  }
}
