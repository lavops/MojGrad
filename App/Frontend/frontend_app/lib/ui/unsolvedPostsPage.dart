import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/models/fullPost.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/ui/NavDrawer.dart';
import 'package:frontend/ui/homePage.dart';
import 'package:frontend/widgets/postWidget.dart';

class UnsolvedPostsPage extends StatefulWidget {
  final User user;
  UnsolvedPostsPage(this.user);
  @override
  _UnsolvedPostsPageState createState() => _UnsolvedPostsPageState(user);
}

class _UnsolvedPostsPageState extends State<UnsolvedPostsPage> {
  String token = '';
  User user;
  List<FullPost> listPosts;

  _UnsolvedPostsPageState(User user1) {
    this.user = user1;
  }


  _getPosts() {
    APIServices.getUnsolvedPosts().then((res) {
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
  void initState() {
    super.initState();
    _getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black87),
              title: Text('Nerešeni slučajevi', style: TextStyle(color: Colors.green)),
              backgroundColor: Colors.white,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  }),
            ),
        body: RefreshIndicator(
            onRefresh: () async {
              _getPosts();
            },
            child: (listPosts != null)
                ? PostWidget(listPosts)
                : Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.green[800]),
                    ),
                  )));
  }
}
