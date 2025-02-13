import 'package:cloud_firestore/cloud_firestore.dart';

class KategoriBarangModel {
  String jenisLimbah;
  String hargaLimbah;
  String satuanLimbah;

  KategoriBarangModel({
    required this.jenisLimbah,
    required this.hargaLimbah,
    required this.satuanLimbah,
  });

  static KategoriBarangModel empty() => KategoriBarangModel(
        jenisLimbah: '',
        hargaLimbah: '',
        satuanLimbah: '',
      );

  Map<String, dynamic> toJson() {
    return {
      'Jenis_Limbah': jenisLimbah,
      'Harga_Limbah': hargaLimbah,
      'Satuan_Limbah': satuanLimbah,
    };
  }

  factory KategoriBarangModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data();
      return KategoriBarangModel(
          jenisLimbah: data?['Jenis_Limbah'] ?? '',
          hargaLimbah: data?['Harga_Limbah'] ?? '',
          satuanLimbah: data?['Satuan_Limbah'] ?? '');
    } else {
      return KategoriBarangModel.empty();
    }
  }
}
