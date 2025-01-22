import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/models/berita_model.dart';
import 'package:example/repository/berita_repo.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../utils/loader/snackbar.dart';

class BeritaController extends GetxController {
  final isLoading = Rx<bool>(false);
  final beritaRepo = Get.put(BeritaRepository());
  final RxList<BeritaModel> berita = <BeritaModel>[].obs;

  final formKey = GlobalKey<FormState>();
  Rx<File?> image = Rx<File?>(null);
  Rx<String?> imageUrl = Rx<String?>(null);

  TextEditingController titleC = TextEditingController();
  TextEditingController deskripsiC = TextEditingController();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  @override
  void onInit() {
    fetchBerita();
    super.onInit();
  }

  Future<void> fetchBerita() async {
    try {
      isLoading.value = true;
      final beritas = await beritaRepo.fetchBeritaContent();
      berita.assignAll(beritas);
    } catch (e) {
      berita.assignAll([]);
    } finally {
      isLoading.value = false;
    }
  }

  Future<XFile?> pickImage(ImageSource source) async {
    try {
      final imagePicker = await ImagePicker().pickImage(source: source);
      if (imagePicker == null) return null;

      image.value = File(imagePicker.path);
      imageUrl.value = null;
    } catch (e) {
      SnackbarLoader.errorSnackBar(
        title: 'Oops🤷',
        message: 'Gagal mengambil gambar dari gallery',
      );
    }
    return null;
  }

  Future<String> uploadImage(String path, XFile image) async {
    try {
      final ref = FirebaseStorage.instance.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;
    } catch (err) {
      throw Get.snackbar(
        'Oh Snap!',
        err.toString(),
        isDismissible: true,
        shouldIconPulse: true,
        colorText: Colors.white,
        backgroundColor: Colors.red.shade600,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(20),
        icon: const Icon(
          Iconsax.warning_2,
          color: Colors.white,
        ),
      );
    }
  }

  Future<String> saveBeritaNew(BeritaModel userModel) async {
    DocumentReference docRef =
        await _db.collection('Berita').add(userModel.toJson());
    return docRef.id;
  }

  Future<void> createNewBerita() async {
    if (Get.overlayContext == null) return;

    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      if (!formKey.currentState!.validate()) {
        return;
      }

      if (image.value == null) {
        Get.snackbar('Oops', 'Harap memasukan gambar terlebih dahulu');
        return;
      }
      final xFile = XFile(image.value!.path);

      final imgUrl = await uploadImage('Berita/', xFile);

      final newBerita = BeritaModel(
          deksripsi: deskripsiC.text.trim(),
          image: imgUrl,
          tgl: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          title: titleC.text.trim());

      await saveBeritaNew(newBerita);
      resetEditState();
      await fetchBerita();

      Navigator.of(Get.overlayContext!).pop();

      SnackbarLoader.successSnackBar(
        title: 'Selamat',
        message: 'Berita baru berhasil dibuat',
      );
    } catch (e) {
      SnackbarLoader.errorSnackBar(
        title: 'Error',
        message: 'Terjadi kesalahan: $e',
      );
      print('Ini error: ${e.toString()}');
    } finally {
      Navigator.of(Get.overlayContext!).pop();
    }
  }

  Future<void> updateBerita(String id, String oldImage) async {
    if (!formKey.currentState!.validate()) {
      Get.snackbar('Oops', 'Harap isi semua bidang dengan benar');
      return;
    }

    try {
      isLoading.value = true;

      String? imgUrl = oldImage; // Gunakan URL lama sebagai default

      if (image.value != null) {
        // **Upload Gambar Baru di Referensi yang Sama**
        final referenceImageToUpdate =
            FirebaseStorage.instance.refFromURL(oldImage);

        // Ganti gambar di referensi yang sama
        final uploadTask =
            await referenceImageToUpdate.putFile(File(image.value!.path));
        imgUrl = await uploadTask.ref.getDownloadURL();
        print('Gambar berhasil diupdate: $imgUrl');
      }

      // **Update Data di Firestore**
      final updatedBerita = {
        'Title': titleC.text.trim(),
        'Deskripsi': deskripsiC.text.trim(),
        'Image': imgUrl, // URL tetap sama atau diperbarui jika ada gambar baru
        'Tgl': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      };

      await _db.collection('Berita').doc(id).update(updatedBerita);
      await fetchBerita();

      SnackbarLoader.successSnackBar(
        title: 'Berhasil',
        message: 'Berita berhasil diperbarui',
      );
    } catch (e) {
      SnackbarLoader.errorSnackBar(
        title: 'Error',
        message: 'Gagal memperbarui berita: $e',
      );
      print('Error updateBerita: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteBerita(String id, String imageUrl) async {
    try {
      isLoading.value = true;

      // Hapus data dari Firestore
      await _db.collection('Berita').doc(id).delete();

      // Hapus gambar dari Firebase Storage
      if (imageUrl.isNotEmpty) {
        final storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
        await storageRef.delete();
      }

      // Hapus data dari daftar berita lokal
      berita.removeWhere((item) => item.id == id);

      SnackbarLoader.successSnackBar(
        title: 'Berhasil',
        message: 'Berita dan gambar berhasil dihapus.',
      );
    } catch (e) {
      SnackbarLoader.errorSnackBar(
        title: 'Gagal',
        message: 'Gagal menghapus berita: $e',
      );
      print('Error menghapus berita: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void resetEditState() {
    titleC.clear();
    deskripsiC.clear();
    image.value = null;
  }

  void setEditState(BeritaModel beritaModel) {
    titleC.text = beritaModel.title;
    deskripsiC.text = beritaModel.deksripsi;
    image.value = null; // Reset gambar jika ada
    imageUrl.value = beritaModel.image; // Simpan URL gambar lama
  }
}
