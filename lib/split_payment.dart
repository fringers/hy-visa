import 'package:firebase_database/firebase_database.dart';
import 'package:hy_visa/split_participant.dart';
import 'package:uuid/uuid.dart';

class SplitPayment {
  var key = "";
  var status = "";
  var totalAmount = 0.0;
  //List<SplitParticipant> participants; // todo map here [splitparticipant.user.uid]splitpartiipant
  Map<String, SplitParticipant> participants = Map();

  SplitPayment(this.totalAmount, this.participants) {
    this.status = 'active';
    var uuid = new Uuid();
    this.key = uuid.v4();
  }


  Map<String, dynamic> toJson() =>
      {
        'status': status,
        'totalAmount': totalAmount,
        'participants': Map.fromIterable(participants.keys, value: (key) => participants[key].toJson()) //participants.map((p) => p.toJson()).toList()
      };

  /*SplitPayment.fromJson(Map<String, dynamic> json) {
    this.status = json['status'];
    this.totalAmount = json['totalAmount'];
    this.participants = json['participants'];
  }*/


}