import 'package:flutter/material.dart';
import 'package:frontend/models/comment.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/widgets/circleImageWidget.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

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
  StateComents(int id) {
    postId = id;
  }
  List<Comment> listComents;
  getComms() {
    APIServices.getComments(postId).then((res) {
      //umesto 1 stavlja se idPosta
      Iterable list = json.decode(res.body);
      List<Comment> listComms = List<Comment>();
      listComms = list.map((model) => Comment.fromObject(model)).toList();
      setState(() {
        listComents = listComms;
      });
    });
  }

  TextEditingController myController = new TextEditingController();
  Widget buildCommentList() {
    getComms();
    return ListView.builder(
      itemCount: listComents == null ? 0 : listComents.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
            child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(top: 5),
                  child: Row(children: [
                    CircleImage(
                      "http://10.0.2.2:60676//" + listComents[index].photoPath,
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
                              style: TextStyle( fontStyle: FontStyle.italic, fontSize: 15))
                        ],
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    IconButton(
                              icon: Icon(Icons.more_vert),
                              onPressed: () {},
                            ),
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
      ),
      body: Container(
          padding: EdgeInsets.only(top: 0),
          color: Colors.grey[100],
          child: Column(children: [
            Flexible(child: buildCommentList()),
            Row(
              children: <Widget>[
                SizedBox(width:10),
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
                    APIServices.addComment(myController.text, 1,
                        postId); // this username - korisnik koji je prokomentarisao post, 1 primer - id posta
                    setState(() {
                      myController.text = '';
                    });
                  },
                ),
                SizedBox(width:10),
              ],
            )
          ])),
    );
  }
}
