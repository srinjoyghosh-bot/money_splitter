import 'member.dart';

class GroupPayment {
  final double totalAmount;
  final String title;

  final List<Member> participants;
  final Member creator;

  GroupPayment({
    required this.totalAmount,
    required this.title,
    required this.participants,
    required this.creator,
  });

  factory GroupPayment.fromJson(Map<String, dynamic> json) {
    return GroupPayment(
      totalAmount: json['amount'].toDouble(),
      title: json['title'],
      participants: List<Member>.from(
        json['participants'].map(
          (e) => Member.fromJson(e),
        ),
      ),
      creator: Member.fromJson(json['creator']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': totalAmount,
      'title': title,
      'participants': List.from(participants.map((e) => e.toJson())),
      'creator': creator.toJson(),
    };
  }
}
