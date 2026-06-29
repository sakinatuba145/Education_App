class UserModel {
final String role;
  final String uid;
  final String name;
  final String email;
  final String position;
final String? imageUrl;


  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.position,
    required this.role,
    required this.imageUrl
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {

    return UserModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      position: json['position'] ?? '',
      // role: json['role'],
        role: json['role'] ?? '',
      imageUrl: json['imageUrl']

    );
  }

bool get isStudent => role == "Student";
bool get isTeacher => role == "Teacher";
bool get isAdmin => role == "Admin";

  Map<String, dynamic> toJson() {

    return {
      "uid": uid,
      "name": name,
      "email": email,
      "position": position,
      "role": role,
      "imageUrl": imageUrl
    };
  }
}