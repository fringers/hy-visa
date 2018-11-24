import 'package:hy_visa/user.dart';

class SplitParticipant {
  SplitParticipant(User user, double amount) {
    this.user = user;
    this.amount = amount;
  }

  User user;
  double amount;
}