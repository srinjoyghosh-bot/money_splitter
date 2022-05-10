import 'package:money_manager/core/models/group_payment.dart';

class Group {
  final String id;
  final String name;
  List<String>? participants;
  List<GroupPayment>? payments;

  Group({
    required this.id,
    required this.name,
    this.participants,
    this.payments,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'participants': participants != null
          ? List.from(participants!.map((e) => {'id': e}))
          : null,
      'payments':
          payments != null ? List.from(payments!.map((e) => e.toJson())) : null,
    };
  }
}
