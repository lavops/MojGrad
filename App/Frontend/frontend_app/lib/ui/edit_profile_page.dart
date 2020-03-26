import 'package:flutter/material.dart';
import 'package:frontend/models/user.dart';

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
      /*
      DRUGI IZGLED ALI JE BEZVEZE
      body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                    //margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    margin: const EdgeInsets.fromLTRB(32, 8, 32, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    color: green,
                    child: ListTile(
                      onTap: () {}, //open edit profile
                      title: Text(
                        user.username,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      leading:
                          Icon(Icons.account_circle, color: Colors.black, size: 30),
                      trailing: Icon(Icons.edit, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Text('Promeni šifru'),
                            leading: Icon(Icons.lock_outline, color: green),
                            trailing: Icon(Icons.keyboard_arrow_right,
                                color: Colors.black),
                            onTap: () {}, //open change password
                          ),
                          ListTile(
                            title: Text('Promeni email'),
                            leading: Icon(Icons.email, color: green),
                            trailing: Icon(Icons.keyboard_arrow_right,
                                color: Colors.black),
                            onTap: () {}, //open change email
                          ),
                          ListTile(
                            title: Text('Promeni kontakt telefon'),
                            leading: Icon(Icons.phone_android, color: green),
                            trailing: Icon(Icons.keyboard_arrow_right,
                                color: Colors.black),
                            onTap: () {}, //open change phone
                          )
                        ],
                      )),
                ],
              ),
            )*/
      body: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(10),
            width: double.infinity,
            height: 36,
            /*decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: _selectedOption == index - 1
                  ? Border.all(color: Colors.black26)
                  : null,
            ),*/
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.account_circle, color: Colors.black),
              title: Text('Ime i prezime',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: _selectedOption == index - 1
                        ? FontWeight.bold
                        : FontWeight.normal,
                  )),
              subtitle: Text(user.firstName + " " + user.lastName,
                  style: TextStyle(
                      color: _selectedOption == index - 1
                          ? Colors.black
                          : Colors.grey)),
              selected: _selectedOption == index - 1,
              onTap: () {
                setState(() {
                  _selectedOption = index - 1;
                });
              },
            ),
          ),
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
                user.username,
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
              },
            ),
          ),
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
              /*subtitle: Text(user.username,
                  style: TextStyle(
                      color: _selectedOption == index - 3
                          ? Colors.black
                          : Colors.grey)),*/
              selected: _selectedOption == index - 3,
              onTap: () {
                setState(() {
                  _selectedOption = index - 3;
                });
              },
            ),
          ),
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
              },
            ),
          ),
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
              },
            ),
          ),
          /*
          ZA GRAD AKO SE MENJA
          Card(
            child: ListTile(
              leading: Icon(Icons.phone_android, color: Colors.black),
              title: Text('Telefon', style: TextStyle(color: Colors.black)),
              subtitle: Text(user.phone,
                  style: TextStyle(
                      color: _selectedOption == index - 6
                          ? Colors.black
                          : Colors.grey)),
              selected: _selectedOption == index - 6,
              onTap: () {
                setState(() {
                  _selectedOption = index - 6;
                });
              },
            ),
          )*/
        ],
      ),
    );
  }
}
