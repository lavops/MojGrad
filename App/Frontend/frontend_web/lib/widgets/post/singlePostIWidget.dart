import 'package:flutter/material.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/models/fullPost.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/adminPages/managePost/managePostPage.dart';
import 'package:frontend_web/widgets/circleImageWidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:frontend_web/extensions/hoverExtension.dart';

Color greenPastel = Color(0xFF00BFA6);

class SinglePostIWidget extends StatefulWidget {
  FullPost posts;

  SinglePostIWidget(this.posts);

  @override
  _SinglePostIWidgetState createState() => _SinglePostIWidgetState(posts);
}

class _SinglePostIWidgetState extends State<SinglePostIWidget> {
  FullPost post;

  _SinglePostIWidgetState(FullPost post1) {
    this.post = post1;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (post == null) ? Center() : newPost(); //buildPostList()
  }

  showAlertDialog(BuildContext context, int id) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("Da", style: TextStyle(color: greenPastel),),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ManagePostPage()),
        );
      },
    ).showCursorOnHover;
    Widget notButton = FlatButton(
      child: Text("Otkaži", style: TextStyle(color: greenPastel),),
      onPressed: () {
        Navigator.pop(context);
      },
    ).showCursorOnHover;

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Reši"),
      content: Text("Da li ste sigurni da želite da rešite objavu?"),
      actions: [
        okButton,
        notButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget newPost() {

    return Card(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              userInfoRow(post.username,
                  post.typeName, post.userPhoto, post.postId, post.statusId),
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
              SizedBox(height: 6.0),
            ]
        )
    );
  }

  Widget userInfoRow(String username, String category, String userPhoto, int postId, int statusId) => Row(
    children: <Widget>[
      CircleImage(
        userPhotoURL + userPhoto,
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
      SizedBox(width: 15,),
      statusId == 2 ?
      FlatButton(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(11.0),
            side: BorderSide(color: Colors.redAccent)),
        color: Colors.redAccent,
        child: Text(
          "Reši",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          showAlertDialog(context, postId);
        },
      ) : IconButton(
        icon: Icon(Icons.done_all, color: greenPastel),
        onPressed: () {},
      ),
      SizedBox(width: 15,)
    ],
  );

  Widget imageGallery(String image) => Container(
    constraints: BoxConstraints(
      maxHeight: 400.0, // changed to 400
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
    child: Image(image: NetworkImage(userPhotoURL + image)),
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
                icon: Icon(MdiIcons.thumbUpOutline, color: greenPastel),
                onPressed: () {
                  APIServices.addLike(TokenSession.getToken,postId, 1, 2);
                },
              ),
              GestureDetector(
                onTap: () {},
                child: Text(likeNum.toString()),
              ),
              IconButton(
                icon: Icon(MdiIcons.thumbDownOutline, color: Colors.red),
                onPressed: () {
                  APIServices.addLike(TokenSession.getToken,postId, 1, 1);
                },
              ),
              GestureDetector(
                onTap: () {},
                child: Text(dislikeNum.toString()),
              ),
              IconButton(
                icon: Icon(Icons.chat_bubble_outline, color: greenPastel),
                onPressed: () {
                },
              ),
              Text(commNum.toString()),
              Expanded(child: SizedBox()),
              statusId == 2
                  ? FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(11.0),
                    side: BorderSide(color: greenPastel)),
                color: greenPastel,
                child: Text(
                  "Nije rešeno",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {},
              ).showCursorOnHover
                  : IconButton(
                icon: Icon(Icons.done_all, color: greenPastel),
                onPressed: () {},
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
