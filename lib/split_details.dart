import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hy_visa/split_participant.dart';
import 'package:hy_visa/split_payment.dart';
import 'package:hy_visa/user.dart';
import 'globals.dart' as globals;

class SplitDetailsPage extends StatefulWidget {
  @override
  State createState() => new _SplitDetailsPageState();
}

class _SplitDetailsPageState extends State<SplitDetailsPage>  {

  final activeSplitPaymentRef = FirebaseDatabase.instance.reference().child('splitPayments').child(globals.user.uid).child(globals.activeSplitPayment);

  double _totalAmount;

  List<SplitParticipant> _participants = new List<SplitParticipant>();

  @override
  void initState() {
    super.initState();

    activeSplitPaymentRef.once().then((DataSnapshot snapshot) {
      _totalAmount = snapshot.value['totalAmount'].toDouble();

      var userName;

      snapshot.value['participants'].keys.forEach((dynamic key)
      {
          FirebaseDatabase.instance.reference()
          .child('users')
          .child(key)
          .once().then((DataSnapshot ds) {
            userName = ds.value['name'];


            User myUser = User(key as String, userName as String);

            SplitParticipant p = SplitParticipant(myUser, double.parse(((snapshot.value['participants'][key]['amount'].toDouble()).toStringAsFixed(2))), snapshot.value['participants'][key]['status']);

            _participants.add(p);
            setState(() {});
          });
      });
    });

  }

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
