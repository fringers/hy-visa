import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hy_visa/animation.dart';
import 'package:hy_visa/split_participant.dart';
import 'package:hy_visa/split_payment.dart';
import 'package:hy_visa/user.dart';
import 'globals.dart' as globals;

class SplitDetailsPage extends StatefulWidget {
  @override
  State createState() => new _SplitDetailsPageState();
}

final _color = const Color(0xFF1A1F70);
final _colorY = const Color(0xFFF7B600);
final _colorY2 = const Color(0xFFDEA300);

class _SplitDetailsPageState extends State<SplitDetailsPage> {
  final activeSplitPaymentRef = FirebaseDatabase.instance
      .reference()
      .child('splitPayments')
      .child(globals.user.uid)
      .child(globals.activeSplitPayment);

  double _totalAmount;

  List<SplitParticipant> _participants = new List<SplitParticipant>();

  @override
  void initState() {
    super.initState();

    activeSplitPaymentRef.once().then(_parseSnapshot);
  }

  _parseSnapshot(DataSnapshot snapshot) {
    _totalAmount = snapshot.value['totalAmount'].toDouble();

// <<<<<<< HEAD
//       snapshot.value['participants'].keys.forEach((dynamic key) {
//         FirebaseDatabase.instance
//             .reference()
//             .child('users')
//             .child(key)
//             .once()
//             .then((DataSnapshot ds) {
//           userName = ds.value['name'];

//           UserWithBluetooth myUser =
//               UserWithBluetooth(key as String, userName as String, "");

//           SplitParticipant p = SplitParticipant(
//               myUser,
//               double.parse(
//                   ((snapshot.value['participants'][key]['amount'].toDouble())
//                       .toStringAsFixed(2))),
//               snapshot.value['participants'][key]['status']);

//           _participants.add(p);
//           setState(() {});
//         });
//       });
// =======
    _parseParticipants(snapshot.value['participants'], false);
  }

  _parseParticipants(dynamic data, bool update) {
    print(data);

    data.keys.forEach((dynamic key) {
      double amount =
          double.parse(((data[key]['amount'].toDouble()).toStringAsFixed(2)));
      String status = data[key]['status'];

      if (!update) {
        FirebaseDatabase.instance
            .reference()
            .child('users')
            .child(key)
            .once()
            .then((DataSnapshot ds) {
          var userName = ds.value['name'];
          UserWithBluetooth myUser =
              UserWithBluetooth(key as String, userName as String, "");

          SplitParticipant p = SplitParticipant(myUser, amount, status);

          _participants.add(p);

          _validateStatuses();

          setState(() {});
        });
      } else {
        var part = _participants
            .firstWhere((SplitParticipant sp) => sp.user.uid == key);
        part.amount = amount;
        part.status = status;

        _validateStatuses();

        setState(() {});
      }
    });
  }

  // List<SplitParticipant> _participants = activeSplitPaymentRef.once()

  _activeSplitPaymentChanged(Event event) {
    print("#### ACTIVE SPLIT PAYMENT CHANGED");

    print(event.snapshot.value);
    _parseParticipants(event.snapshot.value, true);
  }

  bool redirecting = false;
  _validateStatuses() {
    if (_participants.length <= 0 || redirecting) return;

    if (_participants
        .every((SplitParticipant sp) => sp.status == 'confirmed')) {
      redirecting = true;
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CustomAnimation(), fullscreenDialog: true),
      );
    }
  }

  Widget buildListItem(BuildContext ctx, int index) {
    activeSplitPaymentRef.onChildChanged.listen(_activeSplitPaymentChanged);
    final item = _participants[index];

    return ListTile(
      leading: Icon(Icons.person),
      title: Text(item.user.name),
      subtitle: Text(item.amount.toString() + " PLN"),
      trailing: item.status == "pending"
          ? Icon(Icons.access_time, color: _colorY2)
          : Icon(Icons.check_circle, color: _color),
    );
  }

  void request() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Split payment details'),
        backgroundColor: _color,
      ),
      body: Container(
        padding: new EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: new EdgeInsets.only(bottom: 30),
              child: Text("Total amount: " + _totalAmount.toString()),
            ),
            Row(children: <Widget>[Text('Participants')]),
            Expanded(
              child: ListView.builder(
                itemCount: _participants.length,
                itemBuilder: buildListItem,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
