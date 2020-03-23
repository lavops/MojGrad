import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/categories.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/ui/homePage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/services/images.dart';
import 'dart:io';
import 'package:frontend/services/api.services.dart';
import 'package:location/location.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  String token = '';
  User user;
  int postTypeId;
  var description = TextEditingController();
  int statusId;
  int _vrstaObjave = 1;
  int _problemResava = 1;
  List<Category> _categories = Category.getCategories();
  Category category;
  File imageFile;
  double latitude1 = 0;
  double longitude2 = 0;

   _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _token = prefs.getString('token');
    Map<String, dynamic> jsonObject = json.decode(prefs.getString('user'));
     User extractedUser = new User();
     extractedUser = User.fromObject(jsonObject);
    setState(() {
      token = _token;
      user = extractedUser;
    });
  }

   @override
  void initState() {
    super.initState();
    _getToken();
  }

  // Function for opening a camera
  _openGalery() async{
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
    });
  }

  // Function for opening a gallery
  _openCamera() async{
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = picture;
    });
  }

  // Funciton to get current location
  currentLocationFunction() async{
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.DENIED) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.GRANTED) {
        return;
      }
    }

    _locationData = await location.getLocation();

    setState(() {
      latitude1 = _locationData.latitude;
      longitude2 = _locationData.longitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    // Chosing what post type should be
    final vrstaObjave = Row(
      children: <Widget>[
        Align(alignment: Alignment.topLeft, child: Text("Vrsta objave: ", style: TextStyle(fontWeight: FontWeight.bold),)),
        Text("Problem"),
        Radio(
          value: 1,
          groupValue: _vrstaObjave,
          onChanged: (int value) {
            setState(() {
              _vrstaObjave = value;
            });
          },
          focusColor: Colors.green[800],
          activeColor: Colors.green[800],
        ),
        Text("Pohvala"),
        Radio(
          value: 2,
          groupValue: _vrstaObjave,
          onChanged: (int value) {
            setState(() {
              _vrstaObjave = value;
            });
          },
          focusColor: Colors.green[800],
          activeColor: Colors.green[800],
        ),
      ],
    );

    // Chosing who will do that assigment
    final problemResava = Row(
      children: <Widget>[
        Align(alignment: Alignment.topLeft, child: Text("Problem resava: ", style: TextStyle(fontWeight: FontWeight.bold))),
        Text("Resicu sam"),
        Radio(
          value: 1,
          groupValue: _problemResava,
          onChanged: (int value) {
            setState(() {
              _problemResava = value;
            });
          },
          focusColor: Colors.green[800],
          activeColor: Colors.green[800],
        ),
        Text("Neko drugi"),
        Radio(
          value: 2,
          groupValue: _problemResava,
          onChanged: (int value) {
            setState(() {
              _problemResava = value;
            });
          },
          focusColor: Colors.green[800],
          activeColor: Colors.green[800],
        ),
      ],
    );

    // Chosing type of assigment
    final _dropDown = Row(
      children: <Widget>[
        Align(alignment: Alignment.topLeft, child: Text("Kategoriju: ",style: TextStyle(fontWeight: FontWeight.bold))),
        DropdownButton<Category>(
          hint:  Text("Izaberi"),
          value: category,
          onChanged: (Category value) {
            setState(() {
              category = value;
            });
          },
          items: _categories.map((Category option) {
            return  DropdownMenuItem<Category>(
              value: option,
              child: Text(option.name),
            );
          }).toList(),
        ),
      ],
    );
    
    // Pick image from your camera live
    final cameraPhone = RaisedButton(
      child: Text('Kamera'),
      onPressed: (){
        _openCamera();
      },
    );

    // Pick image from your gallery
    final cameraGalery = RaisedButton(
      child: Text('Galerija'),
      onPressed: (){
        _openGalery();
      },
    );

    // Row with camera buttons
    final izaberiKameru = Row(
      children: <Widget>[
        Expanded(
          child: cameraPhone,
          flex: 2,
        ),
        Expanded(
          child: Container(color: Colors.white),
          flex: 1,
        ),
        Expanded(
          child: cameraGalery,
          flex: 2,
        ),
      ],
    );

    // button for current location
    final currentLocation = RaisedButton(
      child: Text('Trenutna lokacija'),
      onPressed: (){
        currentLocationFunction();
      },
    );

    // button for choosing location
    final chooseLocation = RaisedButton(
      child: Text('Izaberi lokaciju'),
      onPressed: (){
        currentLocationFunction();
      },
    );

    // row with location's buttons
    final locationRow = Row(
      children: <Widget>[
        Expanded(
          child: currentLocation,
          flex: 2,
        ),
        Expanded(
          child: Container(color: Colors.white),
          flex: 1,
        ),
        Expanded(
          child: chooseLocation,
          flex: 2,
        ),
      ],
    );

    // Description of assigment or praise
    final opis = TextField(
      controller: description,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black)
        ),
        hintText: (_vrstaObjave == 1)? 'Opis problema': 'Opis pohvale',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(width: 2,color: Colors.green[800]),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(width: 1,color: Colors.green[800]),
        ),
      ),
    );

    // Submit it
    final submitObjavu = RaisedButton(
      child: Text('Objavi'),
      onPressed: (){
        imageUpload(imageFile);
        if(_problemResava==1) 
          statusId=2;
        else 
          statusId=1;
        
        if(_vrstaObjave == 2) //pohvala
          postTypeId=1;
        else  
          postTypeId = category.id;
        
        APIServices.addPost(token,user.id, postTypeId, description.text, basename(imageFile.path), statusId, latitude1, longitude2);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyBottomBar()),
        );
      },
    );

    return Center(
      child:Container(
        width: 400,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0, bottom: 24.0),
          children: <Widget>[
            vrstaObjave,
            if(_vrstaObjave == 1)...[
              problemResava,
              _dropDown,
            ],
            SizedBox(height: 20.0,),
            Align(alignment: Alignment.topCenter, child: Text("Izaberi fotografiju: ",style: TextStyle(fontWeight: FontWeight.bold))),
            SizedBox(height: 20.0,),
            izaberiKameru,
            if(imageFile != null)...[
              Image.file(imageFile,width: 300,height: 300,),
              
            ],locationRow,
              if(latitude1 != 0 && longitude2 != 0)
                Align(alignment: Alignment.topCenter, child: Text(latitude1.toString() + ' , ' + longitude2.toString())),
            SizedBox(height: 20.0,),
            opis,
            SizedBox(height: 20.0,),
            submitObjavu
          ],
        ),
      )
    );
  }
}