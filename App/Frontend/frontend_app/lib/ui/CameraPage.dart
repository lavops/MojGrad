import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/categories.dart';
import 'package:frontend/models/postType.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/ui/homePage.dart';
import 'package:geocoder/geocoder.dart';
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
  List<PostType> _postType;
  PostType postType;
  File imageFile;
  double latitude1 = 0;
  double longitude2 = 0;
  var first;
  String addres='';
  var id=0;

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

  _getPostType()
  {
    APIServices.getPostType().then((res) {
      Iterable list = json.decode(res.body);
      List<PostType> postTypes = new List<PostType>();
      postTypes = list.map((model) => PostType.fromObject(model)).toList();
      if(mounted){
        setState(() {
          _postType = postTypes;
        });
      }
    });
    
  }

  @override
  void initState() {
    super.initState();
    _getToken();
    _getPostType();
  }

  // Function for opening a camera
  _openGalery() async{
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
    });
  }

   getUserLocation(double latitude, double longitude) async {
     if(latitude != 0.0 && longitude != 0.0)
     {
       print(latitude.toString()+" "+ longitude.toString());
      final coordinates = new Coordinates(latitude, longitude);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      first = addresses.first;
      print("${first.featureName} : ${first.addressLine}");

      setState(() {
        addres=" ${first.addressLine}";
       
    });
      }
   
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
    first = getUserLocation(latitude1, longitude2);
  }

  bool notNull(Object o) => o != null;
  @override
  Widget build(BuildContext context) {
    
    // Chosing what post type should be
    final vrstaObjave = Row(
      children: <Widget>[
        Align(alignment: Alignment.topLeft, child: Text("Vrsta objave: ", style: TextStyle(fontWeight: FontWeight.bold),)),
        Text("Problem"),
        Flexible(child:
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
        ),
        Text("Pohvala"),
        Flexible(child:
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
        ),
      ],
    );

    // Chosing who will do that assigment
    final problemResava = Row(
      children: <Widget>[
        Align(alignment: Alignment.topLeft, child: Text("Problem resava: ", style: TextStyle(fontWeight: FontWeight.bold))),
        Text("Resicu sam"),
        Flexible(child: 
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
        ),
        Text("Neko drugi"),
        Flexible(child:
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
        ),
      ],
    );

    // Chosing type of assigment
    final _dropDown = Row(
      children: <Widget>[
        Align(alignment: Alignment.topLeft, child: Text("Kategoriju: ",style: TextStyle(fontWeight: FontWeight.bold))),
        _postType != null? DropdownButton<PostType>(
          hint:  Text("Izaberi"),
          value: postType,
          onChanged: (PostType value) {
            setState(() {
              postType = value;
            });
          },
          items: _postType.map((PostType option) {
            return  DropdownMenuItem<PostType>(
              value: option,
              child: Text(option.typeName),
            );
          }).toList(),
        ):
        DropdownButton<String>(
          hint:  Text("Izaberi"),
          onChanged: null,
          items: null,
        ),
      ],
    );
    
    // Pick image from your camera live
    final cameraPhone = RaisedButton.icon(
      label: Flexible(child: Text('Kamera'),),
      onPressed: (){
        _openCamera();
      },
      icon: Icon(Icons.camera_alt),
      //color: Colors.greenAccent,
      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50),),
    );


    // Pick image from your gallery
    final cameraGalery = RaisedButton.icon(
      label: Flexible(child: Text('Galerija'),),
      onPressed: (){
        _openGalery();
      },
      icon: Icon(Icons.photo_library),
      //color: Colors.greenAccent,
      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50),),
    );

    // Row with camera buttons
    final izaberiKameru = Row(
      children: <Widget>[
        Expanded(
          child: cameraPhone,
          flex: 10,
        ),
        Expanded(
          child: Container(color: Colors.white),
          flex: 1,
        ),
        Expanded(
          child: cameraGalery,
          flex: 10,
        ),
      ],
    );

    // button for current location
    final currentLocation = RaisedButton.icon(
      label: Flexible(child: Text('Trenutna lokacija'),),
      onPressed: (){
        currentLocationFunction();
        getUserLocation(latitude1, longitude2);
      },
     icon: Icon(Icons.my_location, size:20),
      //color: Colors.green[800],
      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50),),
    );

    // button for choosing location
    final chooseLocation = RaisedButton.icon(
      label: Flexible(child: Text('Izaberi lokaciju'),),
      onPressed: (){
        currentLocationFunction();
      },
      icon: Icon(Icons.location_on),
      //color: Colors.green[800],
      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50),),
    );

    // row with location's buttons
    final locationRow = Row(
      children: <Widget>[
        Expanded(
          child: currentLocation,
          flex: 10,
        ),
        Expanded(
          child: Container(color: Colors.white),
          flex: 1,
        ),
        Expanded(
          child: chooseLocation,
          flex: 10,
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
    final submitObjavu = RaisedButton.icon(
      label: Flexible(child: Text('Objavi'),),
      onPressed: (){
        imageUpload(imageFile);
        if(_problemResava==1) 
          statusId=2;
        else 
          statusId=1;
        
        if(_vrstaObjave == 2) //pohvala
          postTypeId=1;
        else  
          postTypeId = postType.id;
        
        APIServices.addPost(token,user.id, postTypeId, description.text, basename(imageFile.path), statusId, latitude1, longitude2);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      },
      icon: Icon(Icons.nature_people),
      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50),),
    );

    return Center(
      
      child:Container(
        width: 400,
        child: ListView(    
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 24.0, bottom: 24.0),
          children: <Widget>[
            Align(alignment: Alignment.topCenter, child: Text("Izaberi fotografiju: ",style: TextStyle(fontWeight: FontWeight.bold))),
            SizedBox(height: 20.0,),
            izaberiKameru,
            imageFile != null ? Image.file(imageFile,width: 300,height: 300,) : null ,

            vrstaObjave,
            _vrstaObjave == 1 ? Column(children: <Widget>[ problemResava, _dropDown]) : null,
            
            SizedBox(height: 20.0,),
            locationRow,
             latitude1 != 0 && longitude2 != 0 ? Align(alignment: Alignment.topCenter, child: Text(addres)): null,
            
            SizedBox(height: 20.0,),
            opis,
            SizedBox(height: 20.0,),
            submitObjavu
          ].where(notNull).toList(),
        ),
      
      )
    );
  }
}