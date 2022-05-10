class User {
  final String uid;
  final String name;
  final String username;
  final String email;
  final String password;
  final String phone;
  final String upiId;
  List<String>? groupIds;

  User({
    required this.uid,
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    required this.phone,
    required this.upiId,
    this.groupIds,
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
      'groups':
          groupIds != null ? List.from(groupIds!.map((e) => {'id': e})) : null,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      upiId: json['upi'],
      groupIds: json['groups'] != null
          ? List.from(json['groups'].map((e) => e['id']))
          : null,
    );
  }
}
