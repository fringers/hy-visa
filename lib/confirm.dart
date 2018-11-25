import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hy_visa/split.dart';
import 'globals.dart' as globals;


class ConfirmPage extends StatefulWidget {
  ConfirmPage({Key key, @required this.id, @required this.uid, @required this.txId}) : super(key: key);

  String id;
  String uid;
  String txId;

  @override
  _ConfirmPageState createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {

  String name = '';
  double amount = 0;

  @override
  void initState() {
    super.initState();

    print("UID: " + widget.uid);
    print("TxID: " + widget.txId);

    FirebaseDatabase.instance.reference()
        .child('splitPayments')
        .child(widget.uid)
        .child(widget.txId)
        .child('participants')
        .child(globals.user.uid)
        .once().then((DataSnapshot ds) {
          amount = ds.value['amount'].toDouble();
          setState(() {});
        });

    FirebaseDatabase.instance.reference()
        .child('users')
        .child(widget.uid)
        .once().then((DataSnapshot ds) {
          name = ds.value['name'];
          setState(() {});
        });
  }

  void confirm() {
    FirebaseDatabase.instance
        .reference()
        .child('externalSplitPayments')
        .child(globals.user.uid)
        .child(widget.id)
        .child('status')
        .set('confirmed');

    FirebaseDatabase.instance
        .reference()
        .child('splitPayments')
        .child(widget.uid)
        .child(widget.txId)
        .child('participants')
        .child(globals.user.uid)
        .child('status')
        .set('confirmed');

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var card = SizedBox(
      // height: 210.0,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 24),
          ),
          Stack(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/img/janek.png'),
                radius: 76.0,
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 16),
          ),
          ListTile(
            title: Center(
                child: Text(name,
                    style:
                        TextStyle(fontWeight: FontWeight.w300, fontSize: 20))),
          ),
          Container(
            margin: const EdgeInsets.only(top: 16),
          ),
          ListTile(
            title: Center(
                child: Text(amount.toString() + ' zł',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w500,
                      fontSize: 56,
                    ))),
          ),
          Container(
            margin: const EdgeInsets.only(top: 56),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                      margin: const EdgeInsets.only(left: 12, right: 12),
                      child: SizedBox(
                        width: 138.0,
                        height: 64.0,
                        child: RaisedButton(
                          child: Text('YES',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                              )),
                          color: Theme.of(context).accentColor,
                          elevation: 4.0,
                          onPressed: () {
                            confirm();
                          },
                        ),
                      ))
                ],
              ),
              Column(
                children: [
                  Container(
                      margin: const EdgeInsets.only(left: 12, right: 12),
                      child: SizedBox(
                        width: 138.0,
                        height: 64.0,
                        child: RaisedButton(
                          child: Text('NO',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                              )),
                          color: Colors.redAccent,
                          elevation: 4.0,
                          onPressed: () {
                            // Perform some action
                          },
                        ),
                      ))
                ],
              ),
            ],
          )
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Confirm split"),
      ),
      body: Center(
        child: card,
      ),
    );
  }
}

// Container(
//       margin: const EdgeInsets.only(top: 8.0),
//       child: Text(
//         label,
//         style: TextStyle(
//           fontSize: 12.0,
//           fontWeight: FontWeight.w400,
//           color: color,
//         ),
//       ),
//     ),
