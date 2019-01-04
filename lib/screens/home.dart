import 'package:flutter/material.dart';
import 'package:wordlearner/screens/game.dart';
import 'package:wordlearner/screens/settings.dart';
import 'package:wordlearner/screens/shelf.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => new HomeScreenState();
}



class HomeScreenState extends State<HomeScreen> {
  Drawer getNavDrawer(BuildContext context) {
    var headerChild = new DrawerHeader(child: new Text("Navigation"));
    var aboutChild = new AboutListTile(
        child: new Text("About"),
        applicationName: "WordLearner Android",
        applicationVersion: "v1.0.0",
        applicationIcon: new Icon(Icons.work),
        icon: new Icon(Icons.info));

    ListTile getNavItem(var icon, String s, String routeName) {
      return new ListTile(
        leading: new Icon(icon),
        title: new Text(s),
        onTap: () {
          setState(() {
            // pop closes the drawer
            Navigator.of(context).pop();
            // navigate to the route
            Navigator.of(context).pushNamed(routeName);
          });
        },
      );
    }

    var myNavChildren = [
      headerChild,
      getNavItem(Icons.home, "Home", "/"),
      getNavItem(Icons.bookmark , "Shelf", ShelfScreen.routeName),
      getNavItem(Icons.keyboard, "Game", GameScreen.routeName),
      getNavItem(Icons.settings, "Settings", SettingsScreen.routeName),
      aboutChild
    ];

    ListView listView = new ListView(children: myNavChildren);

    return new Drawer(
      child: listView,
    );
  }

 @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Navigation Drawer"),
      ),
      body: new Container(
          child: new Center(
        child: new Text("Home Screen"),
      )),
      // Set the nav drawer
      drawer: getNavDrawer(context),
    );
  }
}