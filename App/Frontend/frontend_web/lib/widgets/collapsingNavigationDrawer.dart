import 'package:flutter/material.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/homePage.dart';
import 'package:frontend_web/ui/loginPage.dart';
import 'package:frontend_web/ui/managementPage.dart';
import 'package:frontend_web/ui/statisticsPage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';


class CollapsingNavigationDrawer extends StatefulWidget {
  @override
  CollapsingNavigationDrawerState createState() {
    return new CollapsingNavigationDrawerState();
  }
}

class CollapsingNavigationDrawerState extends State<CollapsingNavigationDrawer>
    with SingleTickerProviderStateMixin {
  double maxWidth = 210;
  double minWidth = 70;
  bool isCollapsed = false;
  AnimationController _animationController;
  Animation<double> widthAnimation;

  _removeToken() async {
    TokenSession.setToken = "";
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this, duration: Duration(milliseconds: 300));
    widthAnimation = Tween<double>(begin: maxWidth, end: minWidth).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, widget) => getWidget(context, widget),
    );
  }

  Widget getWidget(context, widget) {
    return Material(
      child: Container(
        width: widthAnimation.value,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.perm_identity),
                    title: Text('Administrator'),
                  ),
                  ListTile(
                      leading: Icon(Icons.home),
                      title: Text('Početna strana'),
                      onTap: () {
                        String jwt = TokenSession.getToken;
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage.fromBase64(jwt)),
                        );
                      }),
                  ListTile(
                    leading: Icon(MdiIcons.chartAreaspline),
                    title: Text('Statistika'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StatisticsPage()),
                      );
                    }),
                  ListTile(
                    leading: Icon(Icons.timer),
                    title: Text('Zadavanje misija'),
                    //onTap: () => {Navigator.of(context).pop()},
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Upravljanje'),
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ManagementPage()),
                      ),
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text('Odjavite se'),
                    onTap: () => {
                      _removeToken(),
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      )
                    },
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  isCollapsed = !isCollapsed;
                  isCollapsed
                      ? _animationController.forward()
                      : _animationController.reverse();
                });
              },
              child: AnimatedIcon(
                icon: AnimatedIcons.arrow_menu,
                progress: _animationController,
                color: Colors.green,
                size: 50.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}