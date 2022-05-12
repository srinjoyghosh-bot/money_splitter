class GroupPayment {
  final double totalAmount;

  // final DateTime dateTime;
  final List<String> participants;

  GroupPayment({
    required this.totalAmount,
    // required this.dateTime,
    required this.participants,
  });

  factory GroupPayment.fromJson(Map<String, dynamic> json) {
    return GroupPayment(
      totalAmount: json['amount'],
      participants: List.from(json['participants'].map((e) => e['id'])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': totalAmount,
      'participants': List.from(participants.map((e) => {'id': e})),
    };
  }
}
