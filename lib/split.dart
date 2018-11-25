import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hy_visa/split_payment.dart';
import 'package:hy_visa/split_details.dart';
import 'package:hy_visa/split_participant.dart';
import 'package:hy_visa/user.dart';
import 'globals.dart' as globals;
import 'dart:async';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:hy_visa/blue_example.dart';

class SplitPage extends StatefulWidget {
  @override
  State createState() => new _SplitPageState();
}

class _SplitPageState extends State<SplitPage> {
  // bluetooth
  FlutterBlue _flutterBlue = FlutterBlue.instance;

  // Scanning
  StreamSubscription _scanSubscription;
  Map<DeviceIdentifier, ScanResult> scanResults = new Map();
  bool isScanning = false;
  bool _wasScanned = false;
  bool _finishedScanning = false;

  // State
  StreamSubscription _stateSubscription;
  BluetoothState state = BluetoothState.unknown;

  // Device
  BluetoothDevice device;
  bool get isConnected => (device != null);
  StreamSubscription deviceConnection;
  StreamSubscription deviceStateSubscription;
  List<BluetoothService> services = new List();
  Map<Guid, StreamSubscription> valueChangedSubscriptions = {};
  BluetoothDeviceState deviceState = BluetoothDeviceState.disconnected;
  // end bluetooth

  final splitPaymentsRef = FirebaseDatabase.instance
      .reference()
      .child('splitPayments')
      .child(globals.user.uid);
  final usersRef = FirebaseDatabase.instance.reference().child('users');
  List<SplitPayment> splitPayments = new List();

  double _totalAmount = 0;
  List<SplitParticipant> _participants = List<SplitParticipant>();

  List<UserWithBluetooth> _friends = List();

  @override
  void initState() {
    super.initState();

    _flutterBlue.state.then((s) {
      setState(() {
        state = s;
      });
    });
    // Subscribe to state changes
    _stateSubscription = _flutterBlue.onStateChanged().listen((s) {
      setState(() {
        state = s;
      });
    });

    usersRef.once().then((DataSnapshot ds) {
      _startScan();
      ds.value.keys
          .where((dynamic key) => key != globals.user.uid)
          .forEach((dynamic key) => _friends.add(dataSnapshotToUser(key, ds)));
      setState(() {});
    });
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    _stateSubscription = null;
    _scanSubscription?.cancel();
    _scanSubscription = null;
    deviceConnection?.cancel();
    deviceConnection = null;
    super.dispose();
  }

  // bluetooth start

  _startScan() {
    _wasScanned = true;
//    print("STAAAAAAAAART");
    _scanSubscription = _flutterBlue
        .scan(
      timeout: const Duration(seconds: 8),
      /*withServices: [
          new Guid('0000180F-0000-1000-8000-00805F9B34FB')
        ]*/
    )
        .listen((scanResult) {
      // print('localName: ${scanResult.advertisementData.localName}');
//      print(
//          'manufacturerData: ${scanResult.advertisementData.manufacturerData}');
      // print('serviceData: ${scanResult.advertisementData.serviceData}');
      setState(() {
        scanResults[scanResult.device.id] = scanResult;
      });
    }, onDone: _stopScan);

    setState(() {
      isScanning = true;
    });
  }

  _stopScan() {
//    print("STOOOOOOOOOOOOOOOP");
    _finishedScanning = true;
    _scanSubscription?.cancel();
    _scanSubscription = null;
    setState(() {
      isScanning = false;
    });
  }

  _buildScanResultTiles() {
//    print('testes build build ' + isScanning.toString());
    return scanResults.values.map((r) => ScanResultTile(result: r)).toList();
  }

  _buildProgressBarTile() {
    return new LinearProgressIndicator();
  }

  _buildAlertTile() {
    return new Container(
      color: Colors.redAccent,
      child: new ListTile(
        title: new Text(
          'Bluetooth adapter is ${state.toString().substring(15)}',
          style: Theme.of(context).primaryTextTheme.subhead,
        ),
        trailing: new Icon(
          Icons.error,
          color: Theme.of(context).primaryTextTheme.subhead.color,
        ),
      ),
    );
  }

  // bluetooth end

  void addParticipant(UserWithBluetooth user) {
    _participants.add(SplitParticipant(user, 0, 'pending'));
    setState(() {});
  }

  void removeParticipant(SplitParticipant participant) {
    _participants.remove(participant);
    setState(() {});
  }

  List<UserWithBluetooth> notInvited() {
    return _friends
        .where((UserWithBluetooth user) => _participants
            .every((SplitParticipant sp) => sp.user.uid != user.uid))
        .toList();
  }

  Widget buildListItem(BuildContext ctx, int index) {
    if (index < _participants.length) {
      final item = _participants[index];
      print(item.toString());

      return ListTile(
        leading: Icon(Icons.person),
        title: Text(item.user.name),
        trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => removeParticipant(item)),
      );
    } else if (index == _participants.length) {
      return ListTile(
        title: Text("Friends"),
      );
    } else {
      final item = notInvited()[index - _participants.length - 1];

      // if (_finishedScanning) {
      // TODO: najlepiej wywołać tu jakoś addParticipant(id_ziomka) jeśli będzie miał takie samo bluetooth jak ze scanResults
      // TODO: idę spać król, naprawiłem nawigację już przynajmniej
      // TODO: nie wiem czy jest jakiś .then po builderze, można by było uruchomić pętlę z addParticipant() jeśli finishedScanning === true
      //   print("_finishedScanning i super ss truper" +
      //       item.bluetoothMac +
      //       "dsfsdf" +
      //       scanResults.keys.toString());
      // }

      return ListTile(
        leading: Icon(Icons.person),
        title: Text(item.name),
        trailing: IconButton(
            icon: Icon(Icons.add, color: Colors.green),
            onPressed: () => addParticipant(item)),
      );
    }
  }

  Map<String, SplitParticipant> getFrom(List<SplitParticipant> list) {
    final Map<String, SplitParticipant> m = Map<String, SplitParticipant>();

    list.forEach((sp) {
      m[sp.user.uid] = sp;
    });
    return m;
  }

  void request() async {
    double amount = _totalAmount / (_participants.length + 1);
    _participants.forEach((SplitParticipant sp) => sp.amount = amount);

//    print('REQUEST!!!!!');
    // TODO: add some loading

    await createSplitPayment(_totalAmount, getFrom(_participants));

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SplitDetailsPage()),
    );
  }

  bool requestDisabled() {
    return _totalAmount == null ||
        _totalAmount <= 0.01 ||
        _participants.length == 0;
  }

  UserWithBluetooth dataSnapshotToUser(String key, DataSnapshot ds) {
    return UserWithBluetooth(
        key, ds.value[key]['name'], ds.value[key]['bluetoothMac']);
  }

  @override
  Widget build(BuildContext context) {
    splitPaymentsRef.onChildAdded.listen(_splitPaymentAdded);
    var tiles = new List<Widget>();

    if (state != BluetoothState.on) {
      tiles.add(_buildAlertTile());
    }
    tiles.addAll(_buildScanResultTiles());

    return Scaffold(
      appBar: AppBar(
        title: Text('Split payment'),
      ),
      body: new Stack(
        children: <Widget>[
          (isScanning) ? _buildProgressBarTile() : new Container(),
          Container(
            padding: new EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('Split payment'),
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
                  child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Total amount',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (String value) {
                        if (value == null || value.trim().length == 0)
                          this._totalAmount = 0;
                        else
                          this._totalAmount =
                              double.tryParse(value.replaceAll(',', '.'));
                        setState(() {});
                      }),
                ),
                Row(children: <Widget>[Text('Participants')]),
                Expanded(
                  child: FutureBuilder<dynamic>(
                    future: scanBlue(),
                    builder: (context, snapshot) {
//                      print("update snapshot");
                      return ListView.builder(
                        itemCount: _friends.length + 1,
                        itemBuilder: buildListItem,
                      );
                    },
                  ),
                ),
                // Expanded(
                //   child: ListView.builder(
                //     itemCount: _friends.length + 1,
                //     itemBuilder: buildListItem,
                //   ),
                // ),
                // Expanded(
                //     child: new ListView(
                //   children: tiles,
                // )),
                RaisedButton(
                  child: Text('Save'),
                  onPressed: requestDisabled() ? null : request,
                )
              ],
            ),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ],
      ),
    );
  }

  Future<void> scanBlue() async {
    if (!_wasScanned) await _startScan();
  }

  _splitPaymentAdded(Event event) {
    /*setState(() {
      splitPayments.add(new SplitPayment().fromSnapshot(DataSnapshot snapshot))
    })*/
    // TODO imeplment
//    print("#### SPLIT PAYMENT ADDED TO DB!!!!!");
  }

  Future<void> createSplitPayment(var totalAmount, Map participants) async {
    SplitPayment newSplitPayment = SplitPayment(totalAmount, participants);

    for (var key in participants.keys) {
      FirebaseDatabase.instance
          .reference()
          .child('externalSplitPayments')
          .child(key)
          .push()
          .set({
        'uid': globals.user.uid,
        'id': newSplitPayment.key,
        'status': 'pending',
      });
    }

    return splitPaymentsRef
        .child(newSplitPayment.key)
        .set(newSplitPayment.toJson());
  }

  Future<void> toSplitPaymentInvite(
      var participantID, var participantAmount, var splitPaymentKey) {
    final splitPayments = FirebaseDatabase.instance
        .reference()
        .child('splitPayments')
        .child(globals.user.uid);

    return splitPayments
        .child(splitPaymentKey)
        .child('participants')
        .child(participantID)
        .set({'amount': participantAmount, 'status': 'invite_pending'});
  }

  Future<String> getS() {
    final splitPayments = FirebaseDatabase.instance
        .reference()
        .child('splitPayments')
        .child(globals.user.uid);

    //List
  }
}
