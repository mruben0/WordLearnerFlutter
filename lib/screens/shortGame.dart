
import 'dart:math';
import 'package:flutter/material.dart';

class ShortGameScreen extends StatefulWidget{

  static const String routeName = "/shortGame";

  @override
  ShortGameScreenState createState() =>  new ShortGameScreenState();
}
  
  class ShortGameScreenState extends State<StatefulWidget> {
  var dictionary ={
        "bringen" :     "բերել",
        "denken" : "մտածել",
        "erhalten" : "ստանալ",
        "essen" : "ուտել",
        "fahren" : "վարել",
        "fernsehen": "հեռուստացույց նայել",
  };

  String askWord = "--";
  String answer = "";
  String key = "";
  bool result = false;
  List<String> _rightAnswered = new List<String>();
  int count = 0;
  String showedAnswer = "tap here to view answer";
  TextEditingController answerController = new TextEditingController();   
  var answerFocusNode = new FocusNode();

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Scaffold(
        appBar: AppBar( 
        title: Text("Short Learning"),
      ),
      body: ListView(
        children: <Widget>[

          Text(askWord), 
          Row(
              children: <Widget>[
              Flexible(
                  child:
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
                                hintStyle: TextStyle(color: Colors.grey))),)
                          ],)
                
                        ],
                      ),
                      floatingActionButton: floatingActionButton(),
                      ) 
                    );}
                
      void answerSubmitted(String value) {
        checkAndStep();
  }
  FloatingActionButton floatingActionButton(){
      return new FloatingActionButton(
        onPressed: (){_start();},
        child: Icon(Icons.play_arrow),
      );
  }

  _start(){
    setState((){
    askWord = _getNewWord();
    });
  }

  String _getNewWord(){
    Random rand = new Random();
    var newIndex = rand.nextInt(dictionary.length);
    return dictionary.keys.toList()[newIndex];
  }

  checkAndStep() {
    answer = answerController.text;
    key = askWord;
    result = answer.replaceAll(" ", "") == dictionary[key].replaceAll(" ", "");
    if(result)
    {
     _rightAnswered.add(key);
     showedAnswer = "tap here to view answer";
    var keys = _rightAnswered.where((s) => s==key).toList();
    if(keys.length > 2){
       dictionary.remove(key);
       if(dictionary.length == 0){
       return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text("All Done"),
              );
            },
          );
    }
     }
     var newKey = _getNewWord();
     setState(() {
       answerController.text = "";
       answer = "";
       askWord = newKey;
       count = dictionary.length;
      });
      FocusScope.of(context).requestFocus(answerFocusNode);
    }
  } 
} 