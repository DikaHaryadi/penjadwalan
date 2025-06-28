// import 'package:get/get.dart';

// class MasterBarangController extends GetxController{
//   RxBool isLoading = false.obs;
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   RxList<UserModel> userList = <UserModel>[].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchUser();
//   }

//   Future<void> fetchUser() async {
//     isLoading.value = true;
//     try {
//       final QuerySnapshot<Map<String, dynamic>> snapshot = await _db
//           .collection('Users')
//           .where('Roles', isEqualTo: '3')
//           .orderBy('createdAt', descending: false) // Urutkan dari lama ke baru
//           .get();

//       final users =
//           snapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList();
//       userList.value = users;
//     } catch (e) {
//       SnackbarLoader.errorSnackBar(
//         title: 'Error',
//         message: 'Gagal mengambil data: $e',
//       );

//       print('ini err: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
