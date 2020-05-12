import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/city.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/services/images.dart';
import 'package:frontend/ui/homePage.dart';
import 'package:frontend/widgets/uploadScreen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:nominatim_location_picker/nominatim_location_picker.dart';
import 'package:path/path.dart';

class CameraThree extends StatefulWidget {
  @override
  _CameraThreeState createState() => _CameraThreeState();
}

class _CameraThreeState extends State<CameraThree>{
  
  List<City> _city;
  City city;
  
  File imageFile;
  var description = TextEditingController();
  String pogresanText = '';

  var first;
  double latitude1 = 0;
  double longitude2 = 0;
  String addres = '';
  LatLng location;
  Geolocator get geolocator => Geolocator()..forceAndroidLocationManager;

  _getCity() async {
    APIServices.getCity().then((res) {
      Iterable list = json.decode(res.body);
      List<City> cities = new List<City>();
      cities = list.map((model) => City.fromObject(model)).toList();
      setState(() {
        _city = cities;
      });
    });
  }

  _openGalery() async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if(picture != null)
      print("Kompresovana " + picture.lengthSync().toString());
    this.setState(() {
      imageFile = picture;
    });
  }

  _getUserLocation() async {
    try {
      List<Placemark> p =
          await geolocator.placemarkFromCoordinates(latitude1, longitude2);
      Placemark place = p[0];
      setState(() {
        addres =
            "${place.locality},${place.thoroughfare}${place.subThoroughfare},${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  // Function for opening a gallery
  _openCamera() async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if(picture != null)
      print("Kompresovana " + picture.lengthSync().toString());
    this.setState(() {
      imageFile = picture;
    });
  }

  // Funciton to get current location
  currentLocationFunction() async {
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
    first = _getUserLocation();
  }

  bool notNull(Object o) => o != null;

  @override
  void initState() {
    super.initState();
    _getCity();
  }

  @override
  Widget build(BuildContext context) {
    
    final _dropDownCity = Row(
      children: <Widget>[
        Align(
            alignment: Alignment.topLeft,
            child: Text("Grad: ",
                style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyText1.color))),
        _city != null
            ? DropdownButton<City>(
                hint: Text("Izaberi", style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color)),
                value: city,
                onChanged: (City value) {
                  setState(() {
                    city = value;
                  });
                },
                items: _city.map((City option) {
                  return DropdownMenuItem<City>(
                    value: option,
                    child: Text(option.name),
                  );
                }).toList(),
              )
            : DropdownButton<String>(
                hint: Text("Izaberi"),
                onChanged: null,
                items: null,
              ),
      ],
    );

    // Pick image from your camera live
    final cameraPhone = MaterialButton(
      onPressed: () {
        _openCamera();
      },
      color: Colors.green[800],
      textColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.camera_alt,
              size: 30,
              color: Theme.of(context).copyWith().iconTheme.color), // icon
          Text(
            "Kamera",
            style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
          ), // text
        ],
      ),
      padding: EdgeInsets.all(16),
      shape: CircleBorder(),
    );

    // Pick image from your gallery
    final cameraGalery = MaterialButton(
      onPressed: () {
        _openGalery();
      },
      color: Colors.green[800],
      textColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.add_photo_alternate,
              size: 30,
              color: Theme.of(context).copyWith().iconTheme.color), // icon
          Text(
            "Galerija",
            style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
          ), // text
        ],
      ),
      padding: EdgeInsets.all(16),
      shape: CircleBorder(),
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
      label: Flexible(
        child: Text('Trenutna lokacija', style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color)),
      ),
      onPressed: () {
        currentLocationFunction();
        _getUserLocation();
      },
      icon: Icon(Icons.my_location, size: 20),
      color: Colors.green[800],
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(50),
      ),
    );

    Future getLocationWithNominatim() async {
      Map result = await showDialog(
          context: context,
          builder: (BuildContext ctx) {
            return NominatimLocationPicker(
              searchHint: 'Pretraži',
              awaitingForLocation: "Čeka se lokacija.",
              customMapLayer: new TileLayerOptions(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/lavops/ck8m295d701du1iqid1ejoqxu/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibGF2b3BzIiwiYSI6ImNrOG0yNm05ZDA4ZDcza3F6OWZpZ3pmbHUifQ.FBDBK21WD6Oa4V_5oz5iJQ",
                additionalOptions: {
                  'accessToken':
                      'pk.eyJ1IjoibGF2b3BzIiwiYSI6ImNrOG0yNm05ZDA4ZDcza3F6OWZpZ3pmbHUifQ.FBDBK21WD6Oa4V_5oz5iJQ',
                  'id': 'mapbox.mapbox-streets-v7'
                }),
            );
          });
      if (result != null) {
        setState(() => location = result['latlng']);
        setState(() {
          latitude1 = location.latitude;
          longitude2 = location.longitude;
          _getUserLocation();
        });
      } else {
        return;
      }
    }

    // button for choosing location
    final chooseLocation = RaisedButton.icon(
      label: Flexible(
        child: Text('Izaberi lokaciju', style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color)),
      ),
      onPressed: () async{
        await getLocationWithNominatim();
      },
      icon: Icon(Icons.location_on,),
      color: Colors.green[800],
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(50),
      ),
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
      maxLength: 150,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        hintText: 'Opis pohvale',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(width: 2, color: Colors.green[800]),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(width: 1, color: Colors.green[800]),
        ),
      ),
    );

    // Submit it
    final submitObjavu = RaisedButton.icon(
      label: Flexible(
        child: Text('Objavi', style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color)),
      ),
      onPressed: () {
        imageUpload(imageFile);

        APIServices.jwtOrEmpty().then((res) {
          String jwt;
          setState(() {
            jwt = res;
          });

          if (imageFile == null || addres == null) {
            setState(() {
              pogresanText = "Popuni obavezna polja: tip posta i lokaciju.";
            });
            throw Exception('Greskaaaa');
          }
          if (res != null && imageFile != null && addres != null && city!= null) {
            APIServices.addPost(
                jwt,
                userId,
                1,
                description.text,
                "Upload//Post//" + basename(imageFile.path),
                1,
                latitude1,
                longitude2,
                addres, city.id);
            APIServices.jwtOrEmpty().then((res) {
              String jwt;
              setState(() {
                jwt = res;
              });
              if (res != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UploadScreen(jwt)),
                );
              }
            });
          }
        });
      },
      icon: Icon(Icons.nature_people),
      color: Colors.green[800],
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(50),
      ),
    );

    final wrongData = Center(
        child: Text(
      '$pogresanText',
      style: TextStyle(color: Colors.red),
    ));

    return Scaffold(
      appBar: AppBar(
         backgroundColor: MyApp.ind == 0
            ? Colors.white
            : Theme.of(context).copyWith().backgroundColor,
        iconTheme: IconThemeData(
            color: Theme.of(context).copyWith().iconTheme.color,
            size: Theme.of(context).copyWith().iconTheme.size),
      ),
      body: Center(
        child:ListView(
        shrinkWrap: true,
        padding:
            EdgeInsets.only(left: 15.0, right: 15.0, top: 0.0, bottom: 24.0),
        children: <Widget>[
          izaberiKameru,
          SizedBox(height: 30),
          imageFile != null
              ? Image.file(
                  imageFile,
                  width: 300,
                  height: 300,
                )
              : null,
          _dropDownCity,
          SizedBox(
            height: 20.0,
          ),
          locationRow,
          latitude1 != 0 && longitude2 != 0
              ? Align(alignment: Alignment.topCenter, child: Text(addres))
              : null,
          SizedBox(
            height: 20.0,
          ),
          opis,
          SizedBox(
            height: 20.0,
          ),
          submitObjavu,
          wrongData
        ].where(notNull).toList(),
      ),
      )
    );
  }
  
}