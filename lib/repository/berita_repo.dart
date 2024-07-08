import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/models/berita_model.dart';
import 'package:example/utils/loader/snackbar.dart';
import 'package:get/get.dart';

class BeritaRepository extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<BeritaModel>> fetchBeritaContent() async {
    try {
      final documentSnapshot = await _db.collection('Berita').get();
      if (documentSnapshot.docs.isNotEmpty) {
        return documentSnapshot.docs
            .map((doc) => BeritaModel.fromSnapshot(doc))
            .toList();
      } else {
        return [];
      }
    } catch (err) {
      throw SnackbarLoader.errorSnackBar(
          title: 'Gagal', message: err.toString());
    }
  }
}
