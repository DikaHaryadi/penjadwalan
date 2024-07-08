import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/constant/custom_size.dart';
import 'package:example/constant/storage_util.dart';
import 'package:example/utils/curved_edges.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storageUtil = StorageUtil();
    return SafeArea(
      child: Column(
        children: [
          ClipPath(
            clipper: TCustomCurvedEdges(),
            child: Container(
              color: Colors.blueAccent,
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: CustomSize.lg),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: CustomSize.lg, vertical: CustomSize.md),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: storageUtil.logout,
                        icon: const Icon(Iconsax.logout),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(70),
                      child: CachedNetworkImage(
                        width: CustomSize.profileImageSize,
                        height: CustomSize.profileImageSize,
                        imageUrl: storageUtil.getImage(),
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (_, __, ___) =>
                            const CircularProgressIndicator(),
                        errorWidget: (_, __, ___) => const Icon(Icons.error),
                      ),
                    ),
                    const SizedBox(height: CustomSize.spaceBtwItems),
                    Text(storageUtil.getName(),
                        style: Theme.of(context).textTheme.headlineMedium)
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: CustomSize.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Iconsax.direct),
                    SizedBox(width: CustomSize.sm),
                    Text('E-mail'),
                  ],
                ),
                const SizedBox(height: CustomSize.sm),
                Text(storageUtil.getEmail()),
                const SizedBox(height: CustomSize.spaceBtwSections),
                const Row(
                  children: [
                    Icon(Iconsax.direct),
                    SizedBox(width: CustomSize.sm),
                    Text('Nomer Telepon'),
                  ],
                ),
                const SizedBox(height: CustomSize.sm),
                Text(storageUtil.getTelp()),
                const SizedBox(height: CustomSize.spaceBtwSections),
                const Row(
                  children: [
                    Icon(Iconsax.direct),
                    SizedBox(width: CustomSize.sm),
                    Text('Roles'),
                  ],
                ),
                const SizedBox(height: CustomSize.sm),
                Text(
                  storageUtil.getRoles() == '0'
                      ? 'Manajer'
                      : storageUtil.getRoles() == '1'
                          ? 'Driver'
                          : 'Anda belum memasukkan roles di Firebase',
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
