import 'package:hy_visa/split_participant.dart';
import 'package:uuid/uuid.dart';

class SplitPayment {
  var key;
  var status;
  var totalAmount;
  List<SplitParticipant> participants; // todo map here [splitparticipant.user.uid]splitpartiipant
  // Map<String, SplitParticipant> participants;

  SplitPayment(this.totalAmount, this.participants) {
    this.status = 'active';
    var uuid = new Uuid();
    this.key = uuid.v4();
  }

  Map<String, dynamic> toJson() =>
      {
        'status': status,
        'totalAmount': totalAmount,
        'participants': participants.map((p) => p.toJson()).toList()
      };
}