import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hy_visa/split_payment.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:hy_visa/split_details.dart';
import 'package:hy_visa/split_participant.dart';
import 'package:hy_visa/user.dart';



class SplitPage extends StatefulWidget {
  @override
  State createState() => new _SplitPageState();
}

class _SplitPageState extends State<SplitPage>  {

  final splitPaymentsRef = FirebaseDatabase.instance.reference().child('splitPayments').child('uIDA'); // TODO: add user UID here
  List<SplitPayment> splitPayments = new List();


  double _totalAmount = 0;
  List<SplitParticipant> _participants = List<SplitParticipant>();

  // TODO: get this list from DB
  List<User> _friends = [
    User('UID1', 'Robert Kuna'),
    User('UID2', 'Fabian Kapuścik'),
    User('UID3', 'Jakub Król'),
    User('UID4', 'Patryk Lizoń'),
    User('UID5', 'Aleksander Surman'),
    User('UID6', 'Konrad Kraszewski'),
    User('UID7', 'Krystyna Gruba'),
  ];

  void addParticipant(User user) {
    _participants.add(SplitParticipant(user, 0, 'pending'));
    setState(() {});
  }

  void removeParticipant(SplitParticipant participant) {
    _participants.remove(participant);
    setState(() {});
  }

  List<User> notInvited() {
    return _friends.where((User user) =>
        _participants.every((SplitParticipant sp) => sp.user.uid != user.uid))
      .toList();
  }

  Widget buildListItem(BuildContext ctx, int index) {
    if (index < _participants.length) {
      final item = _participants[index];

      return ListTile(
        leading: Icon(Icons.person),
        title: Text(item.user.name),
        trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => removeParticipant(item)
        ),
      );
    } else if (index == _participants.length) {
      return ListTile(
        title: Text("Friends"),
      );
    }
    else {
      final item = notInvited()[index - _participants.length - 1];

      return ListTile(
        leading: Icon(Icons.person),
        title: Text(item.name),
        trailing: IconButton(
            icon: Icon(Icons.add, color: Colors.green),
            onPressed: () => addParticipant(item)
        ),
      );
    }
  }

  void request() async {
    double amount = _totalAmount / (_participants.length + 1);
    _participants.forEach((SplitParticipant sp) => sp.amount = amount);

    // TODO: add to DB
    // _totalAmount - total amount splita
    // _participants - lista participantów
    // _participants[i].amount - kwota dla participanta
    // _participants[i].user.uid - uid participanta

    await createSplitPayment(_totalAmount, _participants);

    print('REQUEST!!!!!');



    // TODO: push dopiero jak przejdzie save do DB
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SplitDetailsPage()),
    );
  }

  bool requestDisabled() {
    return _totalAmount == null || _totalAmount <= 0.01 || _participants.length == 0;
  }

  @override
  Widget build(BuildContext context) {
    splitPaymentsRef.onChildAdded.listen(_splitPaymentAdded);


    return Scaffold(
      appBar: AppBar(
        title: Text('Split payment'),
      ),
      body: Container(
        padding: new EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'Split payment'
            ),
            /*RaisedButton(
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
              },*/
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
                itemCount: _friends.length + 1,
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

  _splitPaymentAdded(Event event) {
    /*setState(() {
      splitPayments.add(new SplitPayment().fromSnapshot(DataSnapshot snapshot))
    })*/
    // TODO imeplment
    print("#### SPLIT PAYMENT ADDED TO DB!!!!!");
  }

  Future<void> createSplitPayment(var totalAmount, List<SplitParticipant> participants) { // TODO: @krol chcesz tu od razu podawac tez opcjonalnie liste participants czy w oddzielnej funkcji?

    SplitPayment newSplitPayment = SplitPayment(totalAmount, participants);

    return splitPaymentsRef.child(newSplitPayment.key).set(newSplitPayment.toJson());
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
