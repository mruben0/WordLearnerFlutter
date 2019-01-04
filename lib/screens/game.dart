import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:wordlearner/services/sheetReader.dart';

class GameScreen extends StatefulWidget{
  static const String routeName = "/game";

  @override
  GameScreenState createState() => new GameScreenState();
  }
  
  class GameScreenState extends State<GameScreen>{

  bool _pickFileInProgress = false;
  SheetReader reader = new SheetReader();
  final _extensionController = TextEditingController(
    text: 'xlsx',
  );
  final _utiController = TextEditingController(
    text: 'com.sidlatau.example.xlsx',
  );
  final _mimeTypeController = TextEditingController(
    text: 'application/*',
  );
    bool _iosPublicDataUTI = true;
    String key = "";
    var dictionary = new Map<String, String>();
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
             new Text("Pick File To start"),
             new MaterialButton(
               onPressed: () {showAnswer();},
               child: new Text(showedAnswer),
             ),
             new TextField(
                maxLength: 1,
                controller: askLetterController,
                autofocus: true,
                decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Asking letter',
                hintStyle: TextStyle(color: Colors.grey))),

              new TextField(
                maxLength: 1,
                controller: answerLetterController,
                autofocus: true,
                decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Answer letter',
                hintStyle: TextStyle(color: Colors.grey))),
            
              new TextField(
                controller: countController,
                autofocus: true,
                decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Count',
                hintStyle: TextStyle(color: Colors.grey))),

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
          floatingActionButton: new FloatingActionButton(onPressed:  _pickFileInProgress ? null : _pickDocument,
          child: Icon(Icons.text_fields),
          ),     
        )
    );
  }  

TextEditingController answerController = new TextEditingController();
TextEditingController answerLetterController = new TextEditingController();
TextEditingController askLetterController = new TextEditingController();
TextEditingController countController = new TextEditingController();

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
    key = askWord;
    result = answer == dictionary[key];
    print(dictionary[key]);
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
        
    }       
  }
  String showedAnswer = "tap to view answer";
  showAnswer(){
    if(dictionary.containsKey(askWord))
    setState(() {
          showedAnswer = dictionary[askWord];
        });
  }

  _pickDocument() async {
    if( !_pickFileInProgress && askLetterController.text != "" && answerLetterController.text != "" && countController.text != "")
    {
    String result;
    try {
     _pickFileInProgress = true;

  FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
        allowedFileExtensions: _extensionController.text
                .split(' ')
                .where((x) => x.isNotEmpty)
                .toList(),
        allowedUtiTypes: _iosPublicDataUTI
            ? null
            : _utiController.text
                .split(' ')
                .where((x) => x.isNotEmpty)
                .toList(),
        allowedMimeType: _mimeTypeController.text,
      );

      result = await FlutterDocumentPicker.openDocument(params: params);
    } catch (e) {
      print(e);
      result = 'Error: $e';
    } finally {
      setState(() {
        _pickFileInProgress = false;
      });
    }

    dictionary = reader.getDictionary(result, int.parse(countController.text), 
    askLetterController.text,
    answerLetterController.text);
    _initalize();
   } 
  }
}