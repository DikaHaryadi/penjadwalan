import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/constant/custom_size.dart';
import 'package:example/controllers/berita_controller.dart';
import 'package:example/theme/app_colors.dart';
import 'package:example/utils/expandable_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BeritaScreen extends StatelessWidget {
  const BeritaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BeritaController());

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Berita Terbaru',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: Obx(
          () => ListView.separated(
              itemBuilder: (context, index) {
                final berita = controller.berita[index];
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: CustomSize.sm),
                  padding: const EdgeInsets.all(CustomSize.sm),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 1, color: AppColors.borderSecondary)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        width: double.infinity,
                        imageUrl: berita.image,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (_, __, ___) =>
                            const CircularProgressIndicator(),
                        errorWidget: (_, __, ___) => const Icon(Icons.error),
                      ),
                      Text(
                        berita.title,
                        textAlign: TextAlign.justify,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          berita.tgl,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      ExpandableTextWidget(
                        text: berita.deksripsi,
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                    height: CustomSize.spaceBtwItems,
                  ),
              itemCount: controller.berita.length),
        ));
  }
}
