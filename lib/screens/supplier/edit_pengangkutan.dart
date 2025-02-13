import 'package:example/models/jadwal_masuk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/supplier_controller.dart';

class EditPengangkutan extends StatefulWidget {
  const EditPengangkutan({super.key, required this.model});

  final JadwalMasuk model;

  @override
  State<EditPengangkutan> createState() => _EditPengangkutanState();
}

class _EditPengangkutanState extends State<EditPengangkutan> {
  late String id;
  late TextEditingController alamat;
  late TextEditingController harga;
  late TextEditingController namaUsaha;
  late TextEditingController jenisLimbah;
  late TextEditingController jumlahLimbah;

  @override
  void initState() {
    super.initState();
    id = widget.model.id!;
    alamat = TextEditingController(text: widget.model.alamat);
    harga = TextEditingController(text: widget.model.harga);
    namaUsaha = TextEditingController(text: widget.model.namaPerusahaan);
    jenisLimbah = TextEditingController(text: widget.model.jenisLimbah);
    jumlahLimbah = TextEditingController(text: widget.model.jumlahLimbah);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SupplierController>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubah Jadwal'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                controller.updateJadwal(
                  id,
                  alamat.text.trim(),
                  harga.text.trim(),
                  jenisLimbah.text.trim(),
                  jumlahLimbah.text.trim(),
                  namaUsaha.text.trim(),
                );
              },
              icon: Icon(Icons.update),
              label: Text('Update'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildInputField('Nama Perusahaan', namaUsaha, TextInputType.name),
              buildInputField('Jenis Limbah', jenisLimbah, TextInputType.text),
              buildInputField(
                  'Jumlah Limbah', jumlahLimbah, TextInputType.text),
              buildInputField('Harga', harga, TextInputType.number),
              buildInputField('Alamat', alamat, TextInputType.text,
                  maxLines: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField(
      String label, TextEditingController controller, TextInputType inputType,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
          const SizedBox(height: 4.0),
          TextFormField(
            controller: controller,
            keyboardType: inputType,
            maxLines: maxLines,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '$label is required';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
