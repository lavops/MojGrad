import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/ui/splash.page.dart';
import 'package:provider/provider.dart';

import 'bloc/themes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static int ind = 0;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeChanger>(
      create: (_) => ThemeChanger(ThemeData.light()),
      child: new MaterialAppWithTheme(),
    );
  }

  static themeLight() {
    TextTheme _themeLight(TextTheme base) {
      return base.copyWith(
        title: base.title.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Colors.white),
      );
    }

    final ThemeData base = ThemeData.light();
    return base.copyWith(
        textTheme: _themeLight(base.textTheme),
        primaryColor: Colors.white,
        /*brightness: Brightness.light,
        accentColor: Colors.white,*/
        iconTheme: IconThemeData(color: Colors.black, size: 25),
        backgroundColor: Colors.white);
  }

  static themeDark() {
    TextTheme _themeDark(TextTheme base) {
      return base.copyWith(
        title: base.title.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Colors.white),
      );
    }

    final ThemeData base = ThemeData.dark();
    return base.copyWith(
        textTheme: _themeDark(base.textTheme),
        primaryColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white, size: 25),
        backgroundColor: Colors.black45);
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if (jwt == null) return "";
    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Moj Grad',
      theme: theme.getTheme(),
      home: FutureBuilder(
          future: jwtOrEmpty,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            if (snapshot.data != "") {
              var str = snapshot.data;
              var jwt = str.split(".");
              if (jwt.length != 3) {
                return SplashPage("");
              } else {
                var payload = json.decode(
                    ascii.decode(base64.decode(base64.normalize(jwt[1]))));
                if (DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000)
                    .isAfter(DateTime.now())) {
                  int type = int.parse(payload["sub"]);
                  if(type != null && type != 0)
                    return SplashPage(str);
                  else
                    return SplashPage("");
                } else {
                  return SplashPage("");
                }
              }
            } else {
              return SplashPage("");
            }
          }),
    );
  }
}
