import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/models/fullPost.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/ui/NavDrawer.dart';
import 'package:frontend/widgets/postWidget.dart';

class FeedPage extends StatefulWidget {
  final User user;
  FeedPage(this.user);
  @override
  _FeedPageState createState() => _FeedPageState(user);
}

class _FeedPageState extends State<FeedPage>{
  String token = '';
  User user;

  _FeedPageState(User user1){
    this.user = user1;
  }
  // mocking data for phone!
  static var mockdata = "[{\"postId\":1,\"userId\":1,\"username\":\"pera_p\",\"postTypeId\":2,\"typeName\":\"smece\",\"createdAt\":\"2020-02-03T08:50:18\",\"description\":\"Mnogo smeca\",\"photoPath\":\"post1\",\"statusId\":2,\"status\":\"nije jos reseno\",\"likeNum\":1,\"dislikeNum\":1,\"commNum\":2,\"latitude\":43.981748,\"longitude\":20.90406},{\"postId\":2,\"userId\":2,\"username\":\"ivana_mar\",\"postTypeId\":3,\"typeName\":\"rupa na putu\",\"createdAt\":\"2020-02-03T08:50:18\",\"description\":\"Problem je u smecu\",\"photoPath\":\"post2\",\"statusId\":1,\"status\":\"reseno\",\"likeNum\":0,\"dislikeNum\":0,\"commNum\":1,\"latitude\":43.981748,\"longitude\":20.90406},{\"postId\":3,\"userId\":8,\"username\":\"jovana_vukicevic\",\"postTypeId\":3,\"typeName\":\"rupa na putu\",\"createdAt\":\"2020-03-29T19:42:52.7033584\",\"description\":\"Rupa na putu. Lajkuj da bi nadlezna sluzba reagovala.\",\"photoPath\":\"9ddca26f-3ebc-4fe1-88a5-5416b426839c6233765055926557122.jpg\",\"statusId\":1,\"status\":\"reseno\",\"likeNum\":0,\"dislikeNum\":0,\"commNum\":0,\"latitude\":37.4219983,\"longitude\":-122.084}]";
  static Iterable list = json.decode(mockdata);
  List<FullPost> listPosts = list.map((model) => FullPost.fromObject(model)).toList();
  //List<FullPost> listPosts;

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