import 'package:flutter/material.dart';

class User {
  User(String uid, String name) {
    this.uid = uid;
    this.name = name;
  }

  String uid;
  String name;
}

class SplitParticipant {
  SplitParticipant(User user, double amount) {
    this.user = user;
    this.amount = amount;
  }

  User user;
  double amount;
}

class SplitPage extends StatefulWidget {
  @override
  State createState() => new _SplitPageState();
}

class _SplitPageState extends State<SplitPage>  {

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
    _participants.add(SplitParticipant(user, 0));
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

  void request() {
    double amount = _totalAmount / (_participants.length + 1);
    _participants.forEach((SplitParticipant sp) => sp.amount = amount);

    // TODO: add to DB
    // _participants - lista participantów
    // _participants[i].amount - kwota dla participanta
    // _participants[i].user.uid - uid participanta
    print('REQUEST!!!!!');
  }

  bool requestDisabled() {
    print(_totalAmount);
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
}
