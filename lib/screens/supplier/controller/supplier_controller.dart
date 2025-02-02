import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/jadwal_masuk.dart';
import '../../../utils/loader/snackbar.dart';

class SupplierController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();
  RxList<JadwalMasuk> userList = <JadwalMasuk>[].obs;

  final namaPerusahaanC = TextEditingController();
  final jenisLimbahC = TextEditingController();
  final jumlahLimbah = TextEditingController();
  final hargaC = TextEditingController();
  final alamatC = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchPengangkutan();
  }

  Future<void> fetchPengangkutan() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await _db.collection('JadwalMasuk').get();

      // Mengonversi setiap dokumen ke dalam UserModel
      final users =
          snapshot.docs.map((doc) => JadwalMasuk.fromSnapshot(doc)).toList();
      userList.value = users;
    } catch (e) {
      SnackbarLoader.errorSnackBar(
        title: 'Error',
        message: 'Gagal mengambil data: $e',
      );
      print('ini err : ${e.toString()}');
    }
  }

  Future<String> saveJadwalMasuk(JadwalMasuk jadwalMasuk) async {
    DocumentReference docRef =
        await _db.collection('JadwalMasuk').add(jadwalMasuk.toJson());
    return docRef.id;
  }

  Future<void> createJadwal() async {
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

      final newBerita = JadwalMasuk(
          namaPerusahaan: namaPerusahaanC.text.trim(),
          jenisLimbah: jenisLimbahC.text.trim(),
          jumlahLimbah: jumlahLimbah.text.trim(),
          alamat: alamatC.text.trim(),
          harga: hargaC.text.trim(),
          status: '0');

      await saveJadwalMasuk(newBerita);
      resetEditState();
      await fetchPengangkutan();

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

  Future<void> updateJadwal(
    String id,
    String alamat,
    String harga,
    String jenisLimbah,
    String jumlahLimbah,
    String namaUsaha,
  ) async {
    if (Get.overlayContext == null) return;

    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      if (!formKey.currentState!.validate()) {
        Get.snackbar('Oops', 'Harap isi semua bidang dengan benar');
        return;
      }

      final newBerita = {
        'Nama_Usaha': namaUsaha,
        'Jenis_Limbah': jenisLimbah,
        'Jumlah_Limbah': jumlahLimbah,
        'Harga': harga,
        'Alamat': alamat,
        'Status': '0'
      };

      await _db.collection('JadwalMasuk').doc(id).update(newBerita);
      await fetchPengangkutan();

      Navigator.of(Get.overlayContext!).pop();

      SnackbarLoader.successSnackBar(
        title: 'Berhasil',
        message: 'Jadwal berhasil diperbarui',
      );
    } catch (e) {
      SnackbarLoader.errorSnackBar(
        title: 'Error',
        message: 'Gagal memperbarui berita: $e',
      );
      print('Error updateBerita: ${e.toString()}');
    } finally {
      Navigator.of(Get.overlayContext!).pop();
    }
  }

  Future<void> deleteJadwal(String id) async {
    try {
      if (Get.overlayContext == null) return;

      showDialog(
        context: Get.overlayContext!,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      await _db.collection('JadwalMasuk').doc(id).delete();
      userList.removeWhere((item) => item.id == id);
      Navigator.of(Get.overlayContext!).pop();

      SnackbarLoader.successSnackBar(
        title: 'Berhasil',
        message: 'Jadwal masuk berhasil dihapus.',
      );
    } catch (e) {
      SnackbarLoader.errorSnackBar(
        title: 'Gagal',
        message: 'Gagal menghapus jadwal: $e',
      );
      print('Error menghapus jadwal: ${e.toString()}');
    } finally {
      Navigator.of(Get.overlayContext!).pop();
    }
  }

  Future<void> updateStatus(String id, String status) async {
    try {
      await _db.collection('JadwalMasuk').doc(id).update({'Status': status});

      // Update status di userList secara lokal agar UI langsung ter-update
      int index = userList.indexWhere((item) => item.id == id);
      if (index != -1) {
        userList[index].status = status;
        userList.refresh(); // Memperbarui UI
      }

      SnackbarLoader.successSnackBar(
        title: 'Berhasil',
        message:
            'Status berhasil diperbarui menjadi ${status == '1' ? 'Ditolak' : 'Diterima'}.',
      );
    } catch (e) {
      SnackbarLoader.errorSnackBar(
        title: 'Error',
        message: 'Gagal memperbarui status: $e',
      );
      print('Error updateStatus: ${e.toString()}');
    }
  }

  void resetEditState() {
    alamatC.clear();
    hargaC.clear();
    jenisLimbahC.clear();
    namaPerusahaanC.clear();
  }
}
