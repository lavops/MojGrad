import 'package:flutter/material.dart';
import 'package:frontend_web/ui/adminPages/manageDonation/manageDonationDesktop.dart';
import 'package:frontend_web/ui/adminPages/manageDonation/manageDonationMobile.dart';
import 'package:frontend_web/ui/adminPages/manageDonation/manageDonationTablet.dart';
import 'package:frontend_web/widgets/mobileDrawer/drawerAdmin.dart';
import 'package:responsive_builder/responsive_builder.dart';

Color greenPastel = Color(0xFF00BFA6);

class ManageDonationPage extends StatefulWidget {
  @override
  _ManageDonationPageState createState() => _ManageDonationPageState();
}

class _ManageDonationPageState extends State<ManageDonationPage> {
  @override
  Widget build(BuildContext context) {

    return ResponsiveBuilder(
      builder: (context, sizingInformation) => Scaffold(
          drawer: sizingInformation.deviceScreenType == DeviceScreenType.Mobile 
            ? DrawerAdmin(7)
            : null,
          appBar: sizingInformation.deviceScreenType != DeviceScreenType.Mobile
            ? null
            : AppBar(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
            ),
          backgroundColor: Colors.white,
          body: ScreenTypeLayout(
            mobile: ManageDonationMobile(),
            tablet: ManageDonationTablet(),
            desktop: ManageDonationDesktop(),
          ),
        ),
      );
  }
}