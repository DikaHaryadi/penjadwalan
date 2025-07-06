import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/event_calendar.dart';
import '../../../utils/loader/snackbar.dart';

class BuatjadwalController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  RxList<Event> userList = <Event>[].obs;
  RxBool isLoading = false.obs;

  // dropdown nama perusahaan
  var dropdownItems = <String>[].obs;
  var selectedValue = RxnString();

  final formKey = GlobalKey<FormState>();
  final tgl = DateTime.now().obs;
  final alamatC = TextEditingController();
  final driverC = TextEditingController();
  final hargaC = TextEditingController();
  final jenisLimbahC = TextEditingController();
  final jumlahLimbahC = TextEditingController();
  final namaUsahaC = TextEditingController();
  final platNomorC = TextEditingController();
  final telpC = TextEditingController();
  final waktuC = TextEditingController();
  final penanggungJawabC = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchJadwal();
    fetchFilteredJadwalMasuk();
  }

  Future<void> fetchJadwal() async {
    isLoading.value = true;

    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await _db.collection('BuatJadwal').get();

      // Mengonversi setiap dokumen ke dalam UserModel
      final users =
          snapshot.docs.map((doc) => Event.fromSnapshot(doc)).toList();
      userList.value = users;
    } catch (e) {
      SnackbarLoader.errorSnackBar(
        title: 'Error',
        message: 'Gagal mengambil data: $e',
      );
      print('ini err : ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchFilteredJadwalMasuk() async {
    try {
      // Ambil semua data dari JadwalMasuk
      QuerySnapshot jadwalMasukSnapshot =
          await _db.collection('JadwalMasuk').get();
      List<Map<String, dynamic>> jadwalMasukList = jadwalMasukSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      // Ambil semua data dari BuatJadwal
      QuerySnapshot buatJadwalSnapshot =
          await _db.collection('BuatJadwal').get();
      List<Map<String, dynamic>> buatJadwalList = buatJadwalSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      // Filter data: hanya yang tidak ada di BuatJadwal
      List<String> filteredNamaUsaha = jadwalMasukList
          .where((jadwalMasuk) {
            return !buatJadwalList.any((buatJadwal) =>
                buatJadwal['Nama_Usaha'] == jadwalMasuk['Nama_Usaha'] &&
                buatJadwal['Jenis_Limbah'] == jadwalMasuk['Jenis_Limbah'] &&
                buatJadwal['Jumlah_Limbah'] == jadwalMasuk['Jumlah_Limbah']);
          })
          .map((e) => e['Nama_Usaha'].toString())
          .where((nama) => nama.isNotEmpty) // Hindari nilai kosong
          .toSet() // Hilangkan duplikasi
          .toList();

      // Update dropdownItems
      dropdownItems.assignAll(filteredNamaUsaha);

      // Reset nilai dropdown agar tidak otomatis memilih yang pertama
      selectedValue.value = null;
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<String> saveBeritaNew(Event userModel) async {
    DocumentReference docRef =
        await _db.collection('BuatJadwal').add(userModel.toJson());
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

      // Cek apakah Nama_Driver ada di collection MasterDriver
      final driverName = driverC.text.trim();
      final driverDoc = await FirebaseFirestore.instance
          .collection('MasterDriver')
          .where('Nama_Driver', isEqualTo: driverName)
          .limit(1)
          .get();

      if (driverDoc.docs.isNotEmpty) {
        // Nama_Driver ditemukan, update Status_Pengangkutan menjadi "1"
        final driverId = driverDoc.docs.first.id;
        await FirebaseFirestore.instance
            .collection('MasterDriver')
            .doc(driverId)
            .update({
          'Status_Pengangkutan': '1', // Update field Status_Pengangkutan
        });
      }

      // Buat event baru jika driver ditemukan atau tidak ditemukan
      final newBerita = Event(
        alamat: alamatC.text.trim(),
        driver: driverC.text.trim(),
        harga: hargaC.text.trim(),
        jenisLimbah: jenisLimbahC.text.trim(),
        jumlahLimbah: jumlahLimbahC.text.trim(),
        namaUsaha: namaUsahaC.text.trim(),
        platNomer: platNomorC.text.trim(),
        status: '0',
        date: tgl.value,
        telp: telpC.text.trim(),
        waktu: waktuC.text.trim(),
        penanggungJawab: penanggungJawabC.text.trim(),
        createdAt: Timestamp.now(),
      );

      // Simpan berita baru ke Firestore
      await saveBeritaNew(newBerita);
      resetEditState();
      await fetchJadwal();
      await fetchFilteredJadwalMasuk();

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
    String driver,
    String harga,
    String jenisLimbah,
    String jumlahLimbah,
    String platNomor,
    String namaUsaha,
    DateTime tanggal,
    String waktu,
    String telp,
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
        'Alamat': alamat,
        'Driver': driver,
        'Harga': harga,
        'Jenis_Limbah': jenisLimbah,
        'Jumlah_Limbah': jumlahLimbah,
        'Nama_Usaha': namaUsaha,
        'Plat_Nomer': platNomor,
        'Tanggal': tanggal,
        'Telp': telp,
        'Waktu': waktu,
      };

      await _db.collection('BuatJadwal').doc(id).update(newBerita);
      await fetchJadwal();
      await fetchFilteredJadwalMasuk();

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

      await _db.collection('BuatJadwal').doc(id).delete();
      userList.removeWhere((item) => item.id == id);
      await fetchFilteredJadwalMasuk();
      Navigator.of(Get.overlayContext!).pop();

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
      Navigator.of(Get.overlayContext!).pop();
    }
  }

  void resetEditState() {
    selectedValue.value = null;
    alamatC.clear();
    driverC.clear();
    hargaC.clear();
    jenisLimbahC.clear();
    jumlahLimbahC.clear();
    namaUsahaC.clear();
    platNomorC.clear();
    telpC.clear();
    waktuC.clear();
  }
}
