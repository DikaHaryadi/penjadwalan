import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../constant/custom_size.dart';
import '../../constant/storage_util.dart';

class RootpageAdmin extends StatelessWidget {
  const RootpageAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final storageUtil = StorageUtil();

    return Scaffold(
      body: SafeArea(
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: CustomSize.spaceBtwItems),
            child: Row(
              children: [
                Container(
                  width: 56.0,
                  height: 56.0,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(100)),
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
                const SizedBox(width: CustomSize.spaceBtwItems),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('👋 Hallo...',
                        style: Theme.of(context).textTheme.headlineMedium),
                    Text(storageUtil.getName(),
                        style: Theme.of(context).textTheme.headlineMedium)
                  ],
                ),
                Expanded(child: Container()),
                IconButton(
                    onPressed: () => Get.toNamed('/add-user'),
                    icon: Icon(Iconsax.user_add))
              ],
            ),
          ),
        ],
      )),
    );
  }
}
