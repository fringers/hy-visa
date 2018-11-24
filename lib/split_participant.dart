import 'package:hy_visa/user.dart';

class SplitParticipant {
  SplitParticipant(User user, double amount, String status) {
    this.user = user;
    this.amount = amount;
    this.status = status;
  }

  User user;
  double amount;
  String status;
}