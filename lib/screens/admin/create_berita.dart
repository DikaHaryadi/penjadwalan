import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

import '../../controllers/berita_controller.dart';
import '../../theme/app_colors.dart';

class CreateBerita extends StatelessWidget {
  const CreateBerita({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BeritaController>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Buat Berita Baru'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
                onPressed: () {
                  controller.createNewBerita();
                },
                child: Text('POSTING')),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;

            if (controller.titleC.text.isEmpty &&
                controller.image.value == null &&
                controller.deskripsiC.text.isEmpty) {
              Get.back();
            } else {
              final isConfirmed = await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Peringatan'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            'Perubahan belum disimpan. Apakah Anda ingin melanjutkan?')
                      ],
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(Get.overlayContext!).pop(false);
                          },
                          child: Text('Batalkan')),
                      TextButton(
                          onPressed: () {
                            controller.resetEditState();
                            Navigator.of(Get.overlayContext!).pop(true);
                          },
                          child: Text('Kembali')),
                    ],
                  );
                },
              );

              if (isConfirmed == true) {
                Get.back();
              }
            }
          },
          child: Container(
            width: Get.width,
            height: Get.height,
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.titleC,
                    decoration: InputDecoration(label: Text('Judul Berita')),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*';
                      }
                      return null;
                    },
                  ),
                  Divider(),
                  TextFormField(
                    controller: controller.deskripsiC,
                    keyboardType: TextInputType.text,
                    maxLines: 10,
                    minLines: 1,
                    style: Theme.of(context).textTheme.bodyMedium,
                    // onChanged: (value) {
                    //   controller.textVisible.value = value.isEmpty;
                    // },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      hintText: 'Deskripsi Berita',
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*';
                      }
                      return null;
                    },
                  ),
                  Obx(() => controller.image.value != null
                      ? Image.file(controller.image.value!)
                      : const SizedBox.shrink())
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            border: Border.all(
                strokeAlign: BorderSide.strokeAlignOutside,
                style: BorderStyle.solid,
                color: AppColors.softGrey)),
        child: BottomNavigationBar(
            backgroundColor: Colors.white,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: GestureDetector(
                  onTap: () => controller.pickImage(ImageSource.gallery),
                  child: const Icon(
                    Iconsax.image,
                    size: 25,
                    color: Color(0xff45bd63),
                  ),
                ),
                label: 'Album',
              ),
              BottomNavigationBarItem(
                icon: GestureDetector(
                  onTap: () => controller.pickImage(ImageSource.camera),
                  child: const Icon(
                    Iconsax.camera,
                    size: 25,
                    color: Color(0xff4699ff),
                  ),
                ),
                label: 'Kamera',
              ),
            ]),
      ),
    );
  }
}
