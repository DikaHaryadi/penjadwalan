import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../constant/storage_util.dart';

class RootpageAdmin extends StatelessWidget {
  const RootpageAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final storageUtil = StorageUtil();

    return Scaffold(
      body: Obx(
        () => storageUtil.widgetOptionsAdmin[storageUtil.selectedIndex.value],
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

    // return Scaffold(
    //   body: SafeArea(
    //       child: ListView(
    //     children: [
    // Padding(
    //   padding: const EdgeInsets.only(left: CustomSize.spaceBtwItems),
    //   child: Row(
    //     children: [
    //       GestureDetector(
    //         onTap: () {
    //           Get.to(() => ProfileAdmin());
    //         },
    //         child: Container(
    //           width: 56.0,
    //           height: 56.0,
    //           decoration:
    //               BoxDecoration(borderRadius: BorderRadius.circular(100)),
    //           child: ClipRRect(
    //             borderRadius: BorderRadius.circular(100),
    //             child: CachedNetworkImage(
    //               imageUrl: storageUtil.getImage(),
    //               fit: BoxFit.cover,
    //               progressIndicatorBuilder: (_, __, ___) =>
    //                   const CircularProgressIndicator(),
    //               errorWidget: (_, __, ___) => const Icon(Icons.error),
    //             ),
    //           ),
    //         ),
    //       ),
    //       const SizedBox(width: CustomSize.spaceBtwItems),
    //       Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text('👋 Hallo...',
    //               style: Theme.of(context).textTheme.headlineMedium),
    //           Text(storageUtil.getName(),
    //               style: Theme.of(context).textTheme.headlineMedium)
    //         ],
    //       ),
    //       Expanded(child: Container()),
    //       IconButton(
    //           onPressed: () => Get.toNamed('/add-user'),
    //           icon: Icon(Iconsax.user_add))
    //     ],
    //   ),
    // ),
    //     ],
    //   )),
    // );
  }
}
