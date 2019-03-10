
import 'dart:math';
import 'package:flutter/material.dart';

class WordLearningService {
Function _updateState;
String askWord = "--";
bool result = false;
String answer = "";
String key = "";
List<String> _rightAnswered = new List<String>();
int count = 0;
Map<String, String> _dictionary;
BuildContext _context;
String showedAnswer = "tap here to view answer";
TextEditingController answerController = new TextEditingController();   
var answerFocusNode = new FocusNode();

WordLearningService(Map<String, String> dictionary, Function updateState){

_dictionary =dictionary;
_updateState =updateState;
 askWord = _getNewWord();
}
 Widget learningWidget(){
    return ListView(
        shrinkWrap: true,
      children: <Widget>[
          Text(askWord), 
        Text(result.toString()),
        TextFormField(
          focusNode: answerFocusNode,
        validator: (value) {
                      if (value.isEmpty) {
                           return 'Please enter some text';
                      }
           },
        controller: answerController,
        autofocus: true,
        onFieldSubmitted: answerSubmitted,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey))),
                  ],);
    
  }

  void answerSubmitted(String value) {
        checkAndStep();
  }
checkAndStep() {
    answer = answerController.text;
    key = askWord;
    result = answer.replaceAll(" ", "") == _dictionary[key].replaceAll(" ", "");
    if(result)
    {
     _rightAnswered.add(key);
     showedAnswer = "tap here to view answer";
    var keys = _rightAnswered.where((s) => s==key).toList();
    if(keys.length > 2){
       _dictionary.remove(key);
       if(_dictionary.length == 0){
       return showDialog(
            context: _context,
            builder: (_context) {
              return AlertDialog(
                content: Text("All Done"),
              );
            },
          );
    }
  }
     var newKey = _getNewWord();
      _updateState(() {
       answerController.text = "";
       answer = "";
       askWord = newKey;
       count = _dictionary.length;
      });
      FocusScope.of(_context).requestFocus(answerFocusNode);
    }
  }
   String _getNewWord(){
    Random rand = new Random();
    var newIndex = rand.nextInt(_dictionary.length);
    return _dictionary.keys.toList()[newIndex];
  }  
}