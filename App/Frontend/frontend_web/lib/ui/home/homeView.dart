import 'package:flutter/material.dart';
import 'package:frontend_web/widgets/centeredView/centeredView.dart';
import 'package:frontend_web/widgets/homeNavigationBar/navigationBar.dart';
import 'package:frontend_web/widgets/projectDetails/projectDetails.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomeView extends StatelessWidget{
 
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) => Scaffold(
        /*drawer: sizingInformation.deviceScreenType == DeviceScreenType.Mobile 
            ? NavigationDrawer()
            : null,*/
        backgroundColor: Colors.white,
        body: CenteredView(
          child: Column(
            children: <Widget>[
              HomeNavigationBar(0),
              Expanded(
                child: ScreenTypeLayout(
                  mobile: HomeViewMobile(),
                  desktop: HomeViewDesktop(),
                  tablet: HomeViewMobile(),
                ),
              )
            ],
          ),
        )
      )
    );
  }
}

class HomeViewMobile extends StatelessWidget{
 
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ProjectDetails(),
            SizedBox(height: 100,),
            Image.asset('assets/undraw4.png')
          ],
        )
      ],
    );
  }
}

class HomeViewDesktop extends StatelessWidget{
 
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      shrinkWrap: true,
      children: <Widget>[ 
        Row(children: <Widget>[
          ProjectDetails(),
          Expanded(
            child: Center(
              child: Image.asset('assets/undraw4.png'),
            ),
          )
        ],)
      ]
    );
  }
}