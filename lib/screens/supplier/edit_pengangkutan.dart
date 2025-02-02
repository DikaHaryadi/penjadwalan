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
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
                onPressed: () {
                  controller.updateJadwal(
                      id,
                      alamat.text.trim(),
                      harga.text.trim(),
                      jenisLimbah.text.trim(),
                      jumlahLimbah.text.trim(),
                      namaUsaha.text.trim());
                },
                child: Text('Update')),
          )
        ],
      ),
      body: Form(
          key: controller.formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            children: [
              Text('Nama Perusahaan'),
              TextFormField(
                controller: namaUsaha,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama perusahaan is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8.0),
              Text('Jenis limbah'),
              TextFormField(
                controller: jenisLimbah,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jenis limbah is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8.0),
              Text('Jumlah limbah'),
              TextFormField(
                controller: jumlahLimbah,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah limbah is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8.0),
              Text('Harga'),
              TextFormField(
                controller: harga,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8.0),
              Text('Alamat'),
              TextFormField(
                controller: alamat,
                maxLines: 10,
                minLines: 1,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat is required';
                  }
                  return null;
                },
              ),
            ],
          )),
    );
  }
}
