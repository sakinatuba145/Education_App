class UserModel {
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
    this.imageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      position: json['position'] ?? '',
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'position': position,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }
}
