class Member {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final int? age;
  final String? gender;
  final bool isVerified;
  final String createdAt;
  final String updatedAt;

  Member({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    required this.gender,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      age: json['age'],
      gender: json['gender'],
      isVerified: json['isVerified'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}