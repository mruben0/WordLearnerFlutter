import 'dart:ui';
import 'package:flutter/material.dart';

class Texts{

 tallText(String text){
    var _style = new TextStyle(fontSize: 25, color: Colors.green);
    var _text = new Text(text, style: _style,);  
    return _text;
  }
}