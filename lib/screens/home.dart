import 'package:flutter/material.dart';
import 'package:wordlearner/screens/game.dart';
import 'package:wordlearner/screens/settings.dart';
import 'package:wordlearner/screens/shelf.dart';
import 'package:wordlearner/screens/shortGame.dart';

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
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(routeName);
          });
        },
      );
    }

    var myNavChildren = [
      headerChild,
      getNavItem(Icons.home, "Home", "/"),      
      getNavItem(Icons.keyboard, "Learn", GameScreen.routeName),
      getNavItem(Icons.bookmark , "Shelf", ShelfScreen.routeName),
      getNavItem(Icons.settings, "Settings", SettingsScreen.routeName),
      getNavItem(Icons.short_text, "fast learn", ShortGameScreen.routeName),
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
      body: _buildGrid(),
      // Set the nav drawer
      drawer: getNavDrawer(context),
    );
  }

  Widget _buildGrid() => GridView.extent(
    maxCrossAxisExtent: 150,
    padding: const EdgeInsets.all(4),
    mainAxisSpacing: 4,
    crossAxisSpacing: 4,
    children: _buildLayout());
    
    List<GestureDetector> _buildLayout(){
      var containers = new List<GestureDetector>();
      containers.add(_buildMenuItem(Icons.keyboard,"Train", new GameScreen()));
      containers.add(_buildMenuItem(Icons.library_books,"Shelf", new ShelfScreen()));
      containers.add(_buildMenuItem(Icons.pageview,"Test", new ShortGameScreen()));
      containers.add(_buildMenuItem(Icons.settings, "Settings", new SettingsScreen()));

      return containers;
    }

    GestureDetector _buildMenuItem(IconData icon, String name, StatefulWidget screen){
     return GestureDetector( child:Card(child:new Container(
       padding: new EdgeInsets.all(32.0),
       child: Column (children: <Widget>[
        Icon(
          icon,
          color: Colors.green,
          size: 30.0,
        ), 
      Text(name)

     ],) )),onTap: () {
      Navigator.push(
       context,
       MaterialPageRoute(builder: (context) => screen),
      ); });
    }
      
}