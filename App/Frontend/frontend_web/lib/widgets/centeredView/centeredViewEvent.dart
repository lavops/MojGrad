import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CenteredViewEvent extends StatelessWidget {
  final Widget child;
  const CenteredViewEvent({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      tablet: CenteredViewEventTabletDesktop(),
      mobile: CenteredViewEventMobile(),
    );
  }
}

class CenteredViewEventTabletDesktop extends StatelessWidget {
  final Widget child;
  const CenteredViewEventTabletDesktop({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 100, right: 100, top: 30),
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 500), 
        child: child
      ),
    );
  }
}


class CenteredViewEventMobile extends StatelessWidget{
  final Widget child;
  const CenteredViewEventMobile({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 500),
        child: child,
      ),
    );
  }
}