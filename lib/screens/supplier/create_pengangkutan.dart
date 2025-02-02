import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/supplier_controller.dart';

class CreatePengangkutan extends StatelessWidget {
  const CreatePengangkutan({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SupplierController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pengangkutan Limbah',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
                onPressed: () {
                  controller.createJadwal();
                },
                child: Text('Tambah')),
          )
        ],
      ),
      body: Form(
          key: controller.formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            children: [
              Text('Nama perusahaan'),
              TextFormField(
                controller: controller.namaPerusahaanC,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama usaha is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8.0),
              Text('Jenis limbah'),
              TextFormField(
                controller: controller.jenisLimbahC,
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
                controller: controller.jumlahLimbah,
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
                controller: controller.hargaC,
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
                controller: controller.alamatC,
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
