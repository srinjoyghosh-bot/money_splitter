import 'package:money_manager/core/models/group_payment.dart';
import 'package:money_manager/core/models/member.dart';

class Group {
  final String id;
  final String name;
  List<Member> participants;
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
      participants: List<Member>.from(
        json['participants'].map(
          (e) => Member.fromJson(e),
        ),
      ),
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
      'participants': List.from(participants.map((e) => e.toJson())),
      'payments':
          payments != null ? List.from(payments!.map((e) => e.toJson())) : null,
    };
  }
}
