import 'package:flutter/material.dart';
import 'package:frontend/ui/homePage.dart';
import 'package:frontend/ui/othersProfilePage.dart';

class CircleImage extends StatelessWidget {
  final String image;
  final double imageSize;
  final double whiteMargin;
  final double imageMargin;
  final int othersUserId;
  CircleImage(
    this.image, {
    this.imageSize = 70.0,
    this.whiteMargin = 2.5,
    this.imageMargin = 4.0,
    this.othersUserId
  });


  @override
  Widget build(BuildContext context) {
    // Gradient background container
    return InkWell(
      onTap: (){
        if(userId != othersUserId)
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OthersProfilePage(othersUserId)),
        );
      },
      child: Container(
        height: this.imageSize,
        width: this.imageSize,
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),

        // White background container between image and gradient
        child: Container(
          margin: EdgeInsets.all(whiteMargin),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(image),
            ),
          ),
        ),
      )
    );
  }
}
