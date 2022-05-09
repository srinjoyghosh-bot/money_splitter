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

  Map<String, dynamic> toJson() {
    return {
      'id': uid,
      'name': name,
      'username': username,
      'email': email,
      'password': password,
      'phone': phone,
      'upi': upiId,
      'groups': List.from(groupIds.map((e) => {'id': e})),
    };
  }
}
