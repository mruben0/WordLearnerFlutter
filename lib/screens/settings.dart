import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = "/settings";

  @override
  SettingsScreenState createState() => new SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Settings"),
      ),
       body: Text("There are no Settings yet")
      );
   }      
}