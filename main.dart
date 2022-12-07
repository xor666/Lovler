import 'dart:convert';
import 'dart:ui';
import 'package:background_sms/background_sms.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:permission_handler/permission_handler.dart';
import 'SMS.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  int _counter = settings.score as int;
  int  favoriteMessageIndex= settings.favoriteMessageNumber;
  String loverNumber = settings.loverNumber;
  List<String> favoriteMessage = settings.favoriteMessageNumber as List<String>;
  var jsonData;//from the JSON
  TextEditingController newLoverNumber = new TextEditingController();
  TextEditingController lovertypedMessage = new TextEditingController();

  Future<void> readJson() async {
    String data =  await DefaultAssetBundle.of(context).loadString("assets/justAtinyconfFile.json");
    jsonData = json.decode(data);
    jsonData.forEach((item){
      item.forEach((key, value){
        if(key=="loverNumber"){
          loverNumber = value.toString();
          print(loverNumber+': loverNumber from json');
        }
        if(key=="score"){
          _counter = value;
          print(_counter.toString() + ': number of messages from json');
        }
        if(key=="score"){
          _counter = value;
          print(_counter.toString() + ': number of messages from json');
        }
        if(key=="favoriteMessageNumber"){
         favoriteMessageIndex = value;
          print(favoriteMessageIndex.toString() + ': <-- number of the favorite message that will be send');
        }
        if(key=="favoriteMessage") {
          for(int i=0;i<value.length;i++){
            favoriteMessage.add(value[i]);
          }
          print(favoriteMessage.toString() + ': This is the premade/favourite messages from the JSON');
        }
        });
    });
  }

  //TO DO update JSON function

//POP-UP here to send the Message

  Future<void> onheartClicked() async {
    readJson();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Envoyer ce texte ???', textAlign: TextAlign.center,),
          content: SingleChildScrollView(
            child: TextField(
              controller: lovertypedMessage,
              decoration: InputDecoration(

                fillColor: Colors.black,
                hintText: 'Je t\'aime',

              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Envoyer'),
              onPressed: () {
                //envoyer le msg
                print(lovertypedMessage.text);
                if(lovertypedMessage.text == null || lovertypedMessage.text ==""){
                  print("Message vide.. le message sera remplacé par un message de base ");
                  print(loverNumber);
                  onSendButton_Two("Petit coucou depuis lovler jtm ❤️");
                }
                else if(lovertypedMessage.text != null || lovertypedMessage.text != ""){
                  onSendButton_Two(lovertypedMessage.text);
                  setState(() {
                    _counter++;
                  });
                }


                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Envoyer le msg favoris'),
              onPressed: () {
                //envoyer le msg
                onSendButton_Two(favoriteMessage[favoriteMessageIndex]);
                setState(() {
                  _counter++;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  /*Future<void> onheartClicked() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(

          title: const Text('Envoyer ce texte ??', textAlign: TextAlign.center,),
          content: SingleChildScrollView(
            child: TextFormField(
              controller: null,
              initialValue: favoriteMessage[favoriteMessageIndex],
              decoration: InputDecoration(
                fillColor: Colors.black,
                hintText: 'Exemple: Je t\'aime',
              ),
            ),
          ),
          actions: <Widget>[

            TextButton(
              child: const Text('Envoyer'),
              onPressed: () {
                //onSendButton("Je t'aime", ['0637584960']);
                onSendButton_Two("coucou pierre", loverNumber);
                print("hahahaha");
                setState(() {
                  _counter++;
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Envoyer le message favoris'),
              onPressed: () {
                //onSendButton("Je t'aime", ['0637584960']);
                onSendButton_favorite(favoriteMessage[2].toString(), loverNumber);
                print("hahahaha");
                setState(() {
                  _counter++;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }*/


  void onSendButton_Two(String message) async {
    var status = await Permission.sms.status;
    if (status.isDenied) {
      if (await Permission.sms.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
      }
    }
    // You can can also directly ask the permission about its status.
    if (await Permission.sms.isRestricted) {
      print("La demande d'accès aux sms est bloqué (exemple:controle parental)");// The OS restricts access, for example because of parental controls.
    }
    SmsStatus result = await BackgroundSms.sendMessage(
        phoneNumber: loverNumber, message: message, simSlot: 1);

    if (result == SmsStatus.sent) {
      print("Sent");
    } else {
      print("Failed");
    }
  }




  void onSendButton_favorite(String message, String phoneNumber) async {
    var status = await Permission.sms.status;
    if (status.isDenied) {
      if (await Permission.sms.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
      }
    }
    // You can can also directly ask the permission about its status.
    if (await Permission.sms.isRestricted) {
      print("La demande d'accès aux sms est bloqué (exemple:controle parental)");// The OS restricts access, for example because of parental controls.
    }
    SmsStatus result = await BackgroundSms.sendMessage(
        phoneNumber: phoneNumber, message: favoriteMessage[favoriteMessageIndex], simSlot: 1);

    if (result == SmsStatus.sent) {
      print("Sent");
    } else {
      print("Failed");
    }
  }





  void onSendButton(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }
  //faire
  Future<void> onviewFavMessage() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ajouter le numéro de la personne que vous aimez', textAlign: TextAlign.center,),
          content: SingleChildScrollView(
            child: DataTable(rows: [

            ], columns: [
              DataColumn(label: Text("Les messages")),
              DataColumn(label: Text("Actions"))],

        )
          )
        );
      },
    );
  }
  Future<void> onPlusClicked() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ajouter le numéro de la personne que vous aimez', textAlign: TextAlign.center,),
          content: SingleChildScrollView(
            child: TextField(
              autofillHints: [AutofillHints.telephoneNumber],
              controller: newLoverNumber,
              decoration: InputDecoration(
                fillColor: Colors.black,
                hintText: '0621158513',

              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Valider'),
              onPressed: () {
                loverNumber = newLoverNumber.text;
                setState(() {
                  loverNumber = newLoverNumber.text;
                  print(loverNumber+"ICI");
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //décrire l'interface
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.lightBlue,

//child: Text("Vous avez envoyé :"+ _counter.toString() +" Message d'amour"),
      body:Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image:  AssetImage('assets/images/loveler_backgroung_test.jpg'),
                fit: BoxFit.cover,
                scale: 0.9
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(" "),
            Text(" "),
            Text(" "),//just here to make the text down
            Text(" "),
            Text("Vous avez envoyé :"+ _counter.toString() +" Message d'amour",
            style: TextStyle(
              fontSize: 25,
              color: Colors.white
            ),
            textAlign: TextAlign.center,),
            //FlutterLogo( size:160,)
          ],
        )


      ),


      drawer: Drawer(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Say that you are lovler',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
            Text('Settings'),
            Text('Qui suissssss-je ?'),
            Text('Doaaaans ?')
          ],
        ),
      ),





      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink.shade300,

        onPressed: onheartClicked,
          child: Icon(Icons.favorite_border),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(

        color: Colors.pink.shade300,
        child: Container(
          height: 75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.history_edu_rounded,
                  color: Colors.white,
                ),
                onPressed: onviewFavMessage,
              ),
              IconButton(
                icon: Icon(
                  Icons.library_add,
                  color: Colors.white,
                ),
                onPressed: onPlusClicked,
              ),

            ],
          ),
        ),
        shape : CircularNotchedRectangle(),
      ),


      //continue interface here

    );
  }
}
