import 'package:cloud_firestore/cloud_firestore.dart';

class BeritaModel {
  String? id;
  String deksripsi;
  String image;
  String tgl;
  String title;

  BeritaModel({
    this.id,
    required this.deksripsi,
    required this.image,
    required this.tgl,
    required this.title,
  });

  Map<String, dynamic> toJson() {
    return {
      'Deskripsi': deksripsi,
      'Image': image,
      'Tgl': tgl,
      'Title': title,
    };
  }

  factory BeritaModel.fromSnapshot(QueryDocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;
    return BeritaModel(
      id: document.id,
      deksripsi: data['Deskripsi'] ?? '',
      image: data['Image'] ?? '',
      tgl: data['Tgl'] ?? '',
      title: data['Title'] ?? '',
    );
  }
}
