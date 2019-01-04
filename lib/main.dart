import 'package:flutter/material.dart';
import 'package:wordlearner/screens/game.dart';
import 'package:wordlearner/screens/home.dart';
import 'package:wordlearner/screens/settings.dart';
import 'package:wordlearner/screens/shelf.dart';


void main() => runApp(new MaterialApp(
  debugShowCheckedModeBanner: false,
  home: new HomeScreen(),
  routes: <String,WidgetBuilder>{
    ShelfScreen.routeName: (BuildContext context) => new ShelfScreen(),
    SettingsScreen.routeName: (BuildContext context) => new SettingsScreen(),
    GameScreen.routeName: (BuildContext context) => new GameScreen(),
  },
));

