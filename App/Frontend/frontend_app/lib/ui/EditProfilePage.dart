import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/images.dart';
import 'package:frontend/ui/UserProfilePage.dart';
import 'package:frontend/widgets/circleImageWidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
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

  int _selectedOption = 0;
  int index = 6;
  String firstName = '',
      lastName = '',
      username1 = '',
      password1 = '',
      email1 = '',
      number1 = '',
      oldPassword = '';
  var newPass, oldPass;
  int ind = 0;

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
        style: TextStyle(color: Colors.green[800]),
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserProfilePage(user1)),
                  );
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
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserProfilePage(user)),
        );
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
            title: Text("Promena profilne slike"),
            content: Container(
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton.icon(
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
                            icon: Icon(Icons.camera_alt),
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(50),
                            ),
                          ),
                          flex: 10,
                        ),
                        Expanded(
                          child: Container( color: Colors.white,),
                          flex: 1,
                        ),
                        Expanded(
                          child: RaisedButton.icon(
                            label: Flexible(
                              child: Text('Galerija'),
                            ),
                            onPressed: () {
                              _openGalery().then((res) {
                                setState(() {
                                  imageFilee = res;
                                });
                              });
                            },
                            icon: Icon(Icons.photo_library),
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
              closeButton,
              okButton,
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
      title: Text("Izmena podataka"),
      content: Text("Uspešno ste izmenili podatke."),
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
    TextEditingController customController =
        new TextEditingController(text: "$name");

    return showDialog(
        context: context,
        //barrierDismissible: false, // user must tap button!
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
                        Text("Ime i prezime", style: TextStyle(fontSize: 24, color: Colors.black))
                      ],
                    ),
                    SizedBox(height: 5),
                    TextField(
                      controller: customController,
                      decoration: InputDecoration(
                        hoverColor: Colors.grey,
                        labelStyle: TextStyle(color: Colors.black87),
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
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            var check = customController.text;
                            print(check);

                            if (flNameRegex.hasMatch(check)) {
                              var array = check.split(" ");

                              print(check);

                              setState(() {
                                firstName = array[0];
                                lastName = array[1];
                              });
                              Navigator.of(context).pop(user);
                            } else {
                              check = "Greska";
                              print(check);
                              Navigator.of(context).pop(check.toString());
                            }
                          },
                        ),
                        SizedBox(width: 50),
                        MaterialButton(
                          child: Text(
                            "Otkaži",
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    )
                  ],
                )),
          );
        });
  }

  //dialog username
  Future<String> username(BuildContext context, String username) {
    TextEditingController customController =
        new TextEditingController(text: "$username");

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
                        Text("Korisničko ime", style: TextStyle(fontSize: 24, color: Colors.black))
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: customController,
                      decoration: InputDecoration(
                        hoverColor: Colors.grey,
                        labelStyle: TextStyle(color: Colors.black87),
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
                            style: TextStyle(color: Colors.black),
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
                        MaterialButton(
                          child: Text(
                            "Otkaži",
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
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
                        Text("Šifra", style: TextStyle(fontSize: 24, color: Colors.black))
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
                        hintStyle: TextStyle(color: Colors.black),
                        labelStyle: TextStyle(
                            color: Colors.black87, fontStyle: FontStyle.italic),
                        fillColor: Colors.black,
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
                            color: Colors.black87, fontStyle: FontStyle.italic),
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
                            color: Colors.black87, fontStyle: FontStyle.italic),
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
                            style: TextStyle(color: Colors.black),
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
                        MaterialButton(
                          child: Text(
                            "Otkaži",
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    )
                  ],
                )),
          );
        });
  }

  //dialog email
  Future<String> email(BuildContext context, String email) {
    TextEditingController customController =
        new TextEditingController(text: "$email");
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
                        Text("Email adresa", style: TextStyle(fontSize: 24, color: Colors.black))
                      ],
                    ),
                    SizedBox(height: 5),
                    TextField(
                      controller: customController,
                      decoration: InputDecoration(
                        hoverColor: Colors.grey,
                        labelStyle: TextStyle(color: Colors.black87),
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
                            style: TextStyle(color: Colors.black),
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
                        MaterialButton(
                          child: Text(
                            "Otkaži",
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    )
                  ],
                )),
          );
        });
  }

  //dialog phone
  Future<String> phone(BuildContext context, String phone) {
    TextEditingController customController =
        new TextEditingController(text: "$phone");

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
                        Text("Kontakt telefon", style: TextStyle(fontSize: 24, color: Colors.black))
                      ],
                    ),
                    SizedBox(height: 5),
                    TextField(
                      controller: customController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hoverColor: Colors.grey,
                        labelStyle: TextStyle(color: Colors.black87),
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
                            style: TextStyle(color: Colors.black),
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
                        MaterialButton(
                          child: Text(
                            "Otkaži",
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
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
        elevation: 8,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text('Podešavanja profila', style: TextStyle(color: Colors.black)),
      ),
      body: Container(
          child: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(10),
            width: double.infinity,
            color: Colors.white,
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
                      fontWeight: FontWeight.bold, color: Colors.blue),
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
                leading: Icon(Icons.account_circle, color: Colors.black),
                title: Text('Ime i prezime',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: _selectedOption == index - 1
                          ? FontWeight.bold
                          : FontWeight.normal,
                    )),
                subtitle: Text(
                    firstName == ''
                        ? user.firstName
                        : firstName + " " + lastName == ''
                            ? user.lastName
                            : lastName,
                    style: TextStyle(
                        color: _selectedOption == index - 1
                            ? Colors.black
                            : Colors.grey)),
                selected: _selectedOption == index - 1,
                onTap: () {
                  setState(() {
                    _selectedOption = index - 1;
                  });

                  firstLastName(context, user.firstName + " " + user.lastName)
                      .then((onValue) {
                    String newName = "$onValue";
                    SnackBar snackName = SnackBar(content: Text(newName));
                    Scaffold.of(context).showSnackBar(snackName);
                  });
                },
              ),
            )
          ),

          //username
          Card(
            child: ListTile(
              leading: Icon(Icons.account_circle, color: Colors.black),
              title: Text('Korisničko ime',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: _selectedOption == index - 2
                        ? FontWeight.bold
                        : FontWeight.normal,
                  )),
              subtitle: Text(
                username1 == '' ? user.username : username1,
                style: TextStyle(
                    color: _selectedOption == index - 2
                        ? Colors.black
                        : Colors.grey),
              ),
              selected: _selectedOption == index - 2,
              onTap: () {
                setState(() {
                  _selectedOption = index - 2;
                });

                username(context, user.username).then((onValue) {
                  String newUserame = "$onValue";
                  SnackBar snackUsername = SnackBar(content: Text(newUserame));
                  Scaffold.of(context).showSnackBar(snackUsername);
                });
              },
            ),
          ),

          //password
          Card(
            child: ListTile(
              leading: Icon(Icons.lock_open, color: Colors.black),
              title: Text('Šifra',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: _selectedOption == index - 3
                        ? FontWeight.bold
                        : FontWeight.normal,
                  )),
              selected: _selectedOption == index - 3,
              onTap: () {
                setState(() {
                  _selectedOption = index - 3;
                });
                password(context, user.password).then((onValue) {
                  String newPassword = "$onValue";
                  SnackBar snackPassword = SnackBar(content: Text(newPassword));
                  Scaffold.of(context).showSnackBar(snackPassword);
                });
              },
            ),
          ),

          //email
          Card(
            child: ListTile(
              leading: Icon(Icons.email, color: Colors.black),
              title: Text('Email',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: _selectedOption == index - 4
                        ? FontWeight.bold
                        : FontWeight.normal,
                  )),
              subtitle: Text(email1 == '' ? user.email : email1,
                  style: TextStyle(
                      color: _selectedOption == index - 4
                          ? Colors.black
                          : Colors.grey)),
              selected: _selectedOption == index - 4,
              onTap: () {
                setState(() {
                  _selectedOption = index - 4;
                });

                email(context, user.email).then((onValue) {
                  String newEmail = "$onValue";
                  SnackBar snackEmail = SnackBar(content: Text(newEmail));
                  Scaffold.of(context).showSnackBar(snackEmail);
                });
              },
            ),
          ),

          //mobile number
          Card(
            child: ListTile(
              leading: Icon(Icons.phone_android, color: Colors.black),
              title: Text('Telefon',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: _selectedOption == index - 5
                        ? FontWeight.bold
                        : FontWeight.normal,
                  )),
              subtitle: Text(number1 == '' ? user.phone : number1,
                  style: TextStyle(
                      color: _selectedOption == index - 5
                          ? Colors.black
                          : Colors.grey)),
              selected: _selectedOption == index - 5,
              onTap: () {
                setState(() {
                  _selectedOption = index - 5;
                });

                phone(context, user.phone).then((onValue) {
                  String newPhoneNumber = "$onValue";
                  SnackBar snackPhone = SnackBar(content: Text(newPhoneNumber));
                  Scaffold.of(context).showSnackBar(snackPhone);
                });
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
                    APIServices.editUserPassword(jwt, user.id, oldPass.toString(), newPass.toString())
                        .then((response) {
                      if (response.statusCode == 200) {
                        showAlertDialog(context);
                      }
                    });
                  }
                });
              }
              if (firstName != '' || lastName != '' ||  username1 != '' || email1 != '' ||   number1 != '') {
                APIServices.jwtOrEmpty().then((res) {
                  String jwt;
                  setState(() {
                    jwt = res;
                  });
                  if (res != null) {
                    APIServices.editUser(jwt, user.id, firstName, lastName, username1, email1, number1)
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
              'Sacuvaj',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ))
        ],
      ),
      )      
    );
  }
}
