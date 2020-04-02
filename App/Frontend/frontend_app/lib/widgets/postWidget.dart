import 'package:flutter/material.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/models/fullPost.dart';
import 'package:frontend/ui/commentsPage.dart';
import 'package:frontend/ui/likesPage.dart';
import 'package:frontend/widgets/circleImageWidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PostWidget extends StatefulWidget {
  final List<FullPost> listPosts;

  PostWidget(this.listPosts);

  @override
  _PostWidgetState createState() => _PostWidgetState(listPosts);
}

class _PostWidgetState extends State<PostWidget> {
  List<FullPost> listPosts;

  _PostWidgetState(List<FullPost> listPosts1) {
    this.listPosts = listPosts1;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (listPosts == null) ? Center() : newPost(); //buildPostList()
  }

  Widget newPost() {
    return ListView.builder(
        padding: EdgeInsets.only(bottom: 30.0),
        itemCount: listPosts == null ? 0 : listPosts.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                userInfoRow(listPosts[index].username,
                    listPosts[index].typeName, listPosts[index].userPhoto),
                imageGallery(listPosts[index].photoPath),
                SizedBox(height: 2.0),
                actionsButtons(
                    listPosts[index].statusId,
                    listPosts[index].postId,
                    listPosts[index].likeNum,
                    listPosts[index].dislikeNum,
                    listPosts[index].commNum),
                description(
                    listPosts[index].username, listPosts[index].description),
                SizedBox(height: 10.0),
              ]));
        });
  }

  Widget userInfoRow(String username, String category, String userPhoto) => Row(
        children: <Widget>[
          CircleImage(
            "http://10.0.2.2:60676//" + userPhoto,
            imageSize: 36.0,
            whiteMargin: 2.0,
            imageMargin: 6.0,
          ),
          Text(
            username,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: SizedBox()),
          Text(category),
          IconButton(
            icon: Icon(Icons.location_on),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      );

  Widget imageGallery(String image) => Container(
        constraints: BoxConstraints(
          maxHeight: 500.0, // changed to 400
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
        child: Image(image: NetworkImage("http://10.0.2.2:60676//" + image)),
      );

  Widget actionsButtons(
          int statusId, int postId, int likeNum, int dislikeNum, int commNum) =>
      Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Actions buttons/icons
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(MdiIcons.thumbUpOutline, color: Colors.green[800]),
                onPressed: () {
                  APIServices.addLike(postId, 1, 2);
                },
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LikesPage(postId)),
                  );
                },
                child: Text(likeNum.toString()),
              ),
              IconButton(
                icon: Icon(MdiIcons.thumbDownOutline, color: Colors.red),
                onPressed: () {
                  APIServices.addLike(postId, 1, 1);
                },
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LikesPage(postId)),
                  );
                },
                child: Text(dislikeNum.toString()),
              ),
              IconButton(
                icon: Icon(Icons.chat_bubble_outline, color: Colors.green[800]),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CommentsPage(postId)),
                  );
                },
              ),
              Text(commNum.toString()),
              Expanded(child: SizedBox()),
              statusId == 2
                  ? FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(11.0),
                          side: BorderSide(color: Colors.green[800])),
                      color: Colors.green[800],
                      child: Text(
                        "Reši",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {},
                    )
                  : IconButton(
                      icon: Icon(Icons.done_all, color: Colors.green[800]),
                      onPressed: () {
                        
                      },
                    ),
              SizedBox(width: 10.0), // For padding
            ],
          ),
        ],
      );

  Widget description(String username, String description) => Container(
          child: Row(
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          Text(username, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(
            width: 10,
          ),
          Flexible(
            child: Text(description),
          )
        ],
      ));
}
