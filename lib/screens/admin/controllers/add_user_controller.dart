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
  final alamatC = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final tipe = 'driver'.obs;
  Rx<File?> image = Rx<File?>(null);
  RxBool obscureText = true.obs;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  RxList<UserModel> userList = <UserModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  String get tipeValue {
    switch (tipe.value) {
      case 'manajer':
        return '0';
      case 'driver':
        return '1';
      case 'admin':
        return '2';
      case 'supplier':
        return '3';
      default:
        return '-1';
    }
  }

  String getTipeRoles(String roles) {
    switch (roles) {
      case '0':
        return 'manajer';
      case '1':
        return 'driver';
      case '2':
        return 'admin';
      case '3':
        return 'supplier';
      default:
        return 'Tidak diketahui';
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
        SnackbarLoader.warningSnackBar(
          title: 'Oops😪',
          message: 'Harap masukan gambar terlebih dahulu',
        );
        return;
      }
      final xFile = XFile(image.value!.path);

      final imgUrl = await uploadImage('Users/', xFile);

      final newUser = UserModel(
          name: nameC.text.trim(),
          telp: telpC.text.trim(),
          alamat: alamatC.text.trim(),
          email: emailC.text.trim(),
          password: passwordC.text.trim(),
          image: imgUrl,
          roles: tipeValue,
          createdAt: Timestamp.now());

      await saveUserNew(newUser);

      await fetchUsers();

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

  Future<void> fetchUsers() async {
    try {
      // Mendapatkan semua dokumen dari koleksi 'Users'
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await _db.collection('Users').get();

      // Mengonversi setiap dokumen ke dalam UserModel & Filter user dengan roles != '2'
      final users = snapshot.docs
          .map((doc) => UserModel.fromSnapshot(doc))
          .where((user) => user.roles != '2') // Filter data di sini
          .toList();

      // Menyimpan data ke dalam RxList
      userList.value = users;
    } catch (e) {
      SnackbarLoader.errorSnackBar(
        title: 'Error',
        message: 'Gagal mengambil data: $e',
      );
    }
  }
}
