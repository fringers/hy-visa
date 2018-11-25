import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hy_visa/confirm.dart';
import 'package:hy_visa/split.dart';
import 'globals.dart' as globals;
import 'dart:async';
import 'package:flutter/services.dart';

void main() => runApp(HyVisaApp());

final _color = const Color(0xFF1A1F70);
final _colorY = const Color(0xFFF7B600);

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
  bool isLoading = false;

  String _email = '';
  String _password = '';

  Future<void> _handleSignIn() async {
    isLoading = true;
    setState(() {});
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
    isLoading = false;
    setState(() {});
  }

  void watchForSplitInvitations() {
    FirebaseDatabase.instance
        .reference()
        .child('externalSplitPayments')
        .child(globals.user.uid)
        .onChildAdded
        .listen((Event e) {
      if (e.snapshot.value['status'] != 'pending') return;

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

  _buildProgressBarTile() {
    return new LinearProgressIndicator(
      backgroundColor: _colorY,
    );
  }

  @override
  Widget build(BuildContext context) {
    print('isLoading');

    return Scaffold(
        appBar: AppBar(
          backgroundColor: _color,
          title: Text(widget.title),
        ),
        body: ListView(
          children: <Widget>[
            (isLoading) ? _buildProgressBarTile() : new Container(),
            Container(
              height: 90,
              margin: const EdgeInsets.only(top: 48),
              child: Center(
                  child: Image.asset(
                "assets/img/visa.png",
              )),
            ),
            Container(
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
                    Container(
                      margin: const EdgeInsets.only(top: 36),
                    ),
                    SizedBox(
                      width: 100.0,
                      height: 48.0,
                      child: RaisedButton(
                        child: Text('Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            )),
                        color: _color,
                        elevation: 4.0,
                        onPressed: () {
                          print('Login: ' + this._email + " " + this._password);
                          _handleSignIn().catchError((e) => print(e));
                        },
                      ),
                    )
                  ],
                ))
          ],
        ));
  }
}
