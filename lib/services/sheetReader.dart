import 'dart:io';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

class SheetReader{

final String alphabet ="ABCDEFGHIJKLMNOPQRSTUVWXYZ";

Map<String, String> getDictionary(String path,int from, int to ,String askLetter, String answLetter){

  if(path != null){
    int askIndex = alphabet.indexOf(askLetter.toUpperCase());
    int answIndex = alphabet.indexOf(answLetter.toUpperCase());
    var uri = new Uri(path: path);
    var bytes = new File.fromUri(uri).readAsBytesSync();
    var decoder = new SpreadsheetDecoder.decodeBytes(bytes);
    var table = decoder.tables.values.toList();
    var rows = table.first.rows;
    Map<String, String> map = new Map<String, String>() ;  
    var neededRows = rows.where((l)=> rows.indexOf(l) >= from && rows.indexOf(l)<=to);
    neededRows.forEach((r)=>
      map[r[askIndex]] = r[answIndex]
    );
    return map;
  }
  return null;
 }

}