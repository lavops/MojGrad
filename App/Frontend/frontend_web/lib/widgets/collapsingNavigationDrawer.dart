import 'package:flutter/material.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/home/homeView.dart';
import 'package:frontend_web/ui/homePage.dart';
import 'package:frontend_web/ui/managementPage.dart';
import 'package:frontend_web/ui/statisticsPage.dart';
import 'package:frontend_web/widgets/CollapsingListTile.dart';
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
  static bool isCollapsed = true;
  AnimationController _animationController;
  Animation<double> widthAnimation;
  static int currentSelectedIndex = 1;

  _removeToken() async {
    TokenSession.setToken = "";
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this, duration: Duration(milliseconds: 300));
    widthAnimation = Tween<double>(begin: maxWidth, end: minWidth).animate(_animationController);
    isCollapsed ? _animationController.forward() : _animationController.reverse();
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
        color: Colors.grey[100],
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  CollapsingListTile(title: 'Administrator', icon: Icons.perm_identity, animationController: _animationController,),
                  CollapsingListTile(
                      title: 'Početna strana',
                      icon: Icons.home,
                      animationController: _animationController,
                      onTap: () {
                        setState(() {
                          currentSelectedIndex = 1;
                        });
                        String jwt = TokenSession.getToken;
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage.fromBase64(jwt)),
                        );
                      },
                      isSelected: currentSelectedIndex == 1,
                      ),
                  CollapsingListTile(
                    title: 'Statistika',
                    icon: MdiIcons.chartAreaspline,
                    animationController: _animationController,
                    onTap: () {
                      setState(() {
                          currentSelectedIndex = 2;
                        });
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StatisticsPage()),
                      );
                    },
                    isSelected: currentSelectedIndex == 2,
                    ),
                  CollapsingListTile(
                    title: 'Zadavanje misija',
                    icon: Icons.timer,
                    animationController: _animationController,
                    onTap: () => {
                      setState(() {
                          currentSelectedIndex = 3;
                        }),
                    },
                    isSelected: currentSelectedIndex == 3,
                  ),
                  CollapsingListTile(
                    title: 'Upravljanje',
                    icon: Icons.settings,
                    animationController: _animationController,
                    onTap: () => {
                      setState(() {
                          currentSelectedIndex = 4;
                        }),
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ManagementPage()),
                      ),
                    },
                    isSelected: currentSelectedIndex == 4,
                  ),
                  CollapsingListTile(
                    title: 'Odjavite se',
                    icon: Icons.exit_to_app,
                    animationController: _animationController,
                    onTap: () => {
                      _removeToken(),
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeView()),
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
                color: Colors.black54,
                size: 50.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}