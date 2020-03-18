import 'package:flutter/material.dart';
import 'package:frontend/models/categories.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  
  int _vrstaObjave = 1;
  int _problemResava = 1;
  int _kategorijaProblema = 1;
  List<Category> _categories = Category.getCategories();
  Category category;
  @override
  Widget build(BuildContext context) {
    
    final vrstaObjave = Row(
      children: <Widget>[
        Text("Problem"),
        Radio(
          value: 1,
          groupValue: _vrstaObjave,
          onChanged: (int value) {
            setState(() {
              _vrstaObjave = value;
            });
          },
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
        ),
      ],
    );

    final problemResava = Row(
      children: <Widget>[
        Text("Resicu sam problem"),
        Radio(
          value: 1,
          groupValue: _problemResava,
          onChanged: (int value) {
            setState(() {
              _problemResava = value;
            });
          },
        ),
        Text("Neka neko drugi resi"),
        Radio(
          value: 2,
          groupValue: _problemResava,
          onChanged: (int value) {
            setState(() {
              _problemResava = value;
            });
          },
        ),
      ],
    );

    final _dropDown = DropdownButton<Category>(
      hint:  Text("Izaberi"),
      value: category,
      onChanged: (Category Value) {
        setState(() {
          category = Value;
        });
      },
      items: _categories.map((Category option) {
        return  DropdownMenuItem<Category>(
          value: option,
          child: Text(option.name),
        );
      }).toList(),
    );
    
    return Center(
      child:Container(
        width: 400,
        child: Column(
          children: <Widget>[
            Align(alignment: Alignment.topLeft, child: Text("Izaberi vrstu objave: ")),
            vrstaObjave,
            if(_vrstaObjave == 1)...[
              Align(alignment: Alignment.topLeft, child: Text("Ko ce da resi problem: ")),
              problemResava,
              Align(alignment: Alignment.topLeft, child: Text("Izaberi kategoriju: ")),
              _dropDown
            ],
          ],
        ),
      )
    );
  }
}