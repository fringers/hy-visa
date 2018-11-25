import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hy_visa/split.dart';
import 'globals.dart' as globals;

import 'package:flutter/services.dart';

Future<void> _getBatteryLevel(BuildContext context) async {
  const platform =
      const MethodChannel('samples.flutter.io/getBluetoothMacAddress');
  try {
    print("dupadupa1");
    final String bluetoothMacAddress =
        await platform.invokeMethod('getBluetoothMacAddress');

    print("dupadupa2s");

    final userRef = FirebaseDatabase.instance
        .reference()
        .child('users')
        .child(globals.user.uid);
    userRef.child('bluetoothMac').set(bluetoothMacAddress);
  } on PlatformException catch (e) {
    print("Failed to get battery level: '${e.message}'.");
  }

  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SplitPage()),
  );
}

class BluePostMAC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _getBatteryLevel(context);

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Center(child: new CircularProgressIndicator()),
      ),
    );
  }
}
