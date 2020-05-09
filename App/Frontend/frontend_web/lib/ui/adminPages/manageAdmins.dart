import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'dart:convert';
import 'package:frontend_web/widgets/circleImageWidget.dart';
import '../../models/admin.dart';
import '../../widgets/collapsingNavigationDrawer.dart';

Color greenPastel = Color(0xFF00BFA6);

class ManageAdminsPage extends StatefulWidget {
  final int id;

  ManageAdminsPage({Key key, this.id});

  @override
  _ManageAdminsPageState createState() => new _ManageAdminsPageState();
}

class _ManageAdminsPageState extends State<ManageAdminsPage> {
  List<Admin> listAdmins;
  TextEditingController searchController = new TextEditingController();
  int idA;

  Admin admin1;
  _getAdmin(int idA) async {
    var res = await APIServices.getAdmin(TokenSession.getToken,idA);
    Map<String, dynamic> jsonUser = jsonDecode(res.body);
    Admin admin = Admin.fromObject(jsonUser);
    setState(() {
      admin1 = admin;
    });
  }

  _getAdmins() {
    APIServices.getAdmins(TokenSession.getToken).then((res) {
      Iterable list = json.decode(res.body);
      List<Admin> listA = List<Admin>();
      listA = list.map((model) => Admin.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          listAdmins = listA;
        });
      }
    });
  }

  @override initState() {
    super.initState();
    idA = widget.id;
    _getAdmin(idA);
    _getAdmins();
  }

  showAlertDialog(BuildContext context, int id) {
      // set up the button
    Widget okButton = FlatButton(
      child: Text("Obriši", style: TextStyle(color: greenPastel),),
      onPressed: () {
        APIServices.deleteUser(TokenSession.getToken,id);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ManageAdminsPage()),
        );
        },
    );
     Widget notButton = FlatButton(
      child: Text("Otkaži", style: TextStyle(color: Colors.redAccent),),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ManageAdminsPage()),
        );
        },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Brisanje administratora"),
      content: Text("Da li ste sigurni da želite da obrišete administratora?"),
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

  Widget buildAdminList() {
    return ListView.builder(
      itemCount: listAdmins == null ? 0 : listAdmins.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
            child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              listAdmins[index].id != idA ?
              Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(5),
                  //margin: EdgeInsets.only(top: 5),
                  child: Row(children: [            
                    CircleImage(
                      userPhotoURL + listAdmins[index].photoPath,
                      imageSize: 56.0,
                      whiteMargin: 2.0,
                      imageMargin: 6.0,
                    ),
                    Container(
                      width: 200,
                      padding: EdgeInsets.all(10),
                      child: 
                          Text(
                              listAdmins[index].firstName +
                                  " " +
                                  listAdmins[index].lastName,
                              style: TextStyle(fontSize: 15))
                    ),        
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(11.0),
                          side: BorderSide(color: Colors.redAccent)),
                      color: Colors.redAccent,
                      child: Text(
                        "Obriši administatora",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        showAlertDialog(context, listAdmins[index].id);
                      },
                    ),
                  ])) : Container(width: 1, height: 1),
            ],
          ),
        ));
      },
    );
  }


  Widget search() {
    return Container(
      color:Colors.white,
      margin: EdgeInsets.only(left: 50, right: 50, top:5, bottom: 5),
      padding: const EdgeInsets.all(8.0),
      child: TextField(
      autofocus: false,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search,color: greenPastel),
        hintText: 'Pretraži ostale administratore...',
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

Widget loginAdmin(){
  return Container(
    color:Colors.white,
      padding: EdgeInsets.all(10),
     // margin: EdgeInsets.only(top: 5),
          width:500,
          height:520,
         child:
          ListView(
          children: <Widget>[
            SizedBox(height:10),
            Center(
            child:Text('Informacije o prijavljenom administratoru:',style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(5),
                  //margin: EdgeInsets.only(top: 5),
                  child: Column(children: [
                    CircleImage(
                      userPhotoURL + admin1.photoPath,
                      imageSize: 100.0,
                      whiteMargin: 2.0,
                      imageMargin: 6.0,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                  Text(
                          'Promeni profilnu sliku',
                          style: TextStyle(
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                  ])),
            ListTile(
              leading: Icon(Icons.person,  color: greenPastel),
              title: Text('Ime'),
              subtitle: Text(admin1.firstName),
              trailing:  FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(11.0),
                    side: BorderSide(color: Colors.grey)),
                color: Colors.grey,
               child: Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                 
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.person_outline,  color: greenPastel),
              title: Text('Prezime'),
              subtitle: Text(admin1.lastName),
              trailing:  FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(11.0),
                    side: BorderSide(color: Colors.grey)),
                color: Colors.grey,
                child: Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.email,  color: greenPastel),
              title: Text('E-mail'),
              subtitle: Text(admin1.email),
              trailing:  FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(11.0),
                    side: BorderSide(color: Colors.grey)),
                color: Colors.grey,
                child: Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  
                },
              ),
            ),
           Center(
             child: Container(
              width: 150,
              child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(11.0),
                  side: BorderSide(color: greenPastel)),
              color: greenPastel,
              child: Text(
                "Sačuvaj izmene",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {

              },
            ))),
             ]) );}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              title: Text('Upravljanje administratorima',
                  style: TextStyle(color: Colors.black)),
              backgroundColor: Colors.white,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    
                  }),
              
            ),
            body: Stack(
          children: <Widget>[
              Container(
                margin: EdgeInsets.only(left:400, right: 400),
                  padding: EdgeInsets.only(top: 0),
                  color: Colors.grey[100],
                  child: Column(children: [
                     Flexible(child:RefreshIndicator(
                      onRefresh: _handleRefresh,
                    child:     (admin1 != null) ? loginAdmin() : Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.green[800]),
                    ),
                  ),)),
                    Container(
                      color:Colors.white,
                      child: Column(children:[
                        Text('Informacije o ostalim administratorima:',style: TextStyle(fontWeight: FontWeight.bold)),
                        search(),])),
                    Flexible(child:RefreshIndicator(
                      onRefresh: _handleRefresh,
                    child:     (listAdmins != null) ? buildAdminList() : Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.green[800]),
                    ),
                  ),))
                  ])),
        CollapsingNavigationDrawer(),
          ])
            );
  }


    Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 3));
    setState(() {
      listAdmins = [];
    });
    _getAdmins();
    return null;
  }

}
