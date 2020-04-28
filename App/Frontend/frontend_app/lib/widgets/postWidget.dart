import 'dart:io';
import 'package:flutter/material.dart';
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

class PostWidget extends StatefulWidget {
  final FullPost post;

  PostWidget(this.post);

  @override
  _PostWidgetState createState() => _PostWidgetState(post);
}

class _PostWidgetState extends State<PostWidget> {
  FullPost post;
  List<ReportType> reportTypes;
  TextEditingController opisController = new TextEditingController();
  ReportType _selectedId;
  List<DropdownMenuItem<ReportType>> _dropdownMenuItems;

  _PostWidgetState(FullPost post1) {
    this.post = post1;
  }

  getReportTypes() async {
    var jwt = await APIServices.jwtOrEmpty();
    APIServices.getReportType(jwt).then((res) {
      Iterable list = json.decode(res.body);
      List<ReportType> listRepTypes = List<ReportType>();
      listRepTypes = list.map((model) => ReportType.fromObject(model)).toList();
      setState(() {
        reportTypes = listRepTypes;
        _dropdownMenuItems = buildDropDownMenuItems(reportTypes);
        _selectedId = _dropdownMenuItems[0].value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    this.getReportTypes();
  }

  List<DropdownMenuItem<ReportType>> buildDropDownMenuItems(List reports) {
    List<DropdownMenuItem<ReportType>> newReports = List();
    for (ReportType item in reports) {
      newReports.add(DropdownMenuItem(
        value: item,
        child: Text(item.typeName),
      ));
    }

    return newReports;
  }

  @override
  Widget build(BuildContext context) {
    return (post == null) ? Center() : newPost(); //buildPostList()
  }

  Widget newPost() {
    return Card(
        child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          userInfoRow(post.userId, post.username, post.typeName, post.userPhoto,
              post.statusId),
          imageGallery(post.photoPath),
          SizedBox(height: 2.0),
          Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(post.address)
                ],
              )),
          actionsButtons(post.statusId, post.postId, post.likeNum,
              post.dislikeNum, post.commNum, post.isLiked),
          description(post.userId, post.username, post.description),
          SizedBox(height: 10.0),
        ]));
  }

  Widget userInfoRow(int otherUserId, String username, String category,
          String userPhoto, int statusId) =>
      Row(
        children: <Widget>[
          InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OthersProfilePage(otherUserId)),
                );
              },
              child: CircleImage(
                serverURLPhoto + userPhoto,
                imageSize: 36.0,
                whiteMargin: 2.0,
                imageMargin: 6.0,
              )),
          InkWell(
              onTap: () {
                if (userId != otherUserId)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OthersProfilePage(otherUserId)),
                  );
              },
              child: Text(
                username,
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Expanded(child: SizedBox()),
          Text(category),
          (statusId == 2)
              ? IconButton(
                  icon: Icon(Icons.location_on),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MapPage(
                              postLatitude: post.latitude,
                              postLongitude: post.longitude)),
                    );
                  },
                )
              : Center(),
          /*IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {

            },
          ),*/
          (otherUserId != userId)
              ? PopupMenuButton<String>(
                  onSelected: (String choice) {
                    choiceAction(choice, otherUserId);
                  },
                  itemBuilder: (BuildContext context) {
                    return Constants.choices.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                )
              : PopupMenuButton<String>(
                  onSelected: choiceActionDeleteEdit,
                  itemBuilder: (BuildContext context) {
                    return ConstantsDeleteEdit.choices.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
        ],
      );

  //Choice for Report and other things
  void choiceAction(String choice, int _otherUserId) {
    if (choice == Constants.PrijaviKorisnika) {
      showDialog(
          context: context,
          child: new MyDialog(
            onValueChange: _onValueChange,
            initialValue: _selectedId,
            reportTypes: _dropdownMenuItems,
            otherUserId: _otherUserId,
          ));
    }
    else if(choice == Constants.PogledajResenja){
      Navigator.push(
        context,
        MaterialPageRoute( builder: (context) => ChallengeSolvingPage(post.postId, post.userId, post.statusId)),
      );
    }

  }

  void _onValueChange(ReportType value) {
    setState(() {
      _selectedId = value;
    });
  }

  //Choice for Delete and Edit
  void choiceActionDeleteEdit(String choice) {
    if (choice == ConstantsDeleteEdit.IzbrisiObjavu) {
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text("Brisanje objave?", style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color),),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Izbrisi",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  APIServices.jwtOrEmpty().then((res) {
                    String jwt;
                    setState(() {
                      jwt = res;
                    });
                    if (res != null) {
                      APIServices.deletePost(jwt, post.postId);
                      setState(() {
                        post = null;
                      });
                    }
                  });
                  print('Uspesno ste izbrisali objavu.');
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  "Otkaži",
                  style: TextStyle(color: Colors.green[800]),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ));
    } else if (choice == ConstantsDeleteEdit.IzmeniObjavu) {
      opisController.text = post.description;
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text("Izmeni opis.", textAlign: TextAlign.center,style: TextStyle(
              color: Theme.of(context).textTheme.bodyText1.color),),
            content: Container(
              height: 50.0,
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: opisController,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Sačuvaj",
                  style: TextStyle(color: Colors.green[800]),
                ),
                onPressed: () {
                  APIServices.jwtOrEmpty().then((res) {
                    String jwt;
                    setState(() {
                      jwt = res;
                    });
                    if (res != null) {
                      APIServices.editPost(
                          jwt, post.postId, opisController.text);
                      setState(() {
                        post.description = opisController.text;
                      });
                    }
                  });
                  print('Uspesno ste izmenili objavu.');
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  "Otkaži",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ));
    }else if(choice == ConstantsDeleteEdit.PogledajResenja){
      Navigator.push(
        context,
        MaterialPageRoute( builder: (context) => ChallengeSolvingPage(post.postId, post.userId, post.statusId)),
      );
    }
  }

  Widget imageGallery(String image) => Container(
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
        child: Image(image: NetworkImage(serverURLPhoto + image)),
      );

  Widget actionsButtons(int statusId, int postId, int likeNum, int dislikeNum,
          int commNum, int isLiked) =>
      Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Actions buttons/icons
          Row(
            children: <Widget>[
              IconButton(
                icon: isLiked == 1
                    ? Icon(MdiIcons.thumbUpOutline, color: Colors.green[800])
                    : Icon(MdiIcons.thumbUpOutline, color: Colors.grey),
                onPressed: () {
                  APIServices.jwtOrEmpty().then((res) {
                    String jwt;
                    setState(() {
                      jwt = res;
                    });
                    if (res != null) {
                      APIServices.addLike(jwt, postId, userId, 2).then((res) {
                        Map<String, dynamic> list = json.decode(res);
                        LikeViewModel likeVM = LikeViewModel();
                        likeVM = LikeViewModel.fromObject(list);
                        setState(() {
                          post.likeNum = likeVM.likeNum;
                          post.dislikeNum = likeVM.dislikeNum;
                          post.commNum = likeVM.commNum;
                          post.isLiked = likeVM.isLiked;
                        });
                      });
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
                icon: isLiked == 2
                    ? Icon(MdiIcons.thumbDownOutline, color: Colors.red)
                    : Icon(MdiIcons.thumbDownOutline, color: Colors.grey),
                onPressed: () {
                  APIServices.jwtOrEmpty().then((res) {
                    String jwt;
                    setState(() {
                      jwt = res;
                    });
                    if (res != null) {
                      APIServices.addLike(jwt, postId, userId, 1).then((res) {
                        Map<String, dynamic> list = json.decode(res);
                        LikeViewModel likeVM = LikeViewModel();
                        likeVM = LikeViewModel.fromObject(list);
                        setState(() {
                          post.likeNum = likeVM.likeNum;
                          post.dislikeNum = likeVM.dislikeNum;
                          post.commNum = likeVM.commNum;
                          post.isLiked = likeVM.isLiked;
                        });
                      });
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
                  _getCommentsFromPage(postId);
                },
              ),
              Text(commNum.toString()),
              Expanded(child: SizedBox()),
              statusId == 2 && post.postTypeId != 1
                  ? FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(11.0),
                          side: BorderSide(color: Colors.green[800])),
                      color: Colors.green[800],
                      child: Text(
                        "Reši",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute( builder: (context) => ChallengeSolvingPage(post.postId, post.userId, post.statusId)),
                        );
                      },
                    )
                  : IconButton(
                      icon: Icon(Icons.done_all, color: Colors.green[800]),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute( builder: (context) => ChallengeSolvingPage(post.postId, post.userId, post.statusId)),
                        );
                      },
                    ),
              SizedBox(width: 10.0), // For padding
            ],
          ),
        ],
      );

  _getCommentsFromPage(int postId) async {
    int result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CommentsPage(postId)),
    );

    setState(() {
      if (result != null) post.commNum = result;
    });
  }

  Widget description(
    int otherUserId,
    String username,
    String description,
  ) =>
      Container(
          child: Row(
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          InkWell(
              onTap: () {
                if (userId != otherUserId)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OthersProfilePage(otherUserId)),
                  );
              },
              child: Text(username,
                  style: TextStyle(fontWeight: FontWeight.bold))),
          SizedBox(
            width: 10,
          ),
          Flexible(
            child: Text(description),
          )
        ],
      ));
}

class MyDialog extends StatefulWidget {
  const MyDialog(
      {this.onValueChange,
      this.initialValue,
      this.reportTypes,
      this.otherUserId});

  final ReportType initialValue;
  final int otherUserId;
  final void Function(ReportType) onValueChange;
  final List<DropdownMenuItem<ReportType>> reportTypes;

  @override
  State createState() => new MyDialogState();
}

class MyDialogState extends State<MyDialog> {
  ReportType _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.initialValue;
  }

  Widget build(BuildContext context) {
    TextEditingController messageController = new TextEditingController();
    return new AlertDialog(
      title: Text(
        "Prijavljivanje korisnika",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyText1.color),
      ),
      content: Container(
        height: 150,
        child: Column(children: <Widget>[
          new DropdownButton<ReportType>(
            isExpanded: true,
            value: _selectedId,
            onChanged: (ReportType value) {
              setState(() {
                _selectedId = value;
              });
              widget.onValueChange(value);
            },
            items: widget.reportTypes,
          ),
          TextFormField(
            maxLines: 2,
            controller: messageController,
            decoration: InputDecoration(
                labelText: "Komentar",
                hoverColor: Colors.grey,
                labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyText1.color)   ),
          )
        ])),
      actions: <Widget>[
        FlatButton(
          child: Text(
            "Prijavi",
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
          ),
          onPressed: () {
            APIServices.jwtOrEmpty().then((res) {
              String jwt;
              setState(() {
                jwt = res;
              });
              if (res != null) {
                print(userId.toString() + " " + widget.otherUserId.toString());
                print(messageController.text);
                APIServices.addReport(jwt, userId, widget.otherUserId,
                        _selectedId.id, messageController.text)
                    .then((res) {
                  
                });
                Navigator.of(context).pop();
              }
            });
          },
        ),
        FlatButton(
          child: Text(
            "Otkaži",
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
