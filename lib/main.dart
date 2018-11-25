import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hy_visa/nfc.dart';
import 'package:hy_visa/blue.dart';
import 'package:hy_visa/confirm.dart';
import 'package:hy_visa/api.dart';
import 'package:hy_visa/split.dart';
import 'globals.dart' as globals;
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:hy_visa/split.dart';
import 'package:flutter/services.dart';

void main() => runApp(HyVisaApp());

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

Future<void> getBluetoothMacAddress(final BuildContext context) async {
  const platform =
      const MethodChannel('samples.flutter.io/getBluetoothMacAddress');
  try {
    final String bluetoothMacAddress =
        await platform.invokeMethod('getBluetoothMacAddress');

    final userRef = FirebaseDatabase.instance
        .reference()
        .child('users')
        .child(globals.user.uid);
    userRef.child('bluetoothMac').set(bluetoothMacAddress);
    print("bluetoothMac updated!!!");
  } on PlatformException catch (e) {
    print("Failed to get battery level: '${e.message}'.");
  }

  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SplitPage()),
  );
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _email = '';
  String _password = '';

  Future<void> _handleSignIn() async {
    await _auth.signOut();
    FirebaseUser user = await _auth.currentUser();
    if (user == null) {
      user = await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
    }

    if (user != null) {
      print(user);
      globals.user = user;

      getBluetoothMacAddress(context);
      watchForSplitInvitations();
    }
  }

  void watchForSplitInvitations() {
    FirebaseDatabase.instance
        .reference()
        .child('externalSplitPayments')
        .child(globals.user.uid)
        .onChildAdded
        .listen((Event e) {
          if (e.snapshot.value['status'] != 'pending')
            return;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConfirmPage(
                  id: e.snapshot.key,
                  uid: e.snapshot.value['uid'],
                  txId: e.snapshot.value['id'],
              ),
              fullscreenDialog: true,
            ));
        });
  }

  @override
  Widget build(BuildContext context) {
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
                _handleSignIn().catchError((e) => print(e));
              },
            ),
            RaisedButton(
              child: Text('NFC_TEST'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Nfc()),
                );
              },
            ),
            RaisedButton(
              child: Text('BLUE_TEST'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FlutterBlueApp()),
                );
              },
            ),
//            RaisedButton(
//              child: Text('CONFIRM_SCREEN'),
//              onPressed: () {
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) => ConfirmScreen()),
//                );
//              },
//            ),
            RaisedButton(
              child: Text('API_EXAMPLE'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ApiExample()),
                );
              },
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
