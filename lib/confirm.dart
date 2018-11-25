import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hy_visa/split.dart';
import 'globals.dart' as globals;

final _color = const Color(0xFF1A1F70);
final _colorY = const Color(0xFFDEA300);
final _colorY2 = const Color(0xFFF7B600);

class ConfirmPage extends StatefulWidget {
  ConfirmPage(
      {Key key, @required this.id, @required this.uid, @required this.txId})
      : super(key: key);

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

    FirebaseDatabase.instance
        .reference()
        .child('splitPayments')
        .child(widget.uid)
        .child(widget.txId)
        .child('participants')
        .child(globals.user.uid)
        .once()
        .then((DataSnapshot ds) {
      amount = double.parse(ds.value['amount'].toDouble().toStringAsFixed(2));
      setState(() {});
    });

    FirebaseDatabase.instance
        .reference()
        .child('users')
        .child(widget.uid)
        .once()
        .then((DataSnapshot ds) {
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
                      color: _colorY2,
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
                          color: _color,
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
                          color: Colors.red,
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
        backgroundColor: _color,
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
