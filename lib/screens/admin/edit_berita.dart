import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controllers/berita_controller.dart';

class EditBeritaPage extends StatelessWidget {
  final String id; // ID berita yang akan diedit
  final String image;
  EditBeritaPage({required this.id, required this.image});

  final beritaController = Get.find<BeritaController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Berita'),
      ),
      body: Form(
        key: beritaController.formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              TextFormField(
                controller: beritaController.titleC,
                decoration: InputDecoration(labelText: 'Judul Berita'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: beritaController.deskripsiC,
                decoration: InputDecoration(labelText: 'Deskripsi Berita'),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Obx(() {
                final image = beritaController.image.value;
                final imageUrl = beritaController.imageUrl.value;

                return GestureDetector(
                  onTap: () async {
                    await beritaController.pickImage(ImageSource.gallery);
                  },
                  child: image != null
                      ? Image.file(
                          image,
                        )
                      : Stack(
                          children: [
                            Image.network(
                              imageUrl!,
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                );
              }),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  beritaController.updateBerita(id, image);
                  Get.back(); // Kembali ke halaman sebelumnya setelah update
                },
                child: Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
