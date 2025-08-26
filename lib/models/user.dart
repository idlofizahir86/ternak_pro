class User {
  final String userId;
  final String name;
  final String email;
  final String? noTelepon;
  final int roleId;

  User({
    required this.userId,
    required this.name,
    required this.email,
    this.noTelepon,
    required this.roleId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['uid'],
      name: json['name'],
      email: json['email'],
      noTelepon: json['no_telepon'],
      roleId: json['role_id'],
    );
  }
}