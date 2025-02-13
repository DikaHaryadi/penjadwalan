import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/kategori_barang_model.dart';
import '../../../utils/loader/snackbar.dart';

class KategoriBarangController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  RxList<KategoriBarangModel> userList = <KategoriBarangModel>[].obs;
  RxBool isLoading = false.obs;
  final formKey = GlobalKey<FormState>();

  TextEditingController jenisLimbah = TextEditingController();
  TextEditingController hargaLimbah = TextEditingController();
  TextEditingController satuanLimbah = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      // Mendapatkan semua dokumen dari koleksi 'Users'
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await _db.collection('KategoriBarang').get();

      // Mengonversi setiap dokumen ke dalam UserModel
      final users = snapshot.docs
          .map((doc) => KategoriBarangModel.fromSnapshot(doc))
          .toList();

      // Menyimpan data ke dalam RxList
      userList.value = users;

      print('ini data kategori barang: ${userList.toList()}');
    } catch (e) {
      SnackbarLoader.errorSnackBar(
        title: 'Error',
        message: 'Gagal mengambil data: $e',
      );
    }
  }

  Future<String> saveMasterBarang(KategoriBarangModel userModel) async {
    DocumentReference docRef =
        await _db.collection('KategoriBarang').add(userModel.toJson());
    return docRef.id;
  }

  Future<void> createMasterBarang() async {
    isLoading.value = true;
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }

      final newKategori = KategoriBarangModel(
          jenisLimbah: jenisLimbah.text.trim(),
          hargaLimbah: hargaLimbah.text.trim(),
          satuanLimbah: satuanLimbah.text.trim());

      await saveMasterBarang(newKategori);

      await fetchUsers();

      Navigator.of(Get.overlayContext!).pop();

      SnackbarLoader.successSnackBar(
        title: 'Selamat',
        message: 'Kategori barang berhasil dibuat',
      );
    } catch (e) {
      SnackbarLoader.errorSnackBar(
        title: 'Error',
        message: 'Terjadi kesalahan: $e',
      );
      print('ERROR CREATE MASTER BARANG BUG : $e');
    } finally {
      isLoading.value = false;
    }
  }
}
