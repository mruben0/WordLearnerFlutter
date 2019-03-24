import 'dart:io';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

class SheetReader{

final String alphabet ="ABCDEFGHIJKLMNOPQRSTUVWXYZ";

Map<String, String> getDictionary(String path,int from, int to ,String askLetter, String answLetter){

  if(path != null){
    int askIndex = alphabet.indexOf(askLetter.toUpperCase());
    String answIndex =""; 
    if (answLetter.length > 1) {
      for (var i = 0; i < answLetter.length; i++) {
        print(answLetter[i]);
        answIndex += alphabet.indexOf(answLetter[i].toUpperCase()).toString();
 
      }  
    }else{
      answIndex = alphabet.indexOf(answLetter.toUpperCase()).toString();
    }
    var uri = new Uri(path: path);
    var bytes = new File.fromUri(uri).readAsBytesSync();
    var decoder = new SpreadsheetDecoder.decodeBytes(bytes);
    var table = decoder.tables.values.toList();
    var rows = table.first.rows;
    Map<String, String> map = new Map<String, String>() ;  
    var neededRows = rows.where((l)=> rows.indexOf(l) >= from && rows.indexOf(l)<=to);
    if (answIndex.length > 0) {
      for (var row in neededRows) {
        String answer = "";

       for (var i = 0; i < answIndex.length; i++) {
         answer += row[int.parse(answIndex[i])] + " ";
       }         
       map[row[askIndex]] = answer;
    }
    }else{
      for (var row in neededRows) {
        map[row[askIndex]] = row[int.parse(answIndex)];
      }
    }
    return map;
  }
  return null;
  }
}