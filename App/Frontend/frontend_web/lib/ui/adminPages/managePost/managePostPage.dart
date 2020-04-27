import 'package:flutter/material.dart';
import 'package:frontend_web/ui/adminPages/managePost/managePostDesktop.dart';
import 'package:frontend_web/ui/adminPages/managePost/managePostMobile.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';

Color greenPastel = Color(0xFF00BFA6);

class ManagePostPage extends StatefulWidget {
  @override
  _ManagePostPageState createState() => _ManagePostPageState();
}

class _ManagePostPageState extends State<ManagePostPage> {
  @override
  Widget build(BuildContext context) {

    return ResponsiveBuilder(
      builder: (context, sizingInformation) => DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: sizingInformation.deviceScreenType != DeviceScreenType.Mobile
            ? PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: Container(
                  height: 100.0,
                  child: tabs(),
                ),
              )
            : AppBar(
              leading: new Container(),
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
              bottom: tabs(),
            ),
          backgroundColor: Colors.white,
          body: ScreenTypeLayout(
            mobile: ManagePostMobile(),
            tablet: ManagePostDesktop(),
          ),
        ),
      )
    );
  }

  Widget tabs() {
    return TabBar(
      labelColor: greenPastel,
      indicatorColor: greenPastel,
      tabs: <Widget>[
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(MdiIcons.homeSearchOutline, color: Colors.black, size: 20),
              Text(
                'Sve objave',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.done_all, color: Colors.black, size: 20),
              Text(
                'Rešene objave',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.close, color: Colors.black, size: 20),
              Text(
                'Nerešene objave',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ]
    );
  }
}