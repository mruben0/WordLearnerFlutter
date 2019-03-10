import 'dart:math';
import 'package:flutter/material.dart';

class ShortGameScreen extends StatefulWidget{

  static const String routeName = "/shortGame";

  @override
  ShortGameScreenState createState() =>  new ShortGameScreenState();
}
  
  class ShortGameScreenState extends State<StatefulWidget> {

    ShortGameScreenState(){
    child = new Text("Bitte Wartet");
    rand = new Random();
    }
  var dictionary ={
        "bringen" : "բերել",
        "denken" : "մտածել",
        "erhalten" : "ստանալ",
        "essen" : "ուտել",
        "fahren" : "վարել",
        "fernsehen": "հեռուստացույց նայել",
  };

  Widget child;
  String askWord = "--";
  String answer = "";
  String key = "";
  bool result = false;
  List<String> _rightAnswered = new List<String>();
  int count = 0;
  String showedAnswer = "tap here to view answer";
  TextEditingController answerController = new TextEditingController();   
  var answerFocusNode = new FocusNode();
  Random rand;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Scaffold(
        appBar: AppBar( 
        title: Text("Short Learning"),
      ),
      body: learningWidget(),

        floatingActionButton: floatingActionButton(),
        ) 
      );}                
      
  FloatingActionButton floatingActionButton(){
      return new FloatingActionButton(
        onPressed: (){_start();},
        child: Icon(Icons.play_arrow),
      );
  }


  Widget learningWidget(){
    
    return 
     ListView(
              shrinkWrap: true,

              children: <Widget>[
                Text(askWord), 
                Text(result.toString()),
                _textFormFieldBuilder(answerFocusNode,answerController,answerSubmitted)
     ],);
    
  }

  TextFormField _textFormFieldBuilder(FocusNode focusMode, TextEditingController editingController, Function answerSubmittingFunction)
  {
   return TextFormField(
      focusNode: focusMode,
      validator: (value) {
                  if (value.isEmpty) {
                       return 'Please enter some text';
                    }
         },
      controller: editingController,
      autofocus: true,
      onFieldSubmitted: answerSubmittingFunction,
                      decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey)));

  }

  

  void answerSubmitted(String value) {
        checkAndStep();
  }

  _start(){
    setState((){
      child = learningWidget();
      askWord =_getNewWord();
    });
  } 

  checkAndStep() {
    answer = answerController.text;
    key = askWord;
    
    FocusScope.of(context).requestFocus(answerFocusNode);

    result = answer.replaceAll(" ", "") == dictionary[key].replaceAll(" ", "");
    if(result)
    {
     _rightAnswered.add(key);
     showedAnswer = "tap here to view answer";
    var keys = _rightAnswered.where((s) => s==key).toList();
    if(keys.length > 2){
       dictionary.remove(key);
    }
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
     var newKey = _getNewWord();
     setState(() {
       answerController.text = "";
       answer = "";
       askWord = newKey;
       count = dictionary.length;
      });
      }
    }
  

  //filePart

// Widget newWordAddingWidget(){
//     return 
//      ListView(
//               shrinkWrap: true,

//               children: <Widget>[
//                 Text("Add new Word"), 
//                 TextFormField(
//                 //focusNode: answerFocusNode,
//                 validator: (value) {
//                             if (value.isEmpty) {
//                                  return 'Please enter some text';
//                               }
//                    },
//                 controller: answerController,
//                 autofocus: true,
//                 onFieldSubmitted: answerSubmitted,
//                                 decoration: InputDecoration(
//                                 border: InputBorder.none,
//                                 hintStyle: TextStyle(color: Colors.grey))),
//                           ],);
//       }
//   }
  String _getNewWord(){
    var newIndex = rand.nextInt( dictionary.length);
    print(newIndex);
    return dictionary.keys.toList()[newIndex];
  }

  }