import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_web/models/user.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/ui/managementPage.dart';
import 'dart:convert';

import 'package:frontend_web/widgets/circleImageWidget.dart';

class UsersProfilePage extends StatefulWidget {
  @override
  _UsersProfilePageState createState() => new _UsersProfilePageState();
}

class _UsersProfilePageState extends State<UsersProfilePage> {
  List<User> listUsers;
  TextEditingController searchController = new TextEditingController();

  _getUsers() {
    APIServices.getUsers().then((res) {
      Iterable list = json.decode(res.body);
      List<User> listU = List<User>();
      listU = list.map((model) => User.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          listUsers = listU;
        });
      }
    });
  }

  showAlertDialog(BuildContext context, int id) {
      // set up the button
    Widget okButton = FlatButton(
      child: Text("Obriši", style: TextStyle(color: Colors.green),),
      onPressed: () {
        APIServices.deleteUser(id);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UsersProfilePage()),
        );
        },
    );
     Widget notButton = FlatButton(
      child: Text("Otkaži", style: TextStyle(color: Colors.green),),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UsersProfilePage()),
        );
        },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Brisanje korisnika"),
      content: Text("Da li ste sigurni da želite da obrišete korisnika?"),
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

  Widget buildUserList() {
     _getUsers();
    return ListView.builder(
      itemCount: listUsers == null ? 0 : listUsers.length,
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
                      userPhotoURL + listUsers[index].photo,
                      imageSize: 56.0,
                      whiteMargin: 2.0,
                      imageMargin: 6.0,
                    ),
                    Container(
                      width: 180,
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(listUsers[index].username,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                              listUsers[index].firstName +
                                  " " +
                                  listUsers[index].lastName,
                              style: TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 15))
                        ],
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          listUsers[index].postsNum.toString(),
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          'Broj objava',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                    Column(
                      children: <Widget>[
                        Text(
                          listUsers[index].points.toString(),
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          'Broj poena',
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                    SizedBox(width: 10),
                    Column(
                      children: <Widget>[
                        Text(
                          listUsers[index].level.toString(),
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          'Nivo',
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                    Expanded(child: SizedBox()),
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(11.0),
                          side: BorderSide(color: Colors.green[800])),
                      color: Colors.green[800],
                      child: Text(
                        "Poseti profil",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {},
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(11.0),
                          side: BorderSide(color: Colors.redAccent)),
                      color: Colors.redAccent,
                      child: Text(
                        "Obriši korisnika",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        showAlertDialog(context, listUsers[index].id);
                      },
                    )
                  ])),
            ],
          ),
        ));
      },
    );
  }

  void initState() {
    super.initState();
    _getUsers();
  }

  Widget search() {
    return Container(
      margin: EdgeInsets.only(left: 100, right: 100, top:5, bottom: 5),
      padding: const EdgeInsets.all(8.0),
      child: TextField(
      autofocus: false,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search,color: Colors.green[800]),
        hintText: 'Pretraži...',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide(width: 2,color: Colors.green[800]),
        ),
      ),
      controller: searchController,
    )
    );
  }

  Widget tabs() {
    return TabBar(
        labelColor: Colors.green,
        indicatorColor: Colors.green,
        unselectedLabelColor: Colors.black,
        tabs: <Widget>[
          Tab(
            child: Text("Svi korisnici"),
          ),
          Tab(
            child: Text("Prijavljeni korisnici"),
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              title: Text('Upravljanje korisnicima',
                  style: TextStyle(color: Colors.black)),
              backgroundColor: Colors.white,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ManagementPage()));
                  }),
              bottom: tabs(),
            ),
            body: TabBarView(children: <Widget>[
              Container(
                margin: EdgeInsets.only(left:80, right: 80),
                  padding: EdgeInsets.only(top: 0),
                  color: Colors.grey[100],
                  child: Column(children: [
                    search(),
                    Flexible(child: buildUserList()),
                  ])),
              Container(
                  padding: EdgeInsets.only(top: 0),
                  color: Colors.grey[100],
                  child: Column(children: [
                    search(),
                    Center(child: Text("Trenutno nema prijavljenih korisnika")),
                    //TODO repotredUsers
                  ])),
            ])));
  }
}
