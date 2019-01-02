import 'package:flutter/material.dart';
import 'package:wordlearner/screens/home.dart';
import 'package:wordlearner/screens/settings.dart';
import 'package:wordlearner/screens/shelf.dart';


void main() => runApp(new MaterialApp(
  debugShowCheckedModeBanner: false,
  home: new HomeScreen(),
  routes: <String,WidgetBuilder>{
    SettingsScreen.routeName: (BuildContext context) => new SettingsScreen(),
    ShelfScreen.routeName: (BuildContext context) => new ShelfScreen(),
  },
));

