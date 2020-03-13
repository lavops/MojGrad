import 'package:flutter/cupertino.dart';

class Slika extends StatelessWidget{
  Widget build(BuildContext context){
    var assetsImage = new AssetImage("assets/logo.png");
    var image = new Image(image: assetsImage, width:300.0, height:300.0);
    return new Container(child:image);
  }
}