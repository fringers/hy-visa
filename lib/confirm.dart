import 'package:flutter/material.dart';

void main() {
  runApp(ConfirmScreen());
}

class ConfirmScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ConfirmPage(title: 'Confirm data exchange'),
    );
  }
}

class ConfirmPage extends StatefulWidget {
  ConfirmPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ConfirmPageState createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
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
                child: Text('Fabian Kapuścik',
                    style:
                        TextStyle(fontWeight: FontWeight.w300, fontSize: 20))),
          ),
          Container(
            margin: const EdgeInsets.only(top: 16),
          ),
          ListTile(
            title: Center(
                child: Text('60 zł',
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
