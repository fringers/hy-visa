import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hy_visa/split_participant.dart';
import 'package:hy_visa/user.dart';
import 'globals.dart' as globals;

class SplitDetailsPage extends StatefulWidget {
  @override
  State createState() => new _SplitDetailsPageState();
}

class _SplitDetailsPageState extends State<SplitDetailsPage>  {

  final activeSplitPaymentRef = FirebaseDatabase.instance.reference().child('splitPayments').child(globals.user.uid).child(globals.activeSplitPayment);

  // TODO: get from DB
  double get _totalAmount => 36.89;

  // TODO: get from DB
  List<SplitParticipant> _participants = [
    SplitParticipant(User('UID1', 'Konrad Kraszewski'), 12.38, 'pending'),
    SplitParticipant(User('UID2', 'Robert Kuna'), 8.00, 'pending'),
    SplitParticipant(User('UID3', 'Patryk Lizoń'), 38.99, 'accepted'),
    SplitParticipant(User('UID4', 'Aleksander Surman'), 6.66, 'pending'),
  ];

  // List<SplitParticipant> _participants = activeSplitPaymentRef.once()

  _activeSplitPaymentChanged(Event event) {
    print("#### ACTIVE SPLIT PAYMENT CHANGED");
  }

  Widget buildListItem(BuildContext ctx, int index) {
    activeSplitPaymentRef.onChildAdded.listen(_activeSplitPaymentChanged);
    final item = _participants[index];

    return ListTile(
      leading: Icon(Icons.person),
      title: Text(item.user.name),
      subtitle: Text(item.amount.toString() + " PLN"),
      trailing: Text(item.status),
    );
  }

  void request() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Split payment details'),
      ),
      body: Container(
        padding: new EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: new EdgeInsets.only(bottom: 30),
              child:
                Text("Total amount: " + _totalAmount.toString()),
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
          ],
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
