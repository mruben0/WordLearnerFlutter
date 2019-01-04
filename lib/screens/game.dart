import 'package:flutter/material.dart';
import 'dart:math';

class GameScreen extends StatefulWidget{
  static const String routeName = "/game";

  @override
  GameScreenState createState() => new GameScreenState();
  }
  
  class GameScreenState extends State<GameScreen>{

    GameScreenState(){
      _initalize();
    }

    var dictionary = <String, String>{
    "haben" : "ունենալ",
    "arbeiten": "աշխատել",
    "denken": "մտածել"
    };
    int count = 0;
    bool result = false;
    bool isInitialized = false;
    String askWord = "-";
    String answer = "";
    List<String> _rightAnswered = new List<String>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
              title: const Text('Learning'),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Text(result.toString()),
              new Text(count.toString()),
              new Text(askWord),
              new TextField(
                controller: answerController,
                onSubmitted: (s) {checkAndStep();} ,
                autofocus: true,
                decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Please enter answer',
                hintStyle: TextStyle(color: Colors.grey))),
            ],
          ),        
        )
    );
  }  

TextEditingController answerController = new TextEditingController();


  void _initalize(){
    if(!isInitialized){
      isInitialized = true;
      Random rand = new Random();
      var newIndex = rand.nextInt(dictionary.length);   
      askWord = dictionary.keys.toList()[newIndex];
      count = dictionary.length;
    }
  }

  String _getNewWord(){
    Random rand = new Random();
    var newIndex = rand.nextInt(dictionary.length);   
    return dictionary.keys.toList()[newIndex];   
  }

  checkAndStep() {
    answer = answerController.text;
    var key = askWord;
    result = answer == dictionary[key];
    print(dictionary[key]);
    if(result)
    {
     _rightAnswered.add(key); 
    var keys = _rightAnswered.where((s) => s==key).toList();
    if(keys.length > 1){
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
        
    }       
  }
}