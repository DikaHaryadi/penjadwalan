import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  String name;
  String telp;
  String email;
  String image;
  String roles;

  UserModel({
    required this.id,
    required this.name,
    required this.telp,
    required this.email,
    required this.image,
    required this.roles,
  });

  String get nameUser => name;

  static UserModel empty() => UserModel(
        id: '',
        name: '',
        telp: '',
        email: '',
        image: '',
        roles: '',
      );

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Telp': telp,
      'Email': email,
      'Image': image,
      'Roles': roles,
    };
  }

  // Factory method to create a UserModel from a Firebase document snapshot
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data();
      return UserModel(
        id: document.id,
        name: data?['Name'] ?? '',
        telp: data?['Telp'] ?? '',
        email: data?['Email'] ?? '',
        image: data?['Image'] ?? '',
        roles: data?['Roles'] ?? '',
      );
    } else {
      return UserModel.empty();
    }
  }
}
