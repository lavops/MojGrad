
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:probnaapp/models/Knjiga.dart';
import 'package:probnaapp/services/api.services.dart';

class Podaci extends StatefulWidget{

  Podaci({Key key}):super(key: key);
  @override
  _PodaciState createState() => _PodaciState();

}

class _PodaciState extends State<Podaci>{
 List<Knjiga> knjige;

  getKnjige(){
    APIServices.dajKnjige().then((res){
      Iterable list=json.decode(res.body);
      List<Knjiga> listaKnjiga= List<Knjiga>();
      listaKnjiga=list.map((model)=> Knjiga.fromObject(model)).toList();

      setState(() {
        knjige=listaKnjiga;
      });
    });
  }
 
  @override
  Widget build(BuildContext context) {
    getKnjige();
    return Scaffold(
      appBar: AppBar(
        title: Text("Spisak dostupnih knjiga"),
        backgroundColor: Colors.blueGrey,
      ),
      body:knjige==null? Center(child: Text("Trenutno nema knjiga"),) : 
        ListView.builder(
        itemCount: knjige.length,
        itemBuilder:(context,index){
          return Card(
            color: Colors.grey,
            elevation: 2.0,
            child: ListTile(
              title: ListTile(title: Text(knjige[index].naziv ),
              onTap: (){
                showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
                  title: Text("Podaci"),
                  content: Row(
                  children: [
                    Expanded(child: 
                    Column(
                      children:[
                        Text("Naslov: "+knjige[index].naziv+""),
                        Text("Autor: "+knjige[index].autor+""),
                        Text("Cena: "+knjige[index].cena.toString()+"din"),
                      ],
                    ),
                    ),
                  ],
                  ), 
                  actions: [
                    FlatButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/glavna');
                      },
                    ),
                  ]);
              }
               );
        
              },
              ),
            ),
          );
        } , 
        ),
    );
  }

}