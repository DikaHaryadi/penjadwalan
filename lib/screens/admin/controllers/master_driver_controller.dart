import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/master_driver_model.dart';
import '../../../utils/loader/snackbar.dart';

class MasterDriverController extends GetxController {
  RxBool isLoading = false.obs;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();
  final nameC = TextEditingController();
  final platNomorC = TextEditingController();
  final telpC = TextEditingController();

  RxList<MasterDriverModel> userList = <MasterDriverModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUser();
  }

  Future<void> fetchUser() async {
    isLoading.value = true;
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await _db.collection('MasterDriver').get();

      final users = snapshot.docs
          .map((doc) => MasterDriverModel.fromSnapshot(doc))
          .toList();
      userList.value = users;
    } catch (e) {
      SnackbarLoader.errorSnackBar(
        title: 'Error',
        message: 'Gagal mengambil data: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> saveUserNew(MasterDriverModel masterDriver) async {
    DocumentReference docRef =
        await _db.collection('MasterDriver').add(masterDriver.toJson());
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

      final newUser = MasterDriverModel(
        namaDriver: nameC.text.trim(),
        platNomor: platNomorC.text.trim(),
        telp: telpC.text.trim(),
        statusPengangkutan: '0',
      );

      await saveUserNew(newUser);

      await fetchUser();

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
