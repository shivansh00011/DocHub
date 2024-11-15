import 'dart:convert';

class UserModel {
  final String email;
  final String name;
  final String profilePic;
  final String id; // Stores _id from the backend
  final String token;

  UserModel({
    required this.email,
    required this.name,
    required this.profilePic,
    required this.id,
    required this.token,
  });

  // Convert the object to JSON format
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'profilePic': profilePic,
      'id': id,
      'token': token,
    };
  }

  // Create a UserModel instance from a Map<String, dynamic>
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      profilePic: map['profilePic'] ?? '',
      id: map['_id'] ?? '', // Map _id from backend to id
      token: map['token'] ?? '', // Extract token from the response
    );
  }

  // Create a UserModel instance from a JSON string
  factory UserModel.fromJson(String source) {
    return UserModel.fromMap(json.decode(source)); // Decode JSON string and pass to fromMap
  }

  // CopyWith method for easier updates
  UserModel copyWith({
    String? email,
    String? name,
    String? profilePic,
    String? id,
    String? token,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      id: id ?? this.id,
      token: token ?? this.token,
    );
  }
}
