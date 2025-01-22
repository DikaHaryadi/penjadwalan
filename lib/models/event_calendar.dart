import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String? id;
  String alamat;
  String driver;
  String harga;
  String jenisLimbah;
  String jumlahLimbah;
  String namaUsaha;
  String platNomer;
  String status;
  final DateTime? date;
  String telp;
  String waktu;

  Event({
    this.id,
    required this.alamat,
    required this.driver,
    required this.harga,
    required this.jenisLimbah,
    required this.jumlahLimbah,
    required this.namaUsaha,
    required this.platNomer,
    required this.status,
    required this.date,
    required this.telp,
    required this.waktu,
  });

  @override
  factory Event.fromMap(Map<String, dynamic> data, String documentId) {
    final timestamp = data['Tanggal'] as Timestamp?;
    return Event(
      id: documentId,
      alamat: data['Alamat'] ?? '',
      driver: data['Driver'] ?? '',
      harga: data['Harga'] ?? '',
      jenisLimbah: data['Jenis_Limbah'] ?? '',
      jumlahLimbah: data['Jumlah_Limbah'] ?? '',
      namaUsaha: data['Nama_Usaha'] ?? '',
      platNomer: data['Plat_Nomer'] ?? '',
      status: data['Status'] ?? '',
      date: timestamp?.toDate(),
      telp: data['Telp'] ?? '',
      waktu: data['Waktu'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Alamat': alamat,
      'Driver': driver,
      'Harga': harga,
      'Jenis_Limbah': jenisLimbah,
      'Jumlah_Limbah': jumlahLimbah,
      'Nama_Usaha': namaUsaha,
      'Plat_Nomer': platNomer,
      'Status': status,
      'Tanggal': date != null ? Timestamp.fromDate(date!) : null,
      'Telp': telp,
      'Waktu': waktu
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'Alamat': alamat,
      'Driver': driver,
      'Harga': harga,
      'Jenis_Limbah': jenisLimbah,
      'Jumlah_Limbah': jumlahLimbah,
      'Nama_Usaha': namaUsaha,
      'Plat_Nomer': platNomer,
      'Status': status,
      'Tanggal': date != null ? Timestamp.fromDate(date!) : null,
      'Telp': telp,
      'Waktu': waktu
    };
  }

  factory Event.fromSnapshot(QueryDocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;
    final timestamp =
        data['Tanggal'] as Timestamp?; // Pastikan ini menangani Timestamp
    return Event(
      id: document.id,
      alamat: data['Alamat'] ?? '',
      driver: data['Driver'] ?? '',
      harga: data['Harga'] ?? '',
      jenisLimbah: data['Jenis_Limbah'] ?? '',
      jumlahLimbah: data['Jumlah_Limbah'] ?? '',
      namaUsaha: data['Nama_Usaha'] ?? '',
      platNomer: data['Plat_Nomer'] ?? '',
      status: data['Status'] ?? '',
      date: timestamp?.toDate(), // Konversi Timestamp ke DateTime
      telp: data['Telp'] ?? '',
      waktu: data['Waktu'] ?? '',
    );
  }
}

final kFirstDay = DateTime.utc(2010, 10, 16);
final kLastDay = DateTime.utc(2030, 3, 14);

List<DateTime> daysInRange(DateTime start, DateTime end) {
  final days = <DateTime>[];
  for (int i = 0; i <= end.difference(start).inDays; i++) {
    days.add(DateTime(start.year, start.month, start.day + i));
  }
  return days;
}
