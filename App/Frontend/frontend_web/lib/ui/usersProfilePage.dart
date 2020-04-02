import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_web/models/user.dart';
import 'package:frontend_web/services/api.services.dart';
import 'dart:convert';


List<User> listUsers;

getUsers() {
  APIServices.getUsers().then((res) {
    Iterable list = json.decode(res.body);
    List<User> listUsers = List<User>();
    listUsers = list.map((model) => User.fromObject(model)).toList();
    return listUsers;
  });
}

ListView _usersListView(data) {
  return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _tile(data[index].username, data[index].firstName, data[index].id);
      });
}

ListTile _tile(String title, subtitle, id) => ListTile(
  title: Text(title,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 20,
      )
  ),
  subtitle: Text(subtitle,
  style: TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 20,
  )
  ),
  trailing: Icon(Icons.delete_forever),
  onTap: () {}, // delete function
);


class UsersProfilePage extends StatefulWidget {
  @override
  _UsersProfilePageState createState() => new _UsersProfilePageState();
}

class _UsersProfilePageState extends State<UsersProfilePage> {
  @override
  Widget build(BuildContext context) {
   return MaterialApp(
     title: 'All users',
     theme: ThemeData(
       primarySwatch: Colors.lightGreen,
     ),
     home: Scaffold(
       appBar: AppBar(
         title: Text('All users')
       ),
       body: Center(
         child: FutureBuilder(
           future: getUsers(),
           builder: (context, snapshot) {
             if (snapshot.hasData) {
               List<User> data = snapshot.data;
               return _usersListView(data);
             }
             else if (snapshot.hasError) {
               return Text("${snapshot.error}");
             }
             return CircularProgressIndicator();
           }
         ),
       ),
     ),
   )
  }
}
