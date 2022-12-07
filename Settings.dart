import 'dart:convert';

class Settings {
  final String loverNumber;

  Settings(this.loverNumber, this.score, this.favoriteMessage,
      this.favoriteMessageNumber);

    String score;
    List<String>favoriteMessage;
    int favoriteMessageNumber;


  Settings.fromJson(Map<String, dynamic> json)
      : score = json['score'],
        favoriteMessageNumber= json['favoriteMessageNumber'],
        favoriteMessage = json['favoriteMessage'],
        loverNumber = json['loverNumber'];

  Map<String, dynamic> toJson() => {
    'score': score,
    'favoriteMessage': favoriteMessage,
    'favoriteMessageNumber': favoriteMessageNumber,
    'loverNumber': loverNumber
  };

}
/*String jsonString = "assets/justAtinyconfFile.json";
Map<String, dynamic> settingsMap = jsonDecode(jsonString);
var settings = Settings.fromJson(settingsMap);*/

