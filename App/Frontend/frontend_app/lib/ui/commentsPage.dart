import 'package:flutter/material.dart';
import 'package:frontend/models/comment.dart';
import 'package:frontend/models/constants.dart';
import 'package:frontend/models/constantsDeleteEdit.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/widgets/circleImageWidget.dart';
import 'dart:convert';

import 'homePage.dart';

class CommentsPage extends StatefulWidget {
  final int postId;
  CommentsPage(this.postId);

  @override
  State<StatefulWidget> createState() {
    return StateComents(postId);
  }
}

class StateComents extends State<CommentsPage> {
  int postId;
  Comment comment;
  StateComents(int id) {
    postId = id;
  }

  List<Comment> listComents;
  _getComms() async {
    var jwt = await APIServices.jwtOrEmpty();
    APIServices.getComments(jwt, postId).then((res) {
      //umesto 1 stavlja se idPosta
      Iterable list = json.decode(res.body);
      List<Comment> listComms = List<Comment>();
      listComms = list.map((model) => Comment.fromObject(model)).toList();
      setState(() {
        listComents = listComms;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getComms();
  }
    void choiceActionDelete(String choice)
  {
    if(choice == ConstantsCommentDelete.ObrisiKomentar)
    {
        showDialog(
          context: context,
          child: AlertDialog(
            title: Text("Brisanje komentara?"),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Izbriši",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  APIServices.jwtOrEmpty().then((res) {
                    String jwt;
                    setState(() {
                      jwt = res;
                    });
                    if (res != null) {
                      print("Delete comment"+ comment.id.toString());
                      APIServices.deleteComment(jwt, comment.id);
                      setState(() {
                        _getComms();
                      });
                    }
                  });
                  _getComms();
                  print('Uspesno ste izbrisali objavu.');
                  Navigator.of(context).pop();
                  _getComms();
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
          )
        );
    }
    
  }
   void choiceAction(String choice)
  {
    if(choice == ConstantsComment.PrijaviKomentar)
    {
        showDialog(
          context: context,
          child: AlertDialog(
            title: Text("Želiš da prijaviš komentar?"),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Prijavi",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  APIServices.jwtOrEmpty().then((res) {
                    String jwt;
                    setState(() {
                      jwt = res;
                    });
                    if (res != null) {
                      print("Report comment"+ comment.id.toString());
                      APIServices.addReportComment(jwt, comment.id, userId);
                      setState(() {
                        _getComms();
                      });
                    }
                  });
                  print('Uspesno ste prijavili komentar.');
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
          )
        );
    }
    
  }

  TextEditingController myController = new TextEditingController();
  Widget buildCommentList() {
    return ListView.builder(
      itemCount: listComents == null ? 0 : listComents.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
            child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(top: 5),
                  child: Row(children: [
                    CircleImage(
                      serverURLPhoto + listComents[index].photoPath,
                      imageSize: 56.0,
                      whiteMargin: 2.0,
                      imageMargin: 6.0,
                    ),
                    Container(
                      width: 260,
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Text(listComents[index].username,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Expanded(child: SizedBox()),
                          ]),
                          Text(listComents[index].description,
                              style: TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 15))
                        ],
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Flexible(
                     child: /*IconButton(
                        icon: Icon(Icons.more_vert),
                        onPressed: () {

                        },
                      ),*/
                        (listComents[index].userId != userId)?
                      PopupMenuButton<String> (
                        onSelected: choiceAction,
                        itemBuilder: (BuildContext context) {
                          setState(() {
                            comment = listComents[index];
                          });
                          return ConstantsComment.choices.map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            );      
                          }).toList();
                        },
                      ):
                      PopupMenuButton<String> (
                        onSelected: choiceActionDelete,
                        itemBuilder: (BuildContext context) {
                          setState(() {
                            comment = listComents[index];
                          });
                          return ConstantsCommentDelete.choices.map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            );      
                          }).toList();
                        },
          ),
                    )
                  ])),
            ],
          ),
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Komentari', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context, listComents.length);
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
          padding: EdgeInsets.only(top: 0),
          color: Colors.grey[100],
          child: Column(children: [
            Flexible(child: buildCommentList()),
            Row(
              children: <Widget>[
                SizedBox(width: 10),
                Icon(
                  Icons.account_circle,
                  size: 36,
                ),
                Flexible(
                  child: TextFormField(
                    controller: myController,
                    decoration: InputDecoration(
                      hoverColor: Colors.grey,
                      labelText: 'Dodaj komentar...',
                      labelStyle: TextStyle(
                          color: Colors.black87, fontStyle: FontStyle.italic),
                      fillColor: Colors.black,
                      contentPadding: const EdgeInsets.all(10.0),
                    ),
                  ),
                ), //COMMENT INPUT
                RaisedButton(
                  //splashColor: Colors.black,
                  elevation: 7,
                  padding: const EdgeInsets.all(10.0),
                  color: Colors.green,
                  child: Text(
                    'Komentariši',
                    style: TextStyle(color: Colors.white),
                  ),
                  //post comment
                  onPressed: () {
                    APIServices.jwtOrEmpty().then((res) {
                      String jwt;
                      setState(() {
                        jwt = res;
                      });
                      if (res != null) {
                        print(myController.text);
                        APIServices.addComment(jwt, myController.text, 1, postId).then((res){
                          
                          setState(() {
                            _getComms();
                            myController.text = "";
                          });
                        });
                      }
                    });
                    _getComms();
                  },
                ),
                SizedBox(width: 10),
              ],
            )
          ])),
    );
  }
}
