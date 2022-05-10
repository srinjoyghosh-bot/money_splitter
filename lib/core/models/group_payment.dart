import 'package:money_manager/core/models/user.dart';

class GroupPayment {
  final double totalAmount;

  // final DateTime dateTime;
  final List<User> participants;

  GroupPayment({
    required this.totalAmount,
    // required this.dateTime,
    required this.participants,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': totalAmount,
      'participants': List.from(participants.map((e) => e.toJson())),
    };
  }
}
