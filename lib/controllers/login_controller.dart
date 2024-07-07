import 'package:example/controllers/internet_checker_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';
import '../repository/login_repo.dart';
import '../utils/loader/animation_loader.dart';
import '../utils/loader/snackbar.dart';
import '../constant/storage_util.dart';

class LoginController extends GetxController {
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  UserModel? currentUser;
  GlobalKey<FormState> loginFromKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final storageUtil = StorageUtil();

  @override
  void onInit() {
    emailController.text = storageUtil.prefs.read('REMEMBER_ME_EMAIL') ?? "";
    passwordController.text =
        storageUtil.prefs.read('REMEMBER_ME_PASSWORD') ?? "";
    super.onInit();
  }

  Future<void> emailAndPasswordSignIn() async {
    if (!loginFromKey.currentState!.validate()) {
      return;
    }

    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false,
      builder: (context) => const PopScope(
        canPop: false,
        child: AnimationLoader(
          text: 'Mohon ditunggu...',
          animation: 'assets/animations/loading.json',
          showAction: false,
        ),
      ),
    );

    final internetController = Get.put(InternetController());
    await Future.delayed(const Duration(milliseconds: 100));

    if (!internetController.isConnectedToInternet.value) {
      Navigator.of(Get.overlayContext!).pop();
      SnackbarLoader.errorSnackBar(
        title: 'No Internet',
        message: 'Please check your internet connection and try again.',
      );
      return;
    }

    final userRepo = Get.put(LoginRepository());
    final user = await userRepo.fetchUserDetails(
      emailController.text,
      passwordController.text,
    );

    Navigator.of(Get.overlayContext!).pop();

    if (user != null) {
      currentUser = user;
      if (rememberMe.value) {
        storageUtil.prefs
            .write('REMEMBER_ME_EMAIL', emailController.text.trim());
        storageUtil.prefs.write(
          'REMEMBER_ME_PASSWORD',
          passwordController.text.trim(),
        );
      }

      // Simpan detail pengguna ke StorageUtil setelah login
      storageUtil.saveUserDetails(
        name: user.name,
        tlp: user.telp,
        email: user.email,
        image: user.image,
        roles: user.roles,
      );

      if (user.roles == '0') {
        Get.offNamed('/rootpage-manajer');
      } else if (user.roles == '1') {
        Get.offNamed('/rootpage-driver');
      } else {
        SnackbarLoader.errorSnackBar(
            title: 'Kesalahan',
            message: 'pastikan sudah menginput field roles pada firebase🤦');
      }
    } else {
      SnackbarLoader.errorSnackBar(
          title: 'Gagal😒', message: 'Email atau password tidak ditemukan🤦');
    }
  }

  void logout() {
    storageUtil.prefs.remove('Name');
    storageUtil.prefs.remove('Telp');
    storageUtil.prefs.remove('Email');
    storageUtil.prefs.remove('Image');
    storageUtil.prefs.remove('Roles');
    Get.offAllNamed('/');
    SnackbarLoader.successSnackBar(
      title: 'Logged Out',
      message: 'You have been logged out successfully.',
    );
  }
}
