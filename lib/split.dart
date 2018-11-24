import 'package:flutter/material.dart';

class SplitPage extends StatelessWidget  {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("asd"),
      ),
      body: Container(
        padding: new EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Split payment'
            )
          ],
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
