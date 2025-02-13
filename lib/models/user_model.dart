import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String telp;
  String alamat;
  String email;
  String? password;
  String image;
  String roles;
  Timestamp? createdAt;

  UserModel({
    required this.name,
    required this.telp,
    required this.alamat,
    required this.email,
    this.password,
    required this.image,
    required this.roles,
    this.createdAt,
  });

  String get nameUser => name;

  static UserModel empty() => UserModel(
        name: '',
        telp: '',
        alamat: '',
        email: '',
        password: '',
        image: '',
        roles: '',
      );

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Telp': telp,
      'Alamat': alamat,
      'Email': email,
      'Password': password,
      'Image': image,
      'Roles': roles,
      'createdAt': createdAt,
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
        alamat: data?['Alamat'] ?? '',
        email: data?['Email'] ?? '',
        password: data?['Password'] ?? '',
        image: data?['Image'] ?? '',
        roles: data?['Roles'] ?? '',
        createdAt: data?['createdAt'],
      );
    } else {
      return UserModel.empty();
    }
  }
}
