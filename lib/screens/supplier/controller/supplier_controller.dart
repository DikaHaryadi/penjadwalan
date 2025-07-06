import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../constant/storage_util.dart';
import '../../../models/jadwal_masuk.dart';
import '../../../models/kategori_barang_model.dart';
import '../../../utils/loader/snackbar.dart';

class SupplierController extends GetxController {
  final localStorage = StorageUtil();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();
  var isJumlahLimbahReadOnly = true.obs;
  RxList<JadwalMasuk> userList = <JadwalMasuk>[].obs;
  RxList<KategoriBarangModel> kategoriBarang = <KategoriBarangModel>[].obs;

  RxList<JadwalMasuk> memintaPersetujuanList = <JadwalMasuk>[].obs;
  RxList<JadwalMasuk> pendingList = <JadwalMasuk>[].obs;
  RxList<JadwalMasuk> finishList = <JadwalMasuk>[].obs;

  final namaPerusahaanC = TextEditingController();
  final nomorTelponC = TextEditingController();
  final jenisLimbahC = TextEditingController();
  final jumlahLimbah = TextEditingController();
  final hargaC = TextEditingController();
  final alamatC = TextEditingController();
  final penanggungJawabC = TextEditingController();

  var selectedJenisLimbah = ''.obs;
  var hargaPerSatuan = 0.0.obs;
  var jumlahLimbahPerSatuan = 0.obs;
  var totalHarga = 0.0.obs;
  var satuanLimbah = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPengangkutan();
    fetchKategoriBarang();

    // Tambahkan listener agar hargaC diperbarui secara otomatis
    jumlahLimbah.addListener(() {
      updateJumlahLimbah(jumlahLimbah.text);
    });
    namaPerusahaanC.text = localStorage.getName();
    nomorTelponC.text = localStorage.getTelp();
    alamatC.text = localStorage.getAlamat();
  }

  void updateHarga(String jenisLimbah) {
    try {
      final selectedLimbah = kategoriBarang.firstWhere(
        (element) =>
            element.jenisLimbah.toLowerCase().trim() ==
            jenisLimbah.toLowerCase().trim(),
      );

      hargaPerSatuan.value =
          double.tryParse(selectedLimbah.hargaLimbah.toString()) ?? 0.0;
      satuanLimbah.value = selectedLimbah.satuanLimbah;
      selectedJenisLimbah.value = jenisLimbah;

      isJumlahLimbahReadOnly.value = false;

      updateTotalHarga();
    } catch (e) {
      hargaPerSatuan.value = 0.0;
      satuanLimbah.value = '';
      hargaC.text = '';
      isJumlahLimbahReadOnly.value = true;
    }
  }

  Future<List<JadwalMasuk>> getJadwalByStatus(String status) async {
    try {
      await Future.delayed(
          const Duration(seconds: 1)); // Simulate network delay
      return userList
          .where((event) => event.status == status.toString())
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch events: $e');
    }
  }

  void updateJumlahLimbah(String jumlah) {
    jumlahLimbahPerSatuan.value = int.tryParse(jumlah) ?? 0;
    updateTotalHarga();
  }

  void updateTotalHarga() {
    totalHarga.value = jumlahLimbahPerSatuan.value * hargaPerSatuan.value;

    final formatter =
        NumberFormat.decimalPattern('id'); // Format 1.000, 10.000 dst
    hargaC.text = formatter.format(totalHarga.value.toInt());
  }

  Future<void> fetchKategoriBarang() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await _db.collection('KategoriBarang').get();

      kategoriBarang.value = snapshot.docs
          .map((doc) => KategoriBarangModel.fromSnapshot(doc))
          .toList();

      print(
          "Kategori Barang: ${kategoriBarang.map((e) => e.toJson()).toList()}");
    } catch (e) {
      print("Gagal mengambil data kategori barang: $e");
    }
  }

  Future<void> fetchPengangkutan() async {
    try {
      String loggedInUser = localStorage.getName();
      String typeUser = localStorage.getRoles();
      QuerySnapshot<Map<String, dynamic>> snapshot;

      if (typeUser == '2') {
        snapshot = await _db.collection('JadwalMasuk').get();
      } else {
        snapshot = await _db
            .collection('JadwalMasuk')
            .where('Nama_Usaha', isEqualTo: loggedInUser.trim())
            .get();
      }

      final users =
          snapshot.docs.map((doc) => JadwalMasuk.fromSnapshot(doc)).toList();
      userList.value = users;

      // Bagi berdasarkan status
      memintaPersetujuanList.value =
          users.where((e) => e.status == '0').toList();
      pendingList.value = users.where((e) => e.status == '1').toList();
      finishList.value = users.where((e) => e.status == '2').toList();
    } catch (e) {
      SnackbarLoader.errorSnackBar(
          title: 'Error', message: 'Gagal mengambil data: $e');
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
          noTelp: nomorTelponC.text.trim(),
          jenisLimbah: jenisLimbahC.text.trim(),
          jumlahLimbah: jumlahLimbah.text.trim(),
          alamat: alamatC.text.trim(),
          penanggungJawab: penanggungJawabC.text.trim(),
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
    jenisLimbahC.clear();
    jumlahLimbah.clear();
    penanggungJawabC.clear();
    selectedJenisLimbah.value = '';
  }
}
