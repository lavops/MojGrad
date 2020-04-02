import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_frontend/services/api.services.dart';
import 'package:web_frontend/models/fullPost.dart';
import 'package:web_frontend/models/user.dart';
import 'package:web_frontend/ui/navDrawer.dart';
import 'package:web_frontend/widgets/postWidget.dart';

class postPage extends StatefulWidget {
  final User user;
  postPage(this.user);
  @override
  _postPageState createState() => _postPageState(user);
}

class _postPageState extends State<postPage>{
  String token = '';
  User user;
  _postPageState(User user1){
    this.user = user1;
  }

  List<FullPost> listPosts;
  _getPosts() {
    APIServices.getPost().then((res) {
      Iterable list = json.decode(res.body);
      List<FullPost> listP = List<FullPost>();
      listP = list.map((model) => FullPost.fromObject(model)).toList();
      if(mounted){
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
  Widget build(BuildContext context){
    return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.grey[50],
          leading: Builder(
              builder: (BuildContext context){
                return IconButton(
                  icon: Icon(Icons.menu),
                  color: Colors.black87,
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              }),
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
            Icon(Icons.notifications,color: Colors.black,),
            SizedBox(width: 16.0),
          ],
        ),
        body: RefreshIndicator(
            onRefresh: () async {
              _getPosts();
            },
            child: (listPosts != null)?
            PostWidget(listPosts):
            Center(child: CircularProgressIndicator(
              valueColor:new AlwaysStoppedAnimation<Color>(Colors.green[800]),
            ),
            )
        )
    );
  }
}