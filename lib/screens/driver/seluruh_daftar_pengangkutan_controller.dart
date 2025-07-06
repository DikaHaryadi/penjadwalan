import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../constant/storage_util.dart';
import '../../models/event_calendar.dart';
import '../../utils/loader/snackbar.dart';

class SeluruhDaftarPengangkutanController extends GetxController {
  RxList<SeluruhDaftarPengangkutanModel> seluruhDaftarPengangkutanModels =
      <SeluruhDaftarPengangkutanModel>[].obs;
  final storageUtil = StorageUtil();
  RxBool isLoading = false.obs;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  void onInit() {
    fetchUser();
    super.onInit();
  }

  Future<void> fetchUser() async {
    isLoading.value = true;
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _db
          .collection('BuatJadwal')
          .where('Status', isEqualTo: '3')
          .get();

      final users = snapshot.docs
          .map((doc) => SeluruhDaftarPengangkutanModel.fromSnapshot(doc))
          .toList();

      seluruhDaftarPengangkutanModels.value =
          users.where((e) => e.driver == storageUtil.getName()).toList();
      print(
          'Data berhasil diambil: ${seluruhDaftarPengangkutanModels.length} items');
    } catch (e) {
      SnackbarLoader.errorSnackBar(
        title: 'Error',
        message: 'Gagal mengambil data: $e',
      );
      print('Error saat fetchUser: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
