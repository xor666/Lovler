import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

var jsonData;//from the JSON
var JSONFile ="assets/justAtinyconfFile.json" ;

Future<void> readJson() async {
  String data =  await rootBundle.loadString(JSONFile);
  jsonData = json.decode(data);
  jsonData.forEach((item){
    item.forEach((key, value){
      /*if(key=="loverNumber"){
        loverNumber = value.toString();
        print(loverNumber+': loverNumber from json');
      }*/
    });
  });
}
Future<void> writeJSON() async {
      Map<String, dynamic> user = jsonDecode(JSONFile);
      //print("OH BAH MERDEq ["loverNumber"");
}
