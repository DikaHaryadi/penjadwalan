import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../controllers/login_controller.dart';
import '../../theme/app_colors.dart';
import '../../constant/storage_util.dart';

class RootpageManajer extends StatefulWidget {
  const RootpageManajer({super.key});

  @override
  State<RootpageManajer> createState() => _RootpageManajerState();
}

class _RootpageManajerState extends State<RootpageManajer> {
  final loginController = Get.put(LoginController());
  final storageUtil = StorageUtil();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            storageUtil.scaffoldKey.currentState!.openDrawer();
          },
        ),
        actions: [
          IconButton(
              onPressed: () => loginController.logout(),
              icon: const Icon(Iconsax.logout))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/login_bg.jpg'),
                    fit: BoxFit.cover),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: AppColors.black.withOpacity(0.5)),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.7),
                      Colors.white.withOpacity(0.5),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56.0,
                      height: 56.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          imageUrl: storageUtil.getImage(),
                          fit: BoxFit.cover,
                          progressIndicatorBuilder: (_, __, ___) =>
                              const CircularProgressIndicator(),
                          errorWidget: (_, __, ___) => const Icon(Icons.error),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FittedBox(
                          child: Text(
                            storageUtil.getName(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                        Text(
                          'Name : ${storageUtil.getName()}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.black,
                          ),
                        ),
                        Text(
                          'Roles : ${storageUtil.getRoles()}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              selected: storageUtil.selectedIndex.value == 0,
              onTap: () {
                storageUtil.onItemTapped(0);
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('Profile'),
              selected: storageUtil.selectedIndex.value == 1,
              onTap: () {
                storageUtil.onItemTapped(1);
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
      key: storageUtil.scaffoldKey,
      body: Center(
        child: storageUtil.widgetOptionsManajer
            .elementAt(storageUtil.selectedIndex.value),
      ),
    );
  }
}
