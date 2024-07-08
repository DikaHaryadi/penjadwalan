import 'package:example/screens/berita.dart';
import 'package:example/screens/manajer/homepage_manajer.dart';
import 'package:example/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../screens/driver/homepage_driver.dart';
import '../utils/loader/snackbar.dart';

class StorageUtil {
  final prefs = GetStorage();

  String getName() {
    return prefs.read('Name') ?? '';
  }

  String getTelp() {
    return prefs.read('Telp') ?? '';
  }

  String getEmail() {
    return prefs.read('Email') ?? '';
  }

  String getImage() {
    return prefs.read('Image') ?? '';
  }

  String getRoles() {
    return prefs.read('Roles') ?? '';
  }

  void saveUserDetails({
    required String name,
    required String tlp,
    required String email,
    required String image,
    required String roles,
  }) {
    prefs.write('Name', name);
    prefs.write('Telp', tlp);
    prefs.write('Email', email);
    prefs.write('Image', image);
    prefs.write('Roles', roles);
  }

  final selectedIndex = 0.obs;

  List<Widget> widgetOptionsManajer = const [
    HomepageManajer(),
    BeritaScreen(),
    ProfileScreen(),
  ];

  List<Widget> widgetOptionsDriver = const [
    HomepageDriver(),
    BeritaScreen(),
    ProfileScreen(),
  ];

  onItemTapped(int index) {
    selectedIndex.value = index;
  }

  void logout() {
    prefs.remove('Name');
    prefs.remove('Telp');
    prefs.remove('Email');
    prefs.remove('Image');
    prefs.remove('Roles');
    Get.offAllNamed('/');
    SnackbarLoader.successSnackBar(
      title: 'Logged Out',
      message: 'You have been logged out successfully.',
    );
  }
}
