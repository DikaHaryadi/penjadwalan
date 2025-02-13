import 'package:cloud_firestore/cloud_firestore.dart';

class MasterDriverModel {
  String namaDriver;
  String platNomor;
  String telp;
  String statusPengangkutan;

  MasterDriverModel({
    required this.namaDriver,
    required this.platNomor,
    required this.telp,
    required this.statusPengangkutan,
  });

  static MasterDriverModel empty() => MasterDriverModel(
        namaDriver: '',
        platNomor: '',
        telp: '',
        statusPengangkutan: '',
      );

  Map<String, dynamic> toJson() {
    return {
      'Nama_Driver': namaDriver,
      'Plat_Nomor': platNomor,
      'Telp': telp,
      'Status_Pengangkutan': statusPengangkutan,
    };
  }

  factory MasterDriverModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data();
      return MasterDriverModel(
          namaDriver: data?['Nama_Driver'] ?? '',
          platNomor: data?['Plat_Nomor'] ?? '',
          telp: data?['Telp'] ?? '',
          statusPengangkutan: data?['Status_Pengangkutan'] ?? '');
    } else {
      return MasterDriverModel.empty();
    }
  }
}
