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
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              onPressed: controller.createJadwal,
              icon: Icon(Icons.add),
              label: Text('Tambah'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
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
              Text(
                'Nama Perusahaan',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              TextFormField(
                controller: controller.namaPerusahaanC,
                readOnly: true,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Perusahaan is required';
                  }
                  return null;
                },
              ),
              Text(
                'Nomor telpon',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              TextFormField(
                controller: controller.nomorTelponC,
                readOnly: true,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor telpon is required';
                  }
                  return null;
                },
              ),
              Text(
                'Jenis Limbah',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              Obx(() {
                return DropdownButtonFormField<String>(
                  value: controller.selectedJenisLimbah.value.isNotEmpty
                      ? controller.selectedJenisLimbah.value
                      : null,
                  hint: Text('Pilih Jenis Limbah'),
                  items: controller.kategoriBarang.map((supplier) {
                    return DropdownMenuItem(
                      value: supplier.jenisLimbah,
                      child: Text(supplier.jenisLimbah),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.jenisLimbahC.text =
                          value; // 🔥 Simpan nilai ke controller
                      controller.updateHarga(value);
                    }
                  },
                );
              }),
              _buildTextField(
                label: 'Jumlah Limbah',
                controller: controller.jumlahLimbah,
                validatorMsg: 'Jumlah Limbah is required',
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    controller
                        .updateHarga(controller.selectedJenisLimbah.value);
                  }
                },
              ),
              Text(
                'Harga Limbah',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              TextFormField(
                controller: controller.hargaC,
                readOnly: true,
                decoration: InputDecoration(
                  suffix: Obx(() => Text(controller
                      .satuanLimbah.value)), // 🔥 Pastikan satuan diperbarui
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              Text(
                'Alamat',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              TextFormField(
                controller: controller.alamatC,
                readOnly: true,
                maxLines: 3,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat is required';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String validatorMsg,
    int maxLines = 1,
    void Function(String)? onChanged, // Tambahkan onChanged di sini
  }) {
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
            keyboardType: TextInputType.text,
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
                return validatorMsg;
              }
              return null;
            },
            onChanged: onChanged, // Gunakan onChanged di sini
          ),
        ],
      ),
    );
  }
}
