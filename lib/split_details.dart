import 'package:flutter/material.dart';
import 'package:hy_visa/split_participant.dart';

class SplitDetailsPage extends StatefulWidget {
  @override
  State createState() => new _SplitDetailsPageState();
}

class _SplitDetailsPageState extends State<SplitDetailsPage>  {

  double _totalAmount = 0;
  List<SplitParticipant> _participants = List<SplitParticipant>();

  Widget buildListItem(BuildContext ctx, int index) {
//    if (index < _participants.length) {
//      final item = _participants[index];
//
//      return ListTile(
//        leading: Icon(Icons.person),
//        title: Text(item.user.name),
//        trailing: IconButton(
//            icon: Icon(Icons.delete, color: Colors.red),
//            onPressed: () => removeParticipant(item)
//        ),
//      );
//    } else if (index == _participants.length) {
//      return ListTile(
//        title: Text("Friends"),
//      );
//    }
//    else {
//      final item = notInvited()[index - _participants.length - 1];
//
//      return ListTile(
//        leading: Icon(Icons.person),
//        title: Text(item.name),
//        trailing: IconButton(
//            icon: Icon(Icons.add, color: Colors.green),
//            onPressed: () => addParticipant(item)
//        ),
//      );
//    }
  }

  void request() {

  }

  bool requestDisabled() {
    return _totalAmount == null || _totalAmount <= 0.01 || _participants.length == 0;
  }

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
                    if (value == null || value.trim().length == 0)
                      this._totalAmount = 0;
                    else
                      this._totalAmount = double.tryParse(value.replaceAll(',', '.'));
                    setState(() {});
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
              ListView.builder(
                itemCount: _participants.length,
                itemBuilder: buildListItem,
              ),
            ),
            RaisedButton(
              child: Text('Save'),
              onPressed: requestDisabled() ? null : request,

            )
          ],
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
