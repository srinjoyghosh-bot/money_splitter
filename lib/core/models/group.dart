import 'package:money_manager/core/models/group_payment.dart';
import 'package:money_manager/core/models/user.dart';

class Group {
  final String id;
  final String name;
  List<User> participants = [];
  List<GroupPayment> payments = [];

  Group({
    required this.id,
    required this.name,
  });
}
