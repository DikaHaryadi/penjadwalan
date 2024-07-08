import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../constant/storage_util.dart';

class RootpageDriver extends StatelessWidget {
  const RootpageDriver({super.key});

  @override
  Widget build(BuildContext context) {
    final storageUtil = StorageUtil();
    return Scaffold(
      body: Obx(
        () => storageUtil.widgetOptionsDriver[storageUtil.selectedIndex.value],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: storageUtil.selectedIndex.value,
        onTap: storageUtil.onItemTapped,
        elevation: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        unselectedItemColor: const Color(0xFF526480),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () => storageUtil.onItemTapped(0),
              child: const Icon(Iconsax.menu),
            ),
            activeIcon: const Icon(Iconsax.menu),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () => storageUtil.onItemTapped(1),
              child: const Icon(Iconsax.activity),
            ),
            activeIcon: const Icon(Iconsax.activity),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () => storageUtil.onItemTapped(2),
              child: const Icon(Iconsax.user),
            ),
            activeIcon: const Icon(Iconsax.personalcard),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
