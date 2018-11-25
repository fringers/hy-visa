class User {
  User(String uid, String name) {
    this.uid = uid;
    this.name = name;
  }

  String uid;
  String name;
}

class UserWithBluetooth {
  UserWithBluetooth(String uid, String name, String bluetoothMac) {
    this.uid = uid;
    this.name = name;
    this.bluetoothMac = bluetoothMac;
  }

  String uid;
  String name;
  String bluetoothMac;
}
