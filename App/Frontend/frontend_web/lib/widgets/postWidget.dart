import 'package:flutter/material.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/models/fullPost.dart';
import 'package:frontend_web/ui/homePage.dart';
import 'package:frontend_web/ui/postPage.dart';
import 'package:frontend_web/widgets/circleImageWidget.dart';
import 'package:frontend_web/widgets/commentsWidget.dart';
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

  showAlertDialog(BuildContext context, int id) {
      // set up the button
    Widget okButton = FlatButton(
      child: Text("Obriši", style: TextStyle(color: Colors.green),),
      onPressed: () {
        APIServices.deletePost(id);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PostPage(globalUser)),
        );
        },
    );
     Widget notButton = FlatButton(
      child: Text("Otkaži", style: TextStyle(color: Colors.green),),
      onPressed: () {
          Navigator.pop(context);
        },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Brisanje objave"),
      content: Text("Da li ste sigurni da želite da obrišete objavu?"),
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
                    listPosts[index].typeName, listPosts[index].userPhoto, listPosts[index].postId),
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
                CommentsWidget(listPosts[index].postId),
              ]));
        });
  }

  Widget userInfoRow(String username, String category, String userPhoto, int postId) => Row(
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
          FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(11.0),
                side: BorderSide(color: Colors.redAccent)),
            color: Colors.redAccent,
            child: Text(
              "Obriši objavu",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              showAlertDialog(context, postId);
            },
          ),
          SizedBox(width: 15,)
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
                icon: Icon(MdiIcons.thumbUpOutline, color: Colors.green[800]),
                onPressed: () {
                  APIServices.addLike(postId, 1, 2);
                },
              ),
              GestureDetector(
                onTap: () {},
                child: Text(likeNum.toString()),
              ),
              IconButton(
                icon: Icon(MdiIcons.thumbDownOutline, color: Colors.red),
                onPressed: () {
                  APIServices.addLike(postId, 1, 1);
                },
              ),
              GestureDetector(
                onTap: () {},
                child: Text(dislikeNum.toString()),
              ),
              IconButton(
                icon: Icon(Icons.chat_bubble_outline, color: Colors.green[800]),
                onPressed: () {},
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
