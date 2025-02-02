import 'package:cloud_firestore/cloud_firestore.dart';

class JadwalMasuk {
  final String? id;
  String namaPerusahaan;
  String jenisLimbah;
  String jumlahLimbah;
  String harga;
  String alamat;
  String status;

  JadwalMasuk({
    this.id,
    required this.namaPerusahaan,
    required this.jenisLimbah,
    required this.jumlahLimbah,
    required this.harga,
    required this.alamat,
    required this.status,
  });

  factory JadwalMasuk.fromSnapshot(QueryDocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;

    return JadwalMasuk(
      id: document.id,
      namaPerusahaan: data['Nama_Usaha'] ?? '',
      jenisLimbah: data['Jenis_Limbah'] ?? '',
      jumlahLimbah: data['Jumlah_Limbah'] ?? '',
      harga: data['Harga'] ?? '',
      alamat: data['Alamat'] ?? '',
      status: data['Status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Nama_Usaha': namaPerusahaan,
      'Jenis_Limbah': jenisLimbah,
      'Jumlah_Limbah': jumlahLimbah,
      'Harga': harga,
      'Alamat': alamat,
      'Status': status,
    };
  }
}
