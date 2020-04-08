import 'package:flutter/material.dart';
import 'package:frontend/models/fullPost.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/ui/commentsPage.dart';
import 'package:frontend/ui/homePage.dart';
import 'package:frontend/ui/likesPage.dart';
import 'package:frontend/widgets/circleImageWidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SinglePostWidget extends StatefulWidget {
  FullPost post;

  SinglePostWidget(this.post);

  @override
  _SinglePostWidgetState createState() => _SinglePostWidgetState(post);
}


class _SinglePostWidgetState extends State<SinglePostWidget> {

  FullPost post;
  _SinglePostWidgetState(FullPost post1){
    this.post = post1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              userInfoRow(post.userId, post.username,
                    post.typeName, post.userPhoto),
                imageGallery(post.photoPath),
                SizedBox(height: 2.0),
                actionsButtons(
                    post.statusId,
                    post.postId,
                    post.likeNum,
                    post.dislikeNum,
                    post.commNum),
                description(
                    post.username, post.description),
                SizedBox(height: 10.0),
            ]
          )
        );
  }
  Widget userInfoRow(int userId, String username, String category, String userPhoto) => Row(
        children: <Widget>[
          CircleImage(
            serverURLPhoto + userPhoto,
            imageSize: 36.0,
            whiteMargin: 2.0,
            imageMargin: 6.0,
            othersUserId: userId,
          ),
          Text(
            username,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: SizedBox()),
          Text(category),
          IconButton(
            icon: Icon(Icons.location_on),
            onPressed: () {
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {

            },
          ),
          
        ],
      );

  Widget imageGallery(String image) => Container(
        constraints: BoxConstraints(
          maxHeight: 400.0,
          minHeight: 200.0,
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
        child: Image(image: NetworkImage(serverURLPhoto + image)),
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
                    APIServices.jwtOrEmpty().then((res) {
                      String jwt;
                      setState(() {
                        jwt = res;
                      });
                      if (res != null) {
                       APIServices.addLike(jwt,postId, userId, 2);
                      }
                    });
                  
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
                   APIServices.jwtOrEmpty().then((res) {
                      String jwt;
                      setState(() {
                        jwt = res;
                      });
                      if (res != null) {
                        APIServices.addLike(jwt,postId, userId, 1);
                      }
                    });
                 
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
