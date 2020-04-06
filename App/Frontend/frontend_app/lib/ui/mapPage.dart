import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:frontend/models/fullPost.dart';
import 'package:frontend/services/api.services.dart';
import 'package:latlong/latlong.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage>{


  List<FullPost> listPosts;

  _getPosts() {
    APIServices.getUnsolvedPosts().then((res) {
      Iterable list = json.decode(res.body);
      List<FullPost> listP = List<FullPost>();
      listP = list.map((model) => FullPost.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          listPosts = listP;
        });
      }
    });
  }

  @override
  void initState() {
    _getPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context){

    List<Marker> markers = [];
    if(listPosts != null)
      for (var i = 0; i < listPosts.length; i++) {
        markers.add(new Marker(
          point: new LatLng(listPosts[i].latitude, listPosts[i].longitude),
          builder: (ctx) =>
          new Container(
            child: IconButton(
              icon: Icon(Icons.location_on),
              iconSize: 40.0,
              color: Colors.red,
              onPressed: (){
                showBottomSheet(
                  context: ctx,
                  builder: (ctx){
                    return Center(child: Text("Text"),);
                  },
                );
              },
            )
          ),
        ),);
      }

    return Scaffold(
      body: FlutterMap(
        options: new MapOptions(
          center: new LatLng(44.0126575, 20.9097934),
          zoom: 15.0,
        ),
        layers: [
          new TileLayerOptions(
            urlTemplate: "https://api.mapbox.com/styles/v1/lavops/ck8m295d701du1iqid1ejoqxu/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibGF2b3BzIiwiYSI6ImNrOG0yNm05ZDA4ZDcza3F6OWZpZ3pmbHUifQ.FBDBK21WD6Oa4V_5oz5iJQ",
            additionalOptions: {
              'accessToken':'pk.eyJ1IjoibGF2b3BzIiwiYSI6ImNrOG0yNm05ZDA4ZDcza3F6OWZpZ3pmbHUifQ.FBDBK21WD6Oa4V_5oz5iJQ',
              'id':'mapbox.mapbox-streets-v7'
            }
          ),
          new MarkerLayerOptions(
            markers: markers
          ),
        ],
      )
    );
  }
}