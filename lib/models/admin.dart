class Admins {
  final String id;
  final String name;
  final String email;
  final String username;
  final String createdAt;
  final String updatedAt;

  Admins({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Admins.fromJson(Map<String, dynamic> json) {
    return Admins(
      id: json['id'],
      name: json['username'],
      email: json['email'],
      username: json['username'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}