import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_web/models/city.dart';
import 'package:frontend_web/models/constants.dart';
import 'package:frontend_web/models/user.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/adminPages/manageUser/viewProfile/viewProfilePage.dart';
import 'package:frontend_web/ui/reportedUserDetailsPage.dart';
import 'package:frontend_web/widgets/centeredView/centeredViewManageUser.dart';
import 'package:frontend_web/widgets/circleImageWidget.dart';

Color greenPastel = Color(0xFF00BFA6);

class ManageUserMobile extends StatefulWidget {
  @override
  _ManageUserMobileState createState() => _ManageUserMobileState();
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

class _ManageUserMobileState extends State<ManageUserMobile> with SingleTickerProviderStateMixin{

List<User> listUsers;
  List<User> listRepUsers;
  List<City> listCities;
  TextEditingController searchController = new TextEditingController();
  TextEditingController searchRepController = new TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);
  List<User> filteredUsers;
  List<User> filteredRepUsers;
  Animation<double> animation;
  AnimationController animationController;

  List<CategoryDropDown> categories = CategoryDropDown.getCategoriesDropDown();
  CategoryDropDown catF;
  List<MaxMinDropDown> maxMinFilter = MaxMinDropDown.getMaxMinDropDown();
  MaxMinDropDown maxMinF;

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

  _sortListBy(){
    if(filteredUsers == null){
      if(catF.name == "Id"){
        if(maxMinF == null || maxMinF.name == "Rastući")
          listUsers.sort((x, y) => x.id.compareTo(y.id));
        else if(maxMinF.name == "Opadajući")
          listUsers.sort((x, y) => y.id.compareTo(x.id));
      } else if(catF.name == "Objave"){
        if(maxMinF == null || maxMinF.name == "Rastući")
          listUsers.sort((x, y) => x.postsNum.compareTo(y.postsNum));
        else if(maxMinF.name == "Opadajući")
          listUsers.sort((x, y) => y.postsNum.compareTo(x.postsNum));
      } else if(catF.name == "Poeni"){
        if(maxMinF == null || maxMinF.name == "Rastući")
          listUsers.sort((x, y) => x.donatedPoints.compareTo(y.donatedPoints));
        else if(maxMinF.name == "Opadajući")
          listUsers.sort((x, y) => y.donatedPoints.compareTo(x.donatedPoints));
      } else if(catF.name == "Nivoi"){
        if(maxMinF == null || maxMinF.name == "Rastući")
          listUsers.sort((x, y) => x.level.compareTo(y.level));
        else if(maxMinF.name == "Opadajući")
          listUsers.sort((x, y) => y.level.compareTo(x.level));
      }
    }
    else{
      if(catF.name == "Id"){
        if(maxMinF == null || maxMinF.name == "Rastući")
          filteredUsers.sort((x, y) => x.id.compareTo(y.id));
        else if(maxMinF.name == "Opadajući")
          filteredUsers.sort((x, y) => y.id.compareTo(x.id));
      } else if(catF.name == "Objave"){
        if(maxMinF == null || maxMinF.name == "Rastući")
          filteredUsers.sort((x, y) => x.postsNum.compareTo(y.postsNum));
        else if(maxMinF.name == "Opadajući")
          filteredUsers.sort((x, y) => y.postsNum.compareTo(x.postsNum));
      } else if(catF.name == "Poeni"){
        if(maxMinF == null || maxMinF.name == "Rastući")
          filteredUsers.sort((x, y) => x.donatedPoints.compareTo(y.donatedPoints));
        else if(maxMinF.name == "Opadajući")
          filteredUsers.sort((x, y) => y.donatedPoints.compareTo(x.donatedPoints));
      } else if(catF.name == "Nivoi"){
        if(maxMinF == null || maxMinF.name == "Rastući")
          filteredUsers.sort((x, y) => x.level.compareTo(y.level));
        else if(maxMinF.name == "Opadajući")
          filteredUsers.sort((x, y) => y.level.compareTo(x.level));
      }
    }
  }

  @override
  initState() {
    super.initState();

    _getUsers(); 
    _getReportedUsers();
    _getCities();

    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween<double>(begin: 220, end: 80).animate(animationController);
    animationController.reverse();
  }

  @override
  void dispose() {
    searchController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return CenteredViewManageUser(
        child: TabBarView(children: <Widget>[
          Column(children: [
            dropdownFU(listCities),
            Flexible(child: filteredUsers==null ?  buildUserList(listUsers) : buildUserList(filteredUsers)),
          ]),
          Column(children: [
            dropdownFRU(listCities),                 
            searchRep(),
            Flexible(child: filteredRepUsers==null ? buildReportedUserList(listRepUsers) : buildReportedUserList(filteredRepUsers)),
          ]),
        ]
        ),
      );
  }

  deleteFromList(int userId){
    for(int i = 0; i < listUsers.length; i++){
      if(listUsers[i].id == userId){
        setState(() {
          listUsers.removeAt(i);
        });
        break;
      }
    }
    
    for(int i = 0; i < listRepUsers.length; i++){
      if(listRepUsers[i].id == userId){
        setState(() {
          listRepUsers.removeAt(i);
        });
        break;
      }
    }
  }

  showAlertDialog(BuildContext context, int id) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("Obriši", style: TextStyle(color: greenPastel),),
      onPressed: () {
        APIServices.deleteUser(TokenSession.getToken,id);
        deleteFromList(id);
        Navigator.pop(context);
        },
    );
     Widget notButton = FlatButton(
      child: Text("Otkaži", style: TextStyle(color: greenPastel),),
      onPressed: () {
        Navigator.pop(context);
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
                  padding: EdgeInsets.only(left:10,right: 10),
                  child: Row(children: [
                    CircleImage(
                      userPhotoURL + listUsers[index].photo,
                      imageSize: 36.0,
                      whiteMargin: 2.0,
                      imageMargin: 6.0,
                    ),
                    Container(
                      width: 150,
                      padding: EdgeInsets.only(left:10,right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(listUsers[index].username,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          Text(
                              listUsers[index].firstName +
                                  " " +
                                  listUsers[index].lastName,
                              style: TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 12))
                        ],
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    PopupMenuButton<String>(
                      onSelected: (String choice) {
                        choiceActionAllUsers(choice, listUsers[index].id, listUsers[index]);
                      },
                      itemBuilder: (BuildContext context) {
                        return ConstantsAllUsers.choices.map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    ),
                  ])),
            ],
          ),
        ));
      },
    );
  }

  void choiceActionAllUsers(String choice, int userId, User user) {
    if (choice == ConstantsAllUsers.PosetiProfil) {
      print("Poseti profil korisnika.");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ViewUserProfilePage(user)),
      );
    } else if (choice == ConstantsAllUsers.ObrisiKorisnika) {
      print("Obrisi profil korisnika.");
      showAlertDialog(context, userId);
    }
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
                      padding: EdgeInsets.only(left:10.0,right: 10),
                      child: Row(children: [
                        CircleImage(
                          userPhotoURL + listRepUsers[index].photo,
                          imageSize: 36.0,
                          whiteMargin: 2.0,
                          imageMargin: 6.0,
                        ),
                        Container(
                          width: 120,
                          padding: EdgeInsets.only(left:10.0,right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(listRepUsers[index].username,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              Text(
                                  listRepUsers[index].firstName +
                                      " " +
                                      listRepUsers[index].lastName,
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic, fontSize: 12))
                            ],
                          ),
                        ),
                        Column(
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
                        Expanded(child: SizedBox()),
                        PopupMenuButton<String>(
                          onSelected: (String choice) {
                            choiceActionReportedUsers(choice, listRepUsers[index].id, listRepUsers[index].firstName, listRepUsers[index].lastName, listRepUsers[index]);
                          },
                          itemBuilder: (BuildContext context) {
                            return ConstantsReportedUsers.choices.map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice),
                              );
                            }).toList();
                          },
                        ),
                      ])),
                ],
              ),
            ));
      },
    );
  }

  void choiceActionReportedUsers(String choice, int userId, String firstname, String lastname, User user) {
    if (choice == ConstantsReportedUsers.DetaljiPrijave) {
      print("Poseti detalje prijave.");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ReportedUserDetailsPage(id: userId, firstName: firstname, lastName: lastname,)),
      );
    } else if (choice == ConstantsReportedUsers.ObrisiKorisnika) {
      print("Obrisi profil korisnika.");
      showAlertDialog(context, userId);
    } else if (choice == ConstantsReportedUsers.PosetiProfil){
      print("Poseti profil korisnika.");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ViewUserProfilePage(user)),
      );
    }
  }

  Widget search() {
    return Container(
      margin: EdgeInsets.only(left: 5, top:5, bottom: 5),
      width: 150,
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        cursorColor: Colors.black,
        onChanged: (string) {
          _debouncer.run(() { 
            setState(() {
              filteredUsers = listUsers
                    .where((u) => (u.username.toLowerCase().contains(string.toLowerCase()) ||
                        ((u.firstName.toLowerCase() + " " + u.lastName.toLowerCase())
                            .contains(string.toLowerCase()))))
                    .toList();
            });
          });
        },
        autofocus: false,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search,color: greenPastel),
          hintText: 'Pretraži...',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(width: 2,color: greenPastel),
          ),
        ),
        controller: searchController,
      )
    );
  }

   City city;


  Widget dropdownFU(List<City> listCities) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(children: <Widget>[
          new Text("Grad: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        listCities != null
        ? new DropdownButton<City>(
            hint: Text("Izaberi"),
            value: city,
            onChanged: (City newValue) {
              if (newValue.name == "Svi korisnici") {
                filteredUsers = null;
              } else {
                _getUsersFromCity(newValue.id);
                _sortListBy();
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
        new Text("Kategorija: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        DropdownButton<CategoryDropDown>(
          hint: Text("Izaberi"),
          value: catF,
          onChanged: (CategoryDropDown newValue) {
            setState(() {
              catF = newValue;
            });

            if (newValue.name == "Objave") {
              print("Objave");
              _sortListBy();
            } else if(newValue.name == "Poeni"){
              print("Poeni");
              _sortListBy();
            } else if(newValue.name == "Nivoi"){
              print("Nivoi");
              _sortListBy();
            } else if(newValue.name == "Id"){
              print("Id");
              _sortListBy();
            }
          },
          items: categories.map((CategoryDropDown option) {
            return DropdownMenuItem(
              child: new Text(option.name),
              value: option,
            );
          }).toList(),
        ),
        ],),
        Row(children: <Widget>[
          new Text("Redosled: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          DropdownButton<MaxMinDropDown>(
            hint: Text("Izaberi"),
            value: maxMinF,
            onChanged: (MaxMinDropDown newValue) {
              setState(() {
                maxMinF = newValue;
              });
              if(newValue.name == "Rastući"){
                print("Rastući");
                _sortListBy();
              } else if(newValue.name == "Opadajući"){
                print("Opadajući");
                _sortListBy();
              }
            },
            items: maxMinFilter.map((MaxMinDropDown option) {
              return DropdownMenuItem(
                child: new Text(option.name),
                value: option,
              );
            }).toList(),
          ),
          search()
        ],)
      ]);
  }

Widget dropdownFRU(List<City> listCities) {
        return new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text("Grad: ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          SizedBox(width: 10,),   
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
      margin: EdgeInsets.only(left: 50, top:5, bottom: 5),
      width: 200,
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        cursorColor: Colors.black,
        onChanged: (string) {
          _debouncer.run(() { 
            setState(() {
              filteredRepUsers = listRepUsers
                    .where((u) => (u.username.toLowerCase().contains(string.toLowerCase()) ||
                        ((u.firstName.toLowerCase() + " " + u.lastName.toLowerCase())
                            .contains(string.toLowerCase()))))
                    .toList();
            });
          });
        },
        autofocus: false,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search,color: greenPastel),
          hintText: 'Pretraži...',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(width: 2,color: greenPastel),
          ),
        ),
        controller: searchRepController,
      )
    );
  }
  
}

class CategoryDropDown{
  int id;
  String name;

  CategoryDropDown(this.id, this.name);

  static List<CategoryDropDown> getCategoriesDropDown(){
    return <CategoryDropDown>[
      CategoryDropDown(1,"Id"),
      CategoryDropDown(2,"Objave"),
      CategoryDropDown(3,"Poeni"),
      CategoryDropDown(4,"Nivoi"),
    ];
  }
}

class MaxMinDropDown{
  int id;
  String name;

  MaxMinDropDown(this.id, this.name);

  static List<MaxMinDropDown> getMaxMinDropDown(){
    return <MaxMinDropDown>[
      MaxMinDropDown(1,"Rastući"),
      MaxMinDropDown(2,"Opadajući"),
    ];
  }
}