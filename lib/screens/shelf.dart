import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:wordlearner/models/document.dart';
import 'package:wordlearner/screens/designedWidgets/texts.dart';
import 'package:wordlearner/services/sheetReader.dart';


class ShelfScreen extends StatefulWidget{
  static const String routeName = "/shelf";

  @override
  ShelfScreenState createState() => new ShelfScreenState();
}

class ShelfScreenState extends State<ShelfScreen>{

  SheetReader reader = new SheetReader();
  String _fileName = "-";
  List<Document> _paths = new List<Document>();
  bool _pickFileInProgress = false;
  bool _iosPublicDataUTI = true;
  bool _checkByCustomExtension = false;
  bool _checkByMimeType = true;

  final _utiController = TextEditingController(
    text: 'com.sidlatau.example.xlsx',
  );

  final _extensionController = TextEditingController(
    text: 'xlsx',
  );

  final _mimeTypeController = TextEditingController(
    text: 'application/*',
  );
 
  @override
  void initState() {
    super.initState();
  }

@override
  Widget build(BuildContext context) {

     
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My Shelf'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.open_in_new),
              onPressed: _pickFileInProgress ? null : _pickDocument,
            )
          ],
        ),
        body:  Column(          
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[               
                Text(
                  'Picked files paths:',
                  style: Theme.of(context).textTheme.title,
                ),
                Expanded(child: ListView.builder(
                  itemCount: _paths.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                          //return new Card(child: new Text(_pats[index]));
            final item = _paths[index];

            return Dismissible(
              // Each Dismissible must contain a Key. Keys allow Flutter to
              // uniquely identify Widgets.
              key: Key(item.name + _paths.length.toString()),
              // We also need to provide a function that tells our app
              // what to do after an item has been swiped away.
              onDismissed: (direction) {
                setState(() {
                  _paths.removeAt(index);
                });

                // Then show a snackbar!
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text("$item dismissed")));
              },
              // Show a red background as the item is swiped away
              background: Container(color: Colors.red),
              child: Container(child: new Texts().tallText(item.name)),
            );
                  } 
                )),

                _pickFileInProgress ? CircularProgressIndicator() : Container(),
               
              ],
            ),         
      ),
    );
  } 

_pickDocument() async {
    String result;
    try {
      setState(() {
        _fileName = '-';
        _pickFileInProgress = true;
      });

  FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
        allowedFileExtensions: _checkByCustomExtension
            ? _extensionController.text
                .split(' ')
                .where((x) => x.isNotEmpty)
                .toList()
            : null,
        allowedUtiTypes: _iosPublicDataUTI
            ? null
            : _utiController.text
                .split(' ')
                .where((x) => x.isNotEmpty)
                .toList(),
        allowedMimeType: _checkByMimeType ? _mimeTypeController.text : null,
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

    var rows = reader.getDictionary(result, 5, "E","A");
    rows.forEach((f,v)=>print(f+": "+ v));

    var parts = result.split('/');
    _fileName = parts.last;

    setState(() {
      _paths.add(new Document(_fileName, result));
    });    
  } 
}