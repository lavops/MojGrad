import 'package:flutter/material.dart';
import 'package:frontend/models/user.dart';
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

  EditProfile(User user1) {
    user = user1;
  }

  final Color green = Color(0xFF1E8161);
  int _selectedOption = 0;
  int index = 6;
  String _flname, _username, _password, _email, _number;
  String wrongRegText = "";

  final flNameRegex = RegExp(r'^[a-zA-Z\s]{1,}$');
  final mobRegex = RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');
  final passRegex = RegExp(r'[a-zA-Z0-9.!]{6,}');
  final emailRegex = RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}');
  final usernameRegex = RegExp(r'^[a-z0-9]{1,1}[._a-z0-9]{1,}');

  //dialog name
  Future<String> firstLastName(BuildContext context, String name) {
    TextEditingController customController = new TextEditingController(text: "$name");

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),

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
                        Text("Ime i prezime", style: TextStyle(fontSize: 24))
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

                    InkWell(
                      child: Container(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        decoration: BoxDecoration(
                          color: green,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16)),
                        ),
                        child: Text(
                          "Izmeni",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      onTap: () {
                        var check = customController.text;
                        print(check);

                        if (flNameRegex.hasMatch(check)) {
                          var array = check.split(" ");
                          user.firstName = array[0];
                          user.lastName = array[1];
                          print(check);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditProfilePage(user)),
                          );
                        } 
                        else {
                          check = "Greska";
                          print(check);
                          Navigator.of(context).pop(check.toString());
                        }
                      },
                    )
                  ],
                )),
          );
        });
  }

  //dialog username
  Future<String> username(BuildContext context, String username) {
    TextEditingController customController = new TextEditingController(text: "$username");

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),

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
                            style: TextStyle(fontSize: 24))
                      ],
                    ),

                    SizedBox(height: 5,),

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

                    InkWell(
                      child: Container(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        decoration: BoxDecoration(
                          color: green,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16)),
                        ),
                        child: Text(
                          "Izmeni",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      onTap: () {
                        var check = customController.text;

                        if (usernameRegex.hasMatch(check)) {
                          user.username = check;
                          print(check);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditProfilePage(user)),
                          );
                        }
                        else {
                          check = "Greska";
                          print(check);
                          Navigator.of(context).pop(check.toString());
                        }
                      },
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),

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
                        Text("Šifra", style: TextStyle(fontSize: 24))
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

                    InkWell(
                      child: Container(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        decoration: BoxDecoration(
                          color: green,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16)),
                        ),
                        child: Text(
                          "Izmeni",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      onTap: () {
                        var temp = customController.text;
                        var check = customController2.text;
                        var checkAgain = customController3.text;

                        print(temp);
                        print(myPassword);

                        if (temp == myPassword) {
                          if (check == checkAgain) {
                            if (passRegex.hasMatch(check)) {
                              user.password = check;
                              print(check);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>EditProfilePage(user)),
                              );
                            } else {
                              check = "Greska regEx";
                              print(check);
                              Navigator.of(context).pop(check.toString());
                            }
                          } else {
                            print("Nova i ponovljena nisu iste");
                          }
                        } else {
                          print("Trenutna nije dobra");
                        }
                      },
                    )
                  ],
                )),
          );
        });
  }

  //dialog email
  Future<String> email(BuildContext context, String email) {
    TextEditingController customController = new TextEditingController(text: "$email");
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),

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
                            style: TextStyle(fontSize: 24))
                      ],
                    ),

                    SizedBox( height: 5),

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

                    InkWell(
                      child: Container(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        decoration: BoxDecoration(
                          color: green,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16)),
                        ),
                        child: Text(
                          "Izmeni",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      onTap: () {
                        var check = customController.text;

                        if (emailRegex.hasMatch(check)) {
                          user.email = check;
                          print(check);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditProfilePage(user)),
                          );
                        }
                        else {
                          check = "Greska";
                          print(check);
                          Navigator.of(context).pop(check.toString());
                        }
                      },
                    )
                  ],
                )),
          );
        });
  }

  //dialog phone
  Future<String> phone(BuildContext context, String phone) {
    TextEditingController customController = new TextEditingController(text: "$phone");

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),

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
                            style: TextStyle(fontSize: 24))
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

                    InkWell(
                      child: Container(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        decoration: BoxDecoration(
                          color: green,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16)),
                        ),
                        child: Text(
                          "Izmeni",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      onTap: () {
                        var check = customController.text;
                        print(check);

                        if(mobRegex.hasMatch(check)) {
                          user.phone = check;
                          print(check);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditProfilePage(user)),
                          );
                        }
                        else {
                          check = "Greska";
                          print(check);
                          Navigator.of(context).pop(check.toString());
                        }
                      },
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
        title: Text('Podešavanja', style: TextStyle(color: Colors.black)),
      ),

      body: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(10),
            width: double.infinity,
            height: 36,
          ),

          //first name and last name
          Card(
            child: ListTile(
              leading: Icon(Icons.account_circle, color: Colors.black),
              title: Text('Ime i prezime',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: _selectedOption == index - 1 ? FontWeight.bold : FontWeight.normal,
                  )),
              subtitle: Text(user.firstName + " " + user.lastName,
                  style: TextStyle(
                      color: _selectedOption == index - 1 ? Colors.black : Colors.grey)),
              selected: _selectedOption == index - 1,
              onTap: () {
                setState(() {
                  _selectedOption = index - 1;
                });

                firstLastName(context, user.firstName+" "+user.lastName).then((onValue) {
                  String newName = "$onValue";
                  SnackBar snackName = SnackBar(content: Text(newName));
                  Scaffold.of(context).showSnackBar(snackName);
                });
              },
            ),
          ),

          //username
          Card(
            child: ListTile(
              leading: Icon(Icons.account_circle, color: Colors.black),
              title: Text('Korisničko ime',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: _selectedOption == index - 2 ? FontWeight.bold : FontWeight.normal,
                  )),
              subtitle: Text(
                user.username,
                style: TextStyle(
                    color: _selectedOption == index - 2 ? Colors.black : Colors.grey),
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
                    fontWeight: _selectedOption == index - 3 ? FontWeight.bold : FontWeight.normal,
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
              subtitle: Text(user.email,
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
              subtitle: Text(user.phone,
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
              side: BorderSide(color: Colors.transparent)
            ),
            onPressed: () async {
              var res = await APIServices.editUser(user);
            },
            color: green,
            child: Text(
              'Sacuvaj',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        )
        ],
      ),
    );
  }
}
