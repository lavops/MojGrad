import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/models/reportType.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/models/fullPost.dart';
import 'package:frontend/ui/commentsPage.dart';
import 'package:frontend/ui/homePage.dart';
import 'package:frontend/ui/likesPage.dart';
import 'package:frontend/widgets/circleImageWidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:frontend/models/constants.dart';
import 'dart:convert';
import '../services/api.services.dart';
import '../services/api.services.dart';

class PostWidget extends StatefulWidget {
  final List<FullPost> listPosts;

  PostWidget(this.listPosts);

  @override
  _PostWidgetState createState() => _PostWidgetState(listPosts);
}

class _PostWidgetState extends State<PostWidget> {
  List<FullPost> listPosts;
  List<ReportType> reportTypes;

  ReportType _selectedId;
  List<DropdownMenuItem<ReportType>> _dropdownMenuItems;

  _PostWidgetState(List<FullPost> listPosts1) {
    this.listPosts = listPosts1;
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
            serverURLPhoto + userPhoto,
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
          /*IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {

            },
          ),*/
          PopupMenuButton<String> (
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return Constants.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );      
              }).toList();
            },
          )
        ],
      );

     void choiceAction(String choice)
      {
        if(choice == Constants.PrijaviKorisnika)
        {
           showDialog(
                context: context,
                child: new MyDialog(
                  onValueChange: _onValueChange,
                  initialValue: _selectedId,
                  reportTypes: _dropdownMenuItems,
                ));//potrebno je poslati odredjeni context, da bi se cuvalo koji je report selektovan u alert dialogu..
        }
      }

      void _onValueChange(ReportType value) {
    setState(() {
      _selectedId = value;
    });
    }

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

class MyDialog extends StatefulWidget {
  const MyDialog({this.onValueChange, this.initialValue, this.reportTypes});

  final ReportType initialValue;
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
    return new AlertDialog(
      title: Text("Prijavljivanje korisnika"),
      content: 
        new Container(
            padding: const EdgeInsets.all(10.0),
            child: new DropdownButton<ReportType>(
              value: _selectedId,
              onChanged: (ReportType value) {
                setState(() {
                  _selectedId = value;
                });
                widget.onValueChange(value);
              },
              items: widget.reportTypes,
            )),
      actions: <Widget>[
        FlatButton(
          child: Text(
            "Prijavi",
            style: TextStyle(color: Colors.green),
          ),
          
          onPressed: () {
            //var res = await APIServices.addReport(userId, reportedUserId, _selectedReport.id)  - userId, reportedUserId poslati..
            print('Uspesno ste prijavili korisnika.');
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
        child: Text(
          "Otkazi",
          style: TextStyle(color: Colors.green),
        ),
         onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],      
    );
  }
  
}
