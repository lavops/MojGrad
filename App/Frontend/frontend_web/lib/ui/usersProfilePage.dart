import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_web/models/city.dart';
import 'package:frontend_web/models/user.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/managementPage.dart';
import 'package:frontend_web/ui/reportedUserDetailsPage.dart';
import 'dart:convert';

import 'package:frontend_web/widgets/circleImageWidget.dart';

class UsersProfilePage extends StatefulWidget {
  @override
  _UsersProfilePageState createState() => new _UsersProfilePageState();
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;
 
  Debouncer({this.milliseconds});
 
  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class _UsersProfilePageState extends State<UsersProfilePage> {
  List<User> listUsers;
  List<User> listRepUsers;
  List<City> listCities;
  TextEditingController searchController = new TextEditingController();
  TextEditingController searchRepController = new TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);
  List<User> filteredUsers;
  List<User> filteredRepUsers;

  _getUsers() {
    APIServices.getUsers(TokenSession.getToken).then((res) {
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

  _getReportedUsers() {
    APIServices.getReportedUsers(TokenSession.getToken).then((res) {
      Iterable list = json.decode(res.body);
      List<User> listU = List<User>();
      listU = list.map((model) => User.fromObject(model)).toList();
      if (mounted) {
        setState( () {
          listRepUsers = listU;
        });
      }
    });
  }
  
  _getCities() {
    APIServices.getCity(TokenSession.getToken).then((res) {
      Iterable list = json.decode(res.body);
      List<City> listC = List<City>();
      listC = list.map((model) => City.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          listCities = listC;
          City allusers = new City(9999, "Svi korisnici");
          listCities.add(allusers);
        });
      }
    });
  }

  _getUsersFromCity(int cityId) {
    APIServices.getUsersFromCity(TokenSession.getToken, cityId).then((res) {
      Iterable list = json.decode(res.body);
      List<User> listFU = List<User>();
      listFU = list.map((model) => User.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          filteredUsers = listFU;
        });
      }
    });
  }

 _getReportedUsersFromCity(int cityId) {
    APIServices.getReportedUsersFromCity(TokenSession.getToken, cityId).then((res) {
      Iterable list = json.decode(res.body);
      List<User> listFRU = List<User>();
      listFRU = list.map((model) => User.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          filteredRepUsers = listFRU;
        });
      }
    });
  }

  void initState() {
    super.initState();
    _getUsers(); 
    _getReportedUsers();
    _getCities();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }


  showAlertDialog(BuildContext context, int id) {
      // set up the button
    Widget okButton = FlatButton(
      child: Text("Obriši", style: TextStyle(color: Colors.green),),
      onPressed: () {
        APIServices.deleteUser(TokenSession.getToken,id);
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

  Widget buildUserList(List<User> listUsers) {
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

  Widget buildReportedUserList(List<User> listRepUsers) {

    return ListView.builder(
      itemCount: listRepUsers == null ? 0 : listRepUsers.length,
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
                          userPhotoURL + listRepUsers[index].photo,
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
                              Text(listRepUsers[index].username,
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                  listRepUsers[index].firstName +
                                      " " +
                                      listRepUsers[index].lastName,
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic, fontSize: 15))
                            ],
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              listRepUsers[index].postsNum.toString(),
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
                              listRepUsers[index].points.toString(),
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
                              listRepUsers[index].level.toString(),
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              'Nivo',
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                          ),  SizedBox(width: 10),
                        Container(
                          margin:const
                          EdgeInsets.all(10.0),
                          padding: const
                          EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: Colors.red,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: <Widget>[
                              Text(
                                listRepUsers[index].reportsNum.toString(),
                                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Broj prijava',
                                style: TextStyle(color: Colors.red),
                              )
                            ],
                          ),
                        ),
                        Expanded(child: SizedBox()),
						FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(11.0),
                              side: BorderSide(color: Colors.grey)),
                          color: Colors.grey,
                          child: Text(
                            "Detalji prijave",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ReportedUserDetailsPage(id:listRepUsers[index].id, firstName: listRepUsers[index].firstName, lastName: listRepUsers[index].lastName,)),
                            );
                          },
                        ),
                        SizedBox(
                          width: 20,
                        ),
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
                            showAlertDialog(context, listRepUsers[index].id);
                          },
                        )
                      ])),
                ],
              ),
            ));
      },
    );
  }

  Widget search() {
    return Container(
      margin: EdgeInsets.only(left: 100, right: 50, top:5, bottom: 5),
      width:550,
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (string) {
          _debouncer.run(() { 
            setState(() {
              filteredUsers = listUsers.where((u) => (u.username.contains(string) 
                || ((u.firstName.toString()+" "+u.lastName.toString()).contains(string)))).toList();
            });
          });
        },
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

   City city;


Widget dropdownFU(List<City> listCities) {
        return new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
          margin: EdgeInsets.only(left: 50, right: 10, top:10, bottom: 10),
          ),  
          new Text("Izaberite grad korisnika: ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          new Container(
            padding: new EdgeInsets.all(20.0),
          ),  
          listCities != null
              ? new DropdownButton<City>(
                  hint: Text("Izaberi"),
                  value: city,
                  onChanged: (City newValue) {
                    if (newValue.name == "Svi korisnici") {
                      filteredUsers = null;
                    } 
                    else {
                       _getUsersFromCity(newValue.id);
                    }                          
                    setState(() {
                      city = newValue;               
                    });
                  },
                  items: listCities.map((City option) {
                    return DropdownMenuItem(
                      child: new Text(option.name),
                      value: option,
                    );
                  }).toList(),
                )
              : new DropdownButton<String>(
                  hint: Text("Izaberi"),
                  onChanged: null,
                  items: null,
                ),
        ]);
}

Widget dropdownFRU(List<City> listCities) {
        return new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
          margin: EdgeInsets.only(left: 50, right: 10, top:10, bottom: 10),
          ),  
          new Text("Izaberite grad korisnika: ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          new Container(
            padding: new EdgeInsets.all(20.0),
          ),  
          listCities != null
              ? new DropdownButton<City>(
                  hint: Text("Izaberi"),
                  value: city,
                  onChanged: (City newValue) {
                  if (newValue.name == "Svi korisnici") {
                      filteredRepUsers = null;
                    } 
                    else {
                       _getReportedUsersFromCity(newValue.id);
                    }                    
                      setState(() {
                      city = newValue;               
                    });
                  },
                  items: listCities.map((City option) {
                    return DropdownMenuItem(
                      child: new Text(option.name),
                      value: option,
                    );
                  }).toList(),
                )
              : new DropdownButton<String>(
                  hint: Text("Izaberi"),
                  onChanged: null,
                  items: null,
                ),
        ]);
}

  Widget searchRep() {
    return Container(
      margin: EdgeInsets.only(left: 100, right: 50, top:5, bottom: 5),
      width: 550,
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (string) {
          _debouncer.run(() { 
            setState(() {
              filteredRepUsers = listRepUsers.where((u) => (u.username.contains(string) 
                || ((u.firstName.toString()+" "+u.lastName.toString()).contains(string)))).toList();
            });
          });
        },
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
        controller: searchRepController,
      )
    );
  }

  Widget tabs() {
    return TabBar(
        //onTap
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
                    new Row(children:[
                      dropdownFU(listCities),                 
                      search(),],),
                    Flexible(child: filteredUsers==null ?  buildUserList(listUsers) : buildUserList(filteredUsers)),
                  ])),
              Container(
                  margin: EdgeInsets.only(left:80, right: 80),
                  padding: EdgeInsets.only(top: 0),
                  color: Colors.grey[100],
                  child: Column(children: [
                    new Row(children:[
                    dropdownFRU(listCities),                 
                    searchRep(),],),
                    Flexible(child: filteredRepUsers==null ? buildReportedUserList(listRepUsers) : buildReportedUserList(filteredRepUsers)),
                  ])),
            ])));
  }}
