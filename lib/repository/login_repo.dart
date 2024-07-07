import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/models/user_model.dart';
import 'package:example/utils/loader/snackbar.dart';
import 'package:get/get.dart';

class LoginRepository extends GetxController {
  static LoginRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // function to fetch user data
  Future<UserModel?> fetchUserDetails(String email, String password) async {
    try {
      final querySnapshot = await _db
          .collection('Users')
          .where('Email', isEqualTo: email)
          .where('Password', isEqualTo: password)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final documentSnapshot = querySnapshot.docs.first;
        return UserModel.fromSnapshot(documentSnapshot);
      }
      return null;
    } catch (e) {
      SnackbarLoader.errorSnackBar(
          title: 'Error', message: 'Terjadi kesalahan saat mencoba login.');
      print('error di login repository : $e');
      return null;
    }
  }
}
