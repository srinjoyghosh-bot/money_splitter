import 'package:money_manager/core/models/group_payment.dart';

class Group {
  final String id;
  final String name;
  List<String> participants;
  List<GroupPayment>? payments;

  Group({
    required this.id,
    required this.name,
    required this.participants,
    this.payments,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      participants: List<String>.from(json['participants'].map((e) => e['id'])),
      payments: json['payments'] != null
          ? List<GroupPayment>.from(
              json['payments'].map((e) => GroupPayment.fromJson(e)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'participants': List.from(participants.map((e) => {'id': e})),
      'payments':
          payments != null ? List.from(payments!.map((e) => e.toJson())) : null,
    };
  }
}
