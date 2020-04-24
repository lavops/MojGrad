import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/city.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/images.dart';
import 'package:frontend/ui/UserProfilePage.dart';
import 'package:frontend/widgets/circleImageWidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import '../main.dart';
import '../services/api.services.dart';

class EditProfilePage extends StatefulWidget {
  final User user;

  EditProfilePage(this.user);

  @override
  State<StatefulWidget> createState() {
    return EditProfile(user);
  }
}

class EditProfile extends State<EditProfilePage> {
  User user;
  File imageFile;
  EditProfile(User user1) {
    user = user1;
  }

  Future<File> _openGalery() async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
      return picture;
    });
    return null;
  }

  Future<File> _openCamera() async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = picture;
      return picture;
    });
    return null;
  }

  getCity() async {
    APIServices.getCity().then((res) {
      Iterable list = json.decode(res.body);
      List<City> listCities = new List<City>();
      listCities = list.map((model) => City.fromObject(model)).toList();
      setState(() {
        _city = listCities;
        _dropdownMenuItems = buildDropDownMenuItems(_city);
        _selectedId = _dropdownMenuItems[user.cityId - 1].value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCity();
  }

  List<DropdownMenuItem<City>> buildDropDownMenuItems(List cities) {
    List<DropdownMenuItem<City>> newCity = List();
    for (City item in cities) {
      newCity.add(DropdownMenuItem(
        value: item,
        child: Text(item.name),
      ));
    }

    return newCity;
  }

  void _onValueChange(City value) {
    setState(() {
      _selectedId = value;
    });
  }

  int _selectedOption = 0;
  int index = 7;
  String firstName = '',
      lastName = '',
      username1 = '',
      password1 = '',
      email1 = '',
      number1 = '',
      oldPassword = '',
      city1 = '';
  var newPass, oldPass;
  int ind = 0;
  List<City> _city;
  List<DropdownMenuItem<City>> _dropdownMenuItems;
  City _selectedId;

  final flNameRegex = RegExp(r'^[a-zA-Z\s]{1,}$');
  final mobRegex = RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');
  final passRegex = RegExp(r'[a-zA-Z0-9.!]{6,}');
  final emailRegex = RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}');
  final usernameRegex = RegExp(r'^[a-z0-9]{1,1}[._a-z0-9]{1,}');

  editProfilePhotoo(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(
        "Izmeni",
        style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
      ),
      onPressed: () {
        if (imageFile != null) {
          imageUploadProfilePhoto(imageFile);
          APIServices.jwtOrEmpty().then((res) {
            String jwt;
            setState(() {
              jwt = res;
            });
            if (res != null) {
              APIServices.editProfilePhoto(jwt, user.id,
                      "Upload//ProfilePhoto//" + basename(imageFile.path))
                  .then((response) {
                Map<String, dynamic> jsonUser = jsonDecode(response);
                User user1 = User.fromObject(jsonUser);
                if (user1 != null) {
                  /* Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserProfilePage(user1)),
                        
                  );*/
                  Navigator.of(context).pop();
                }
              });
            }
          });
        }
      },
    );

    Widget closeButton = FlatButton(
      child: Text(
        "Otkaži",
        style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
      ),
      onPressed: () {
        /*Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserProfilePage(user)),
        );*/
        Navigator.pop(context);
      },
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        File imageFilee;
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
            title: Text(
              "Promena profilne slike",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1.color,
                fontSize: 16,
              ),
            ),
            content: Container(
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton.icon(
                            color: Colors.green[800],
                            label: Flexible(
                              child: Text('Kamera'),
                            ),
                            onPressed: () {
                              _openCamera().then((res) {
                                setState(() {
                                  imageFilee = res;
                                });
                              });
                            },
                            icon: Icon(Icons.camera_alt,
                                color: Theme.of(context)
                                    .copyWith()
                                    .iconTheme
                                    .color),
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(50),
                            ),
                          ),
                          flex: 10,
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.white,
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: RaisedButton.icon(
                            color: Colors.green[800],
                            label: Flexible(
                              child: Text(
                                'Galerija',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color),
                              ),
                            ),
                            onPressed: () {
                              _openGalery().then((res) {
                                setState(() {
                                  imageFilee = res;
                                });
                              });
                            },
                            icon: Icon(Icons.photo_library,
                                color: Theme.of(context)
                                    .copyWith()
                                    .iconTheme
                                    .color),
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(50),
                            ),
                          ),
                          flex: 10,
                        ),
                      ],
                    ),
                    ClipOval(
                      child: imageFile != null
                          ? Image.file(
                              imageFile,
                              height: 150.0,
                              width: 150.0,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              serverURLPhoto + user.photo,
                              height: 150.0,
                              width: 150.0,
                              fit: BoxFit.cover,
                            ),
                    )
                  ],
                )),
            actions: [
              okButton,
              closeButton,
            ],
          );
        });
      },
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(
        "OK",
        style: TextStyle(color: Colors.green[800]),
      ),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserProfilePage(user)),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Izmena podataka",
        style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
      ),
      content: Text("Uspešno ste izmenili podatke.",
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText1.color,
          )),
      actions: [
        okButton,
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

  //dialog name
  Future<String> firstLastName(BuildContext context, String name) {
    TextEditingController customController;
    if (firstName == '') {
      customController = new TextEditingController(text: "$name");
    } else {
      String _name = firstName + " " + lastName;
      customController = new TextEditingController(text: "$_name");
    }

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
            content: Container(
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("Ime i prezime",
                            style: TextStyle(
                                fontSize: 24,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .color))
                      ],
                    ),
                    SizedBox(height: 5),
                    TextField(
                      controller: customController,
                      decoration: InputDecoration(
                        hoverColor: Colors.grey,
                        labelStyle: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1.color),
                        fillColor: Colors.black,
                        contentPadding: const EdgeInsets.all(10.0),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        MaterialButton(
                          child: Text(
                            "Izmeni",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .color),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            var check = customController.text;
                            print(check);

                            if (flNameRegex.hasMatch(check)) {
                              var array = check.split(" ");

                              print(check);
                              print(array[0] + ", " + array[1]);

                              setState(() {
                                firstName = array[0];
                                lastName = array[1];
                              });
                              Navigator.of(context).pop();
                            } else {
                              check = "Greska";
                              print(check);
                              Navigator.of(context).pop(check.toString());
                            }
                          },
                        ),
                        SizedBox(width: 50),
                        FlatButton(
                          child: Text(
                            "Otkaži",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .color),
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedOption = 0;
                            });
                            Navigator.pop(context);
                          },
                        )
                      ],
                    )
                  ],
                )),
          );
        });
  }

  //dialog username
  Future<String> username(BuildContext context, String username) {
    TextEditingController customController;
    if (username1 == '') {
      customController = new TextEditingController(text: "$username");
    } else {
      String _username = username1;
      customController = new TextEditingController(text: "$_username");
    }

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
            content: Container(
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("Korisničko ime",
                            style: TextStyle(
                                fontSize: 24,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .color))
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: customController,
                      decoration: InputDecoration(
                        hoverColor: Colors.grey,
                        labelStyle: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1.color,
                            fontStyle: FontStyle.italic),
                        fillColor: Colors.black,
                        contentPadding: const EdgeInsets.all(10.0),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        MaterialButton(
                          child: Text(
                            "Izmeni",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .color),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            var check = customController.text;
                            print(check);

                            if (usernameRegex.hasMatch(check)) {
                              setState(() {
                                username1 = check;
                              });
                              Navigator.of(context).pop();
                            } else {
                              check = "Greska";
                              print(check);
                              Navigator.of(context).pop(check.toString());
                            }
                          },
                        ),
                        SizedBox(width: 50),
                        FlatButton(
                          child: Text(
                            "Otkaži",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .color),
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedOption = 0;
                            });
                            Navigator.pop(context);
                          },
                        )
                      ],
                    )
                  ],
                )),
          );
        });
  }

  //dialog password
  Future<String> password(BuildContext context, String myPassword) {
    TextEditingController customController = new TextEditingController();
    TextEditingController customController2 = new TextEditingController();
    TextEditingController customController3 = new TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
            content: Container(
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("Šifra",
                            style: TextStyle(
                                fontSize: 24,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .color))
                      ],
                    ),
                    SizedBox(height: 5),
                    TextField(
                      controller: customController,
                      autofocus: false,
                      obscureText: true,
                      decoration: InputDecoration(
                        hoverColor: Colors.grey,
                        hintText: "Trenutna šifra",
                        hintStyle: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1.color),
                        labelStyle: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1.color,
                            fontStyle: FontStyle.italic),
                        fillColor: Theme.of(context).textTheme.bodyText1.color,
                        contentPadding: const EdgeInsets.all(10.0),
                      ),
                    ),
                    SizedBox(height: 5),
                    TextField(
                      controller: customController2,
                      autofocus: false,
                      obscureText: true,
                      decoration: InputDecoration(
                        hoverColor: Colors.grey,
                        hintText: "Nova šifra",
                        labelStyle: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1.color,
                            fontStyle: FontStyle.italic),
                        fillColor: Colors.black,
                        contentPadding: const EdgeInsets.all(10.0),
                      ),
                    ),
                    SizedBox(height: 5),
                    TextField(
                      controller: customController3,
                      autofocus: false,
                      obscureText: true,
                      decoration: InputDecoration(
                        hoverColor: Colors.grey,
                        hintText: "Ponovi šifru",
                        labelStyle: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1.color,
                            fontStyle: FontStyle.italic),
                        fillColor: Colors.black,
                        contentPadding: const EdgeInsets.all(10.0),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        MaterialButton(
                          child: Text(
                            "Izmeni",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .color),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            var temp2 = customController.text; //trenutna
                            var check = customController2.text; //nova
                            var checkAgain = customController3.text;

                            print(temp2);
                            print(myPassword);

                            if (check == checkAgain) {
                              if (passRegex.hasMatch(check)) {
                                print(check);
                                setState(() {
                                  password1 = check;
                                  oldPassword = temp2;
                                });
                                Navigator.of(context).pop();
                              } else {
                                check = "Greska regEx";
                                print(check);
                                Navigator.of(context).pop(check.toString());
                              }
                            } else {
                              print("Nova i ponovljena nisu iste");
                            }
                          },
                        ),
                        SizedBox(width: 50),
                        FlatButton(
                          child: Text(
                            "Otkaži",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .color),
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedOption = 0;
                            });
                            Navigator.pop(context);
                          },
                        )
                      ],
                    )
                  ],
                )),
          );
        });
  }

  //dialog email
  Future<String> email(BuildContext context, String email) {
    TextEditingController customController;
    if (email1 == '') {
      customController = new TextEditingController(text: "$email");
    } else {
      String _email = email1;
      customController = new TextEditingController(text: "$_email");
    }

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
            content: Container(
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("Email adresa",
                            style: TextStyle(
                                fontSize: 24,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .color))
                      ],
                    ),
                    SizedBox(height: 5),
                    TextField(
                      controller: customController,
                      decoration: InputDecoration(
                        hoverColor: Colors.grey,
                        labelStyle: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1.color,
                            fontStyle: FontStyle.italic),
                        fillColor: Colors.black,
                        contentPadding: const EdgeInsets.all(10.0),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        MaterialButton(
                          child: Text(
                            "Izmeni",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .color),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            var check = customController.text;
                            print(check);

                            if (emailRegex.hasMatch(check)) {
                              setState(() {
                                email1 = check;
                              });
                              Navigator.of(context).pop();
                            } else {
                              check = "Greska";
                              print(check);
                              Navigator.of(context).pop(check.toString());
                            }
                          },
                        ),
                        SizedBox(width: 50),
                        FlatButton(
                          child: Text(
                            "Otkaži",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .color),
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedOption = 0;
                            });
                            Navigator.pop(context);
                          },
                        )
                      ],
                    )
                  ],
                )),
          );
        });
  }

  //dialog city
  Future<String> city(BuildContext context, String cityName) {
    TextEditingController customController;
    if (city1 == '') {
      customController = new TextEditingController(text: "$cityName");
    } else {
      String _cityName = city1;
      customController = new TextEditingController(text: "$_cityName");
    }

    return showDialog(
        context: context,
        child: new MyDialog(
            onValueChange: _onValueChange,
            initialValue: _selectedId,
            cities: _dropdownMenuItems,
            edit: this,
            user: widget.user));
  }

  Future<String> phone(BuildContext context, String phone) {
    TextEditingController customController;
    if (number1 == '') {
      customController = new TextEditingController(text: "$phone");
    } else {
      String _phone = number1;
      customController = new TextEditingController(text: "$_phone");
    }

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
            content: Container(
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("Kontakt telefon",
                            style: TextStyle(
                                fontSize: 24,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .color))
                      ],
                    ),
                    SizedBox(height: 5),
                    TextField(
                      controller: customController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hoverColor: Colors.grey,
                        labelStyle: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1.color),
                        fillColor: Colors.black,
                        contentPadding: const EdgeInsets.all(10.0),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        MaterialButton(
                          child: Text(
                            "Izmeni",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .color),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            var check = customController.text;
                            print(check);

                            if (mobRegex.hasMatch(check)) {
                              setState(() {
                                number1 = check;
                              });
                              Navigator.of(context).pop();
                            } else {
                              check = "Greska";
                              print(check);
                              Navigator.of(context).pop(check.toString());
                            }
                          },
                        ),
                        SizedBox(width: 50),
                        FlatButton(
                          child: Text(
                            "Otkaži",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .color),
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedOption = 0;
                            });
                            Navigator.pop(context);
                          },
                        )
                      ],
                    )
                  ],
                )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Theme.of(context).textTheme.bodyText1.color, //change your color here
          ),
          elevation: 8,
          backgroundColor: MyApp.ind == 0 ? Colors.white :  Theme.of(context).copyWith().backgroundColor,
          title: Text('Podešavanja profila',
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1.color)),
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(10),
                width: double.infinity,
                height: 5,
              ),

              //photo
              Card(
                  child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      editProfilePhotoo(context);
                    },
                    child: CircleImage(
                      serverURLPhoto + user.photo,
                      imageSize: 90.0,
                      whiteMargin: 2.0,
                      imageMargin: 20.0,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      editProfilePhotoo(context);
                    },
                    child: Text(
                      "Promeni profilnu sliku",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyText1.color),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              )),

              //first name and last name
              Container(
                  child: Card(
                child: ListTile(
                  leading: Icon(Icons.account_circle,
                      color: Theme.of(context).copyWith().iconTheme.color),
                  title: Text('Ime i prezime',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color,
                        fontWeight: (_selectedOption == index - 1)
                            ? FontWeight.bold
                            : FontWeight.normal,
                      )),
                  subtitle: Text(
                      firstName == ''
                          ? user.firstName + ' ' + user.lastName
                          : firstName + " " + lastName == ''
                              ? user.lastName
                              : firstName + ' ' + lastName,
                      style: TextStyle(
                          color: _selectedOption == index - 1
                              ? Theme.of(context).textTheme.bodyText1.color
                              : Colors.grey)),
                  selected: _selectedOption == index - 1,
                  onTap: () {
                    setState(() {
                      _selectedOption = index - 1;
                    });

                    firstLastName(context, user.firstName + " " + user.lastName)
                        /*.then((onValue) {
                      String newName = "$onValue";
                      SnackBar snackName = SnackBar(content: Text(newName));
                      Scaffold.of(context).showSnackBar(snackName);
                    })*/
                        ;
                  },
                ),
              )),

              //username
              Card(
                child: ListTile(
                  leading: Icon(Icons.account_circle,
                      color: Theme.of(context).copyWith().iconTheme.color),
                  title: Text('Korisničko ime',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color,
                        fontWeight: _selectedOption == index - 2
                            ? FontWeight.bold
                            : FontWeight.normal,
                      )),
                  subtitle: Text(
                    username1 == '' ? user.username : username1,
                    style: TextStyle(
                        color: _selectedOption == index - 2
                            ? Theme.of(context).textTheme.bodyText1.color
                            : Colors.grey),
                  ),
                  selected: _selectedOption == index - 2,
                  onTap: () {
                    setState(() {
                      _selectedOption = index - 2;
                    });

                    username(context,
                            user.username) /*.then((onValue) {
                      String newUserame = "$onValue";
                      SnackBar snackUsername =
                          SnackBar(content: Text(newUserame));
                      Scaffold.of(context).showSnackBar(snackUsername);
                    })*/
                        ;
                  },
                ),
              ),

              //password
              Card(
                child: ListTile(
                  leading: Icon(Icons.lock_open,
                      color: Theme.of(context).copyWith().iconTheme.color),
                  title: Text('Šifra',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color,
                        fontWeight: _selectedOption == index - 3
                            ? FontWeight.bold
                            : FontWeight.normal,
                      )),
                  selected: _selectedOption == index - 3,
                  onTap: () {
                    setState(() {
                      _selectedOption = index - 3;
                    });
                    password(context,
                            user.password) /*.then((onValue) {
                      String newPassword = "$onValue";
                      SnackBar snackPassword =
                          SnackBar(content: Text(newPassword));
                      Scaffold.of(context).showSnackBar(snackPassword);
                    })*/
                        ;
                  },
                ),
              ),

              //email
              Card(
                child: ListTile(
                  leading: Icon(Icons.email,
                      color: Theme.of(context).copyWith().iconTheme.color),
                  title: Text('Email',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color,
                        fontWeight: _selectedOption == index - 4
                            ? FontWeight.bold
                            : FontWeight.normal,
                      )),
                  subtitle: Text(email1 == '' ? user.email : email1,
                      style: TextStyle(
                          color: _selectedOption == index - 4
                              ? Theme.of(context).textTheme.bodyText1.color
                              : Colors.grey)),
                  selected: _selectedOption == index - 4,
                  onTap: () {
                    setState(() {
                      _selectedOption = index - 4;
                    });

                    email(context,
                            user.email) /*.then((onValue) {
                      String newEmail = "$onValue";
                      SnackBar snackEmail = SnackBar(content: Text(newEmail));
                      Scaffold.of(context).showSnackBar(snackEmail);
                    })*/
                        ;
                  },
                ),
              ),

              //mobile number
              Card(
                child: ListTile(
                  leading: Icon(Icons.phone_android,
                      color: Theme.of(context).copyWith().iconTheme.color),
                  title: Text('Telefon',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color,
                        fontWeight: _selectedOption == index - 5
                            ? FontWeight.bold
                            : FontWeight.normal,
                      )),
                  subtitle: Text(number1 == '' ? user.phone : number1,
                      style: TextStyle(
                          color: _selectedOption == index - 5
                              ? Theme.of(context).textTheme.bodyText1.color
                              : Colors.grey)),
                  selected: _selectedOption == index - 5,
                  onTap: () {
                    setState(() {
                      _selectedOption = index - 5;
                    });

                    phone(context,
                            user.phone) /*.then((onValue) {
                      String newPhoneNumber = "$onValue";
                      SnackBar snackPhone =
                          SnackBar(content: Text(newPhoneNumber));
                      Scaffold.of(context).showSnackBar(snackPhone);
                    })*/
                        ;
                  },
                ),
              ),

              SizedBox(height: 10),

              //city
              Card(
                child: ListTile(
                  leading: Icon(Icons.location_city,
                      color: Theme.of(context).copyWith().iconTheme.color),
                  title: Text('Grad',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color,
                        fontWeight: _selectedOption == index - 6
                            ? FontWeight.bold
                            : FontWeight.normal,
                      )),
                  subtitle: Text(city1 == '' ? user.cityName : city1,
                      style: TextStyle(
                          color: _selectedOption == index - 6
                              ? Theme.of(context).textTheme.bodyText1.color
                              : Colors.grey)),
                  selected: _selectedOption == index - 6,
                  onTap: () {
                    setState(() {
                      _selectedOption = index - 6;
                    });

                    city(context,
                            user.cityName) /*.then((onValue) {
                      String newName = "$onValue";
                      SnackBar snackName = SnackBar(content: Text(newName));
                      Scaffold.of(context).showSnackBar(snackName);
                    })*/
                        ;
                  },
                ),
              ),

              SizedBox(height: 20),

              Center(
                  child: MaterialButton(
                minWidth: 200.0,
                height: 50.0,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(50.0),
                    side: BorderSide(color: Colors.transparent)),
                onPressed: () async {
                  if (firstName == '') {
                    firstName = user.firstName;
                  }

                  if (lastName == '') {
                    lastName = user.lastName;
                  }

                  if (username1 == '') {
                    username1 = user.username;
                  }

                  if (password1 == '') {
                    password1 = user.password;
                  }

                  if (email1 == '') {
                    email1 = user.email;
                  }

                  if (number1 == '') {
                    number1 = user.phone;
                  }

                  if (city1 == '') {
                    city1 = user.cityName;
                  }

                  if (password1 != '' && oldPassword != '') {
                    var pom = utf8.encode(password1);
                    newPass = sha1.convert(pom);

                    var pom2 = utf8.encode(oldPassword);
                    oldPass = sha1.convert(pom2);
                    APIServices.jwtOrEmpty().then((res) {
                      String jwt;
                      setState(() {
                        jwt = res;
                      });
                      if (res != null) {
                        APIServices.editUserPassword(jwt, user.id,
                                oldPass.toString(), newPass.toString())
                            .then((response) {
                          if (response.statusCode == 200) {
                            showAlertDialog(context);
                          }
                        });
                      }
                    });
                  }
                  if (firstName != '' ||
                      lastName != '' ||
                      username1 != '' ||
                      email1 != '' ||
                      number1 != '' ||
                      city1 != '') {
                    APIServices.jwtOrEmpty().then((res) {
                      String jwt;
                      setState(() {
                        jwt = res;
                      });
                      if (res != null) {
                        APIServices.editUser(jwt, user.id, firstName, lastName,
                                username1, email1, number1, city1)
                            .then((response) {
                          if (response.statusCode == 200 ||
                              password1 == '' && oldPassword == '') {
                            showAlertDialog(context);
                          }
                        });
                      }
                    });
                  }
                },
                color: Colors.green[800],
                child: Text(
                  'Sačuvaj',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ))
            ],
          ),
        ));
  }
}

class MyDialog extends StatefulWidget {
  const MyDialog(
      {this.onValueChange,
      this.initialValue,
      this.cities,
      this.edit,
      this.user});

  final EditProfile edit;
  final User user;
  final City initialValue;
  final void Function(City) onValueChange;
  final List<DropdownMenuItem<City>> cities;

  @override
  State createState() => new MyDialogState();
}

class MyDialogState extends State<MyDialog> {
  City _selectedId;
  TextEditingController customController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedId = widget.initialValue;
  }

  Widget build(BuildContext context) {
    return new AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      content: Container(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Grad",
                      style: TextStyle(
                          fontSize: 24,
                          color: Theme.of(context).textTheme.bodyText1.color))
                ],
              ),
              SizedBox(height: 5),
              Center(
                child: new DropdownButton<City>(
                    value: _selectedId,
                    onChanged: (City value) {
                      setState(() {
                        _selectedId = value;
                        print(_selectedId.name);
                      });
                      widget.onValueChange(value);
                    },
                    items: widget.cities),
              ),
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  MaterialButton(
                    child: Text(
                      "Izmeni",
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1.color),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.edit.city1 = _selectedId.name;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  SizedBox(width: 50),
                  FlatButton(
                    child: Text(
                      "Otkaži",
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1.color),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              )
            ],
          )),
    );
  }
}
