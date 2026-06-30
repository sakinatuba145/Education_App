class UserModel {

  final String uid;
  final String name;
  final String email;
  final String position;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.position,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {

    return UserModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      position: json['position'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {

    return {
      "uid": uid,
      "name": name,
      "email": email,
      "position": position,
    };
  }
}