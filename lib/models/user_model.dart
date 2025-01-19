import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String telp;
  String email;
  String image;
  String roles;

  UserModel({
    required this.name,
    required this.telp,
    required this.email,
    required this.image,
    required this.roles,
  });

  String get nameUser => name;

  static UserModel empty() => UserModel(
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
