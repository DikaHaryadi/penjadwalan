import 'package:example/screens/manajer/homepage_manajer.dart';
import 'package:example/screens/manajer/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../screens/driver/homepage_driver.dart';
import '../screens/driver/profile_driver.dart';

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
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> widgetOptionsManajer = const [
    HomepageManajer(),
    ProfileManajer(),
  ];

  List<Widget> widgetOptionsDriver = const [
    HomepageDriver(),
    ProfileDriver(),
  ];

  onItemTapped(int index) {
    selectedIndex.value = index;
  }
}
