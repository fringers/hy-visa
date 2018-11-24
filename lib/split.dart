import 'package:flutter/material.dart';

class SplitPage extends StatelessWidget  {

  String _totalAmount = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Split payment'),
      ),
      body: Container(
        padding: new EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: new EdgeInsets.only(bottom: 30),
              child:
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Total amount',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (String value) {
                    this._totalAmount = value;
                  }
                ),
            ),
            Row(
              children: <Widget>[
                Text('Participants')
              ]
            ),
            Expanded(
              child:
                ListView(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Robert Kuna'),
                    ),
                    Text('Friends'),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Konrad Kraszewski'),
                      trailing: const Icon(Icons.add),
                    ),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Aleksander Surman'),
                      trailing: const Icon(Icons.add),
                    ),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Jakub Król'),
                      trailing: const Icon(Icons.add),
                    ),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Patryk Lizoń'),
                      trailing: const Icon(Icons.add),
                    ),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Fabian Kapuścik'),
                      trailing: const Icon(Icons.add),
                    ),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Krystyna Gruba'),
                      trailing: const Icon(Icons.add),
                    ),
                  ],
                )
            ),
            RaisedButton(
              child: Text('Save'),
            )
          ],
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
