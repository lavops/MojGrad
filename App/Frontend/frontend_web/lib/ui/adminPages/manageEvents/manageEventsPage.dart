import 'package:flutter/material.dart';
import 'package:frontend_web/ui/adminPages/manageEvents/manageEventsDesktop.dart';
import 'package:frontend_web/ui/adminPages/manageEvents/manageEventsTablet.dart';
import 'package:frontend_web/widgets/mobileDrawer/drawerAdmin.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'manageEventsMobile.dart';

class ManageEventsPage extends StatefulWidget {
  @override
  _ManageEventsPageState createState() => _ManageEventsPageState();
}

class _ManageEventsPageState extends State<ManageEventsPage> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) => Scaffold(
        drawer: sizingInformation.deviceScreenType == DeviceScreenType.Mobile ? DrawerAdmin(6) : null,
        appBar: sizingInformation.deviceScreenType != DeviceScreenType.Mobile ? null : 
        AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        body: ScreenTypeLayout(
          mobile: ManageEventsPageMobile(),
          tablet: ManageEventsPageTablet(),
          desktop: ManageEventsPageDesktop(),
        ),
      ),
    );
  }
}