import 'package:hy_visa/user.dart';

class SplitParticipant {

  SplitParticipant(this.user, this.amount, this.status);

  User user;
  double amount;
  String status;

  Map<String, dynamic> toJson() =>
      {
        'amount': amount,
        'status': status
      };
}