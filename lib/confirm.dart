import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;

void main() {
  runApp(ConfirmScreen());
}

class ConfirmScreen extends StatelessWidget {
  ConfirmScreen({Key key, @required this.uid, @required this.id}) : super(key: key);

  String uid;
  String id;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ConfirmPage(title: 'Confirm data exchange', uid: uid, id: id,),
    );
  }
}

class ConfirmPage extends StatefulWidget {
  ConfirmPage({Key key, this.title, @required this.uid, @required this.id}) : super(key: key);

  final String title;
  String uid;
  String id;

  @override
  _ConfirmPageState createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {

  String name = '';
  double amount = 0;

  @override
  void initState() {
    super.initState();

    print(widget.uid);
    print(widget.id);

    var splitRef = FirebaseDatabase.instance.reference()
        .child('splitPayments')
        .child(widget.uid)
        .child(widget.id)
        .child('participants')
        .child(globals.user.uid)
        .once().then((DataSnapshot ds) {
          amount = ds.value['amount'];
          setState(() {});
        });

    var userRef = FirebaseDatabase.instance.reference()
        .child('users')
        .child(widget.uid)
        .once().then((DataSnapshot ds) {
          name = ds.value['name'];
          setState(() {});
        });
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
                            // Perform some action
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
        title: Text(widget.title),
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
