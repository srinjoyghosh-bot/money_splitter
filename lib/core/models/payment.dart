class Payment {
  final double amount;
  final String uidSender;
  final String uidReciever;
  String? message;
  bool isPaid = false;

  Payment({
    required this.amount,
    required this.uidSender,
    required this.uidReciever,
    this.message,
  });

  void setPaymentStatus(bool paymentStatus) {
    isPaid = paymentStatus;
  }
}
