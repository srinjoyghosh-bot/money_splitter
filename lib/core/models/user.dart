class User {
  final String uid;
  final String name;
  final String username;
  final String email;
  final String password;
  final String phone;
  final String upiId;
  List<String> groupIds = [];

  User({
    required this.uid,
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    required this.phone,
    required this.upiId,
  });
}
