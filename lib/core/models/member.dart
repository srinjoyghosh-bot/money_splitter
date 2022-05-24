class Member {
  String id, username;

  Member({required this.id, required this.username});

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
      };

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json['id'],
        username: json['username'],
      );
}
