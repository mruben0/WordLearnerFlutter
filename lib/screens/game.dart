import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:wordlearner/services/sheetReader.dart';
import 'package:open_file/open_file.dart';

class GameScreen extends StatefulWidget{
  static const String routeName = "/game";

  @override
  GameScreenState createState() => new GameScreenState();
  }


  class GameScreenState extends State<GameScreen>{

  Widget titleSection(){

    return new Container(padding: EdgeInsets.all(32.0),
        child: Row(
          children: <Widget>[
            Expanded(child:Column (
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
              new MaterialButton(
               onPressed: (){ openFile();},
                child: new Text(_documentName),
                                ),
                new MaterialButton(
               onPressed: () {showAnswer();},
               child: new Text(showedAnswer),
             ),
                                ],
                              ),)
                              ],
                  ),
                  );
      }

     
      Widget paramSection(){
    return new Container(padding: EdgeInsets.all(30.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
              children: <Widget>[
              _buildParam("Ask Letter", askLetterController,1),
              _buildParam( "Answer letter", answerLetterController,1),
              _buildParam( "From", fromController, 5),
              _buildParam("to", toController,5),

                       ],
                     ),)
                   ],
                  ),
                  );
      }
      
 Row _buildParam(String hinText, TextEditingController editingController, int maxlength)
{
          return Row(
              children: <Widget>[
              Flexible(
                  child:
                TextFormField(
                validator: (value) {
                            if (value.isEmpty) {
                                 return 'Please enter some text';
                              }
                   },
                maxLength: maxlength,
                controller: editingController,
                autofocus: true,
                decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hinText,
                hintStyle: TextStyle(color: Colors.grey))),)
          ],);
      }
      
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
 
    String _filePath;
    String _documentPath;
    String _documentName = "Add  File To start";
    bool _iosPublicDataUTI = true;
    String key = "";
    var dictionary = new Map<String, String>();
    int count = 0;
    bool result = false;
    bool isInitialized = false;
    bool isPicked = false;
    String askWord = "-";
    String answer = "";
    List<String> _rightAnswered = new List<String>();
    var answerFocusNode = new FocusNode();

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
              title: const Text('Learning'),
          ),
          body: ListView(
            children: <Widget>[

             titleSection(),
             paramSection(),


              new Text(result.toString()),
              new Text(count.toString()),
              new Text(askWord),
              new TextField(
                focusNode: answerFocusNode,
                controller: answerController,
                onSubmitted: (s) {checkAndStep();} ,
                autofocus: true,
                decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Please enter answer',
                hintStyle: TextStyle(color: Colors.grey))),
            ],
          ),
          floatingActionButton: buildFloatActionButton(),
        )
    );
  }

Widget buildFloatActionButton(){
  if(!isPicked){
    return new FloatingActionButton(onPressed:  (){_pickDocument();} ,
          child: Icon(Icons.add_circle),
          );
  } else if(!isInitialized){
    return new FloatingActionButton(onPressed: (){_initalize();},
    child:  Icon(Icons.play_circle_filled),);
  }
  else return new FloatingActionButton(onPressed: (){checkAndStep();},
  child: Icon(Icons.check_circle),);
 
}

TextEditingController answerController = new TextEditingController();
TextEditingController answerLetterController = new TextEditingController();
TextEditingController askLetterController = new TextEditingController();
TextEditingController fromController = new TextEditingController();
TextEditingController toController = new TextEditingController();

  _initalize(){
 if( !_pickFileInProgress && askLetterController.text != "" && answerLetterController.text != "" &&
    fromController.text != "" && toController.text !="" && _filePath != "" && !isInitialized)
    {
      if(!isInitialized){
    dictionary = reader.getDictionary(_filePath, int.parse(fromController.text), int.parse(toController.text),
    askLetterController.text,
    answerLetterController.text);
   
      isInitialized = true;
      Random rand = new Random();
      var newIndex = rand.nextInt(dictionary.length);
      setState(() {
      askWord = dictionary.keys.toList()[newIndex];
      count = dictionary.length;
      }); 
        }
    }   else return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text("please fill \"asking letter \",  \"answer letter\",  \"from\" and  \"to\" fields"),
              );
            },
          );   
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
  
  String showedAnswer = "tap here to view answer";
  showAnswer(){
    if(dictionary.containsKey(askWord))
    setState(() {
          showedAnswer = dictionary[askWord];
        });
  }

  _pickDocument() async {   
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
      isPicked = true;
      _filePath = await FlutterDocumentPicker.openDocument(params: params);
    _documentPath = _filePath;
    var parts = _filePath.split('/');
    setState(() {
    _documentName = parts.last;
        }); 
      
    } catch (e) {
      print(e);
      _filePath = 'Error: $e';
    } finally {
      setState(() {
        _pickFileInProgress = false;
      });
    }   
  }

  openFile(){
    if(isInitialized){
      OpenFile.open(_documentPath);
    }
  }
}