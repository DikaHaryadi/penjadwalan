import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/constant/custom_size.dart';
import 'package:example/constant/storage_util.dart';
import 'package:example/controllers/berita_controller.dart';
import 'package:example/models/berita_model.dart';
import 'package:example/theme/app_colors.dart';
import 'package:example/utils/expandable_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'admin/create_berita.dart';
import 'admin/edit_berita.dart';

class BeritaScreen extends StatelessWidget {
  const BeritaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BeritaController());
    final storageUtil = StorageUtil();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Berita Terbaru',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          if (storageUtil.getRoles() == '2')
            IconButton(
              onPressed: () {
                Get.to(() => CreateBerita(), preventDuplicates: false);
              },
              icon: Icon(Iconsax.add),
            )
        ],
      ),
      body: Obx(
        () => ListView.separated(
          padding: const EdgeInsets.all(CustomSize.sm),
          itemBuilder: (context, index) {
            final berita = controller.berita[index];
            return GestureDetector(
              onTap: () => Get.to(() => BeritaDetailScreen(model: berita)),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(CustomSize.sm),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  border:
                      Border.all(width: 1, color: AppColors.borderSecondary),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (storageUtil.getRoles() == '2')
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                controller.setEditState(berita);
                                Get.to(
                                  () => EditBeritaPage(
                                    id: berita.id!,
                                    image: berita.image,
                                  ),
                                  preventDuplicates: false,
                                );
                              },
                              child: Text('Edit'),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.defaultDialog(
                                  title: "Konfirmasi",
                                  middleText:
                                      "Apakah Anda yakin ingin menghapus berita ini?",
                                  textCancel: "Batal",
                                  textConfirm: "Hapus",
                                  confirmTextColor: Colors.white,
                                  barrierDismissible:
                                      false, // Perbaikan di sini
                                  onConfirm: () {
                                    controller.deleteBerita(
                                        berita.id!, berita.image);
                                    Get.back(); // Tutup dialog setelah konfirmasi
                                  },
                                );
                              },
                              child: Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        width: double.infinity,
                        height: 180,
                        imageUrl: berita.image,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (_, __, ___) =>
                            const CircularProgressIndicator(),
                        errorWidget: (_, __, ___) => const Icon(Icons.error),
                      ),
                    ),
                    const SizedBox(height: CustomSize.spaceBtwItems),
                    Text(
                      berita.title,
                      maxLines: 2,
                      textAlign: TextAlign.justify,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                    ),
                    const SizedBox(height: CustomSize.spaceBtwItems),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        berita.tgl,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                      ),
                    ),
                    const SizedBox(height: CustomSize.spaceBtwItems),
                    Text(
                      berita
                          .deksripsi, // Gunakan nama properti yang benar dari BeritaModel
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.black54,
                          ),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(
            height: CustomSize.spaceBtwItems,
          ),
          itemCount: controller.berita.length,
          shrinkWrap: true,
        ),
      ),
    );
  }
}

class BeritaDetailScreen extends StatelessWidget {
  const BeritaDetailScreen({super.key, required this.model});

  final BeritaModel model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: CustomSize.appBarHeight,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: Text(
          'Detail Berita',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: CustomSize.lg),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              width: double.infinity,
              imageUrl: model.image,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (_, __, ___) =>
                  const CircularProgressIndicator(),
              errorWidget: (_, __, ___) => const Icon(Icons.error),
            ),
          ),
          const SizedBox(height: CustomSize.spaceBtwItems),
          Text(
            model.title,
            textAlign: TextAlign.justify,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87,
                ),
          ),
          const SizedBox(height: CustomSize.spaceBtwItems),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              model.tgl,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
            ),
          ),
          const SizedBox(height: CustomSize.spaceBtwItems),
          Text(model.deksripsi)
          // ExpandableTextWidget(
          //   text: model.deksripsi,
          //   maxLines: 15,
          //   textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          //         color: Colors.black87,
          //       ),
          // ),
        ],
      ),
    );
  }
}
