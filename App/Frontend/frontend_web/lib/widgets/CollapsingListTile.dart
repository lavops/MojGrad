import 'package:flutter/material.dart';

Color greenPastel = Color(0xFF00BFA6);

class CollapsingListTile extends StatefulWidget {
  final String title;
  final IconData icon;
  final AnimationController animationController;
  final bool isSelected;
  final Function onTap;

  CollapsingListTile(
      {@required this.title,
      @required this.icon,
      @required this.animationController,
      this.isSelected = false,
      this.onTap});

  @override
  _CollapsingListTileState createState() => _CollapsingListTileState();
}

class _CollapsingListTileState extends State<CollapsingListTile> {
  Animation<double> widthAnimation, sizedBoxAnimation;

  @override
  void initState() {
    super.initState();
    widthAnimation =
        Tween<double>(begin: 200, end: 70).animate(widget.animationController);
    sizedBoxAnimation =
        Tween<double>(begin: 10, end: 0).animate(widget.animationController);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          color: widget.isSelected
              ? Color(0xFF00BFA6)
              : Colors.transparent,
        ),
        width: widthAnimation.value,
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child:  Row(
            children: <Widget>[
              Icon(
                widget.icon,
<<<<<<< HEAD
                color: widget.isSelected ? Colors.white : Colors.black54,
=======
                color: widget.isSelected ? greenPastel : Colors.black54,
>>>>>>> 9062d314e1421890aaf6361a217fe4db78aa8dbe
                size: 33.0,
              ),
              SizedBox(width: sizedBoxAnimation.value),
              (widthAnimation.value >= 190)
                  ? Text(widget.title,
                      style: widget.isSelected
<<<<<<< HEAD
                          ? TextStyle(color: Colors.white, fontSize: 11.0, fontWeight: FontWeight.w500)
=======
                          ? TextStyle(color: greenPastel, fontSize: 11.0, fontWeight: FontWeight.w500)
>>>>>>> 9062d314e1421890aaf6361a217fe4db78aa8dbe
                          : TextStyle(color: Colors.black54, fontSize: 11.0, fontWeight: FontWeight.w500))
                  : Container()
            ],
        ),
      ),
    );
  }
}