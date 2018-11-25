import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

class Participant {
  var amount;
  var status;

  Participant(this.amount, this.status);

  Map<String, dynamic> toJson() =>
      {
        'amount': amount,
        'status': status
      };
}

class SplitPayment {
  var key;
  var status;
  var totalAmount;
  List<Participant> participants;

  SplitPayment(this.totalAmount, this.participants) {
    this.status = 'active';
    var uuid = new Uuid();
    this.key = uuid.v4();
  }

  Map<String, dynamic> toJson() =>
      {
        'key': key,
        'status': status,
        'totalAmount': totalAmount,
        'participants': participants.map((p) => p.toJson()).toList()
      };
}

class SplitPage extends StatelessWidget  {
  final splitPaymentsRef = FirebaseDatabase.instance.reference().child('splitPayments').child('uIDA'); // TODO: add user UID here
  List<SplitPayment> splitPayments = new List();

  @override
  Widget build(BuildContext context) {
    splitPaymentsRef.onChildAdded.listen(_splitPaymentAdded);


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
            ),
            RaisedButton(
              child: Text('Create SplitPayment as UserA'),
              onPressed: () async {
                List<Participant> list = new List.from([Participant(10, 'pending'), Participant(5, 'pending')]);
                await createSplitPayment(1337, list);
              }
            ),
            RaisedButton(
                child: Text('invite userB to SplitPayment as UserA'),
                onPressed: () async {
                  // await createSplitPayment(1337);
                  print("imeplment");
                }
            ),
            RaisedButton (
              child: Text('join splitPayment as UserB'),
              onPressed: () async {
                // await toSplitPaymentInvite('uIDB', 10, splitPaymentKey)
                print("not implemented");
              },
            )
          ],
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _splitPaymentAdded(Event event) {
    /*setState(() {
      splitPayments.add(new SplitPayment().fromSnapshot(DataSnapshot snapshot))
    })*/
    // TODO imeplment
    print("#### SPLIT PAYMENT ADDED TO DB!!!!!");
  }

  Future<void> createSplitPayment(var totalAmount, List<Participant> participants) { // TODO: @krol chcesz tu od razu podawac tez opcjonalnie liste participants czy w oddzielnej funkcji?

    SplitPayment newSplitPayment = SplitPayment(totalAmount, participants);

    return splitPaymentsRef.set(newSplitPayment.toJson());
  }

  Future<void> toSplitPaymentInvite(var participantID, var participantAmount, var splitPaymentKey) {
    final splitPayments = FirebaseDatabase.instance.reference().child('splitPayments').child('uIDA');

    return splitPayments.child(splitPaymentKey).child('participants').child(participantID).set({
      'amount' : participantAmount,
      'status' : 'invite_pending'
    });
  }

  Future<String> getS() {
    final splitPayments = FirebaseDatabase.instance.reference().child('splitPayments').child('uIDA');

    //List
  }
}
