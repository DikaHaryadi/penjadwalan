import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import '../../../utils/loader/snackbar.dart';

class AddUserController extends GetxController {
  final emailC = TextEditingController();
  final nameC = TextEditingController();
  final passwordC = TextEditingController();
  final telpC = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final tipe = 'driver'.obs;
  Rx<File?> image = Rx<File?>(null);
  RxBool obscureText = true.obs;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String get tipeValue {
    switch (tipe.value) {
      case 'manajer':
        return '0';
      case 'driver':
        return '1';
      case 'admin':
        return '2';
      default:
        return '-1';
    }
  }

  Future<XFile?> pickImage(ImageSource source) async {
    try {
      final imagePicker = await ImagePicker().pickImage(source: source);
      if (imagePicker == null) return null;

      image.value = File(imagePicker.path);
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

  Future<String> saveUserNew(UserModel userModel) async {
    DocumentReference docRef =
        await _db.collection('Users').add(userModel.toJson());
    return docRef.id;
  }

  Future<void> createNewUser() async {
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
        return;
      }
      final xFile = XFile(image.value!.path);

      final imgUrl = await uploadImage('Users/', xFile);

      final newUser = UserModel(
        name: nameC.text.trim(),
        telp: telpC.text.trim(),
        email: emailC.text.trim(),
        image: imgUrl,
        roles: tipeValue,
      );

      await saveUserNew(newUser);

      Navigator.of(Get.overlayContext!).pop();

      SnackbarLoader.successSnackBar(
        title: 'Selamat',
        message: 'User baru berhasil dibuat',
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
}
