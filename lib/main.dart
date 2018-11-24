import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hy_visa/split.dart';

import 'dart:async';
import 'package:flutter/services.dart';

void main() {
  runApp(new MaterialApp(home: new PlatformChannel()));
}

class PlatformChannel extends StatefulWidget {
  @override
  _PlatformChannelState createState() => new _PlatformChannelState();
}

class _PlatformChannelState extends State<PlatformChannel> {
  static const MethodChannel methodChannel =
//  const MethodChannel('samples.flutter.io/battery');
      const MethodChannel('nfc');

  //static const EventChannel eventChannel =
  //const EventChannel('samples.flutter.io/charging');

  String _cardUid = 'card uid unknown.';
  String _getVersion1 = 'getVersion1 init';
  String _getVersion2 = 'getVersion2 init';
  String _getVersion3 = 'getVersion3 init';
  String _getVersionAll = 'getVersionAll init';

  //String _chargingStatus = 'Battery status: unknown.';

  Future<Null> _getCardUID() async {
    String response;
    try {
//      final int result = await methodChannel.invokeMethod('getBatteryLevel');
      final String result = await methodChannel.invokeMethod('getCardUID');
      if (result != null) {
        response = 'Get UID: $result';
      } else {
        response = 'Get UID failed';
      }
    } on PlatformException {
      response = 'Get UID failed, PlatformException';
    }
    setState(() {
      _cardUid = response;
    });
  }

  Future<Null> _getVersionMethod(String cmd, int turn) async {
    String response;
    try {
//      final int result = await methodChannel.invokeMethod('getBatteryLevel');
      final String result =
          await methodChannel.invokeMethod('getVersion', <String, dynamic>{
        'commands': cmd,
      });
      if (result != null) {
        response = 'getVersion: $result';
        print(response);
      } else {
        response = 'getVersion failed';
      }
    } on PlatformException {
      response = 'getVersion failed, PlatformException';
    }
    setState(() {
      if (turn == 1) {
        _getVersion1 = response;
      } else if (turn == 2) {
        _getVersion2 = response;
      } else if (turn == 3) {
        _getVersion3 = response;
      } else if (turn == 4) {
        _getVersionAll = response;
      }
    });
  }

  String getVersionArray = "9060000000#90AF000000#90AF000000";

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(_cardUid, key: const Key('get uid label')),
              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: new RaisedButton(
                  child: const Text('get uid'),
                  onPressed: _getCardUID,
                ),
              ),
              new Text(_getVersion1, key: const Key('getversion1 label')),
              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: new RaisedButton(
                  child: const Text('getVersionPart1'),
                  onPressed: () => _getVersionMethod("9060000000", 1),
                ),
              ),
              new Text(_getVersion2, key: const Key('getversion2 label')),
              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: new RaisedButton(
                  child: const Text('getVersionPart2'),
                  onPressed: () => _getVersionMethod("90AF000000", 2),
                ),
              ),
              new Text(_getVersion3, key: const Key('getversion3 label')),
              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: new RaisedButton(
                  child: const Text('getVersionPart3'),
                  onPressed: () => _getVersionMethod("90AF000000", 3),
                ),
              ),
              new Text(_getVersionAll, key: const Key('getversionAll label')),
              new Padding(
                padding: const EdgeInsets.all(16.0),
                child: new RaisedButton(
                  child: const Text('getVersionAll'),
                  onPressed: () => _getVersionMethod(getVersionArray, 4),
                ),
              )
            ],
          ),
          //new Text(_chargingStatus),
        ],
      ),
    );
  }
}

class HyVisaApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HackYeah Visa',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(title: 'Login'),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _email = '';
  String _password = '';

  Future<void> _handleSignIn() async {
    FirebaseUser user = await _auth.currentUser();
    if (user == null) {
      user = await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
    }
    print("signed in " + user.email);
    if (user != null) {
      print(user);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SplitPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: new EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
                decoration: InputDecoration(
                  hintText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (String value) {
                  this._email = value;
                }),
            TextField(
              decoration: InputDecoration(hintText: 'Password'),
              obscureText: true,
              onChanged: (String value) {
                this._password = value;
              },
            ),
            RaisedButton(
              child: Text('Login'),
              onPressed: () {
                // Perform some action
                print('Login: ' + this._email + " " + this._password);
                _handleSignIn()
                    .catchError((e) => print(e));
              },
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
