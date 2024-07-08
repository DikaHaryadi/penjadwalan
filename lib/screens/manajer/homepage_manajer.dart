import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/constant/storage_util.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class HomepageManajer extends StatelessWidget {
  const HomepageManajer({super.key});

  @override
  Widget build(BuildContext context) {
    final storageUtil = StorageUtil();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 56.0,
          height: 56.0,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
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
        Text('Welcome ${storageUtil.getName()}'),
        Text('Ini roles manajer'),
        IconButton(onPressed: storageUtil.logout, icon: Icon(Iconsax.logout))
      ],
    );
  }
}
