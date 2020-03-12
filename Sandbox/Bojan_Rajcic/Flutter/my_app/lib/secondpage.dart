
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:myapp/user.dart';
import 'package:http/http.dart' as http;

Future<List<User>> fetchUsers() async {
  final response =
  await http.get('http://10.0.2.2:5001/api/Users');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON.
    List<User> list = parseUsers(response.body);
    return list;
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load users.');
  }
}

List<User> parseUsers(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<User>((item) => User.fromJson(item)).toList();
}


ListView _usersListView(data) {
  return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _tile(data[index].name);
      });
}

ListTile _tile(String title) => ListTile(
  title: Text(title,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 20,
      )),
);


class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Users',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Users'),
        ),
        body: Center(
          child: FutureBuilder(
            future: fetchUsers(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<User> data = snapshot.data;
                return _usersListView(data);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

}
