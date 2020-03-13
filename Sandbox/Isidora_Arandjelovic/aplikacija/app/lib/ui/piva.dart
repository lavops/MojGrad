import 'package:app/models/api.services.dart';
import 'package:app/models/pivo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class Piva extends StatefulWidget {
  Piva({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _PivaState();
  }
}

class _PivaState extends State<Piva> {
  List<Pivo> pivo;

  getPivo() {
    APIServices.fetchUser().then(
      (response) {
        Iterable list = json.decode(response.body);
        List<Pivo> userList = List<Pivo>();
        userList = list.map((model) => Pivo.fromObject(model)).toList();
        setState(
          () {
            pivo = userList;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    getPivo();
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Container(
          height: 150.0,
          child: ListView.builder(
            itemCount: pivo.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.white,
                elevation: 4.0,
                child: ListTile(
                  title: ListTile(
                    title: Text(pivo[index].naziv),
                    onTap: null,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}