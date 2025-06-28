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
              SizedBox(height: 5.0),
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
              SizedBox(height: 8.0),
              Text(
                'Nomor telpon',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              SizedBox(height: 5.0),
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
              SizedBox(height: 8.0),
              Text(
                'Jenis Limbah',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              SizedBox(height: 5.0),
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
              SizedBox(height: 8.0),
              Obx(
                () => _buildTextField(
                  label: 'Jumlah Limbah',
                  controller: controller.jumlahLimbah,
                  validatorMsg: 'Jumlah Limbah is required',
                  readOnly: controller.isJumlahLimbahReadOnly.value,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      controller
                          .updateHarga(controller.selectedJenisLimbah.value);
                    }
                  },
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Harga Limbah',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              SizedBox(height: 5.0),
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
              SizedBox(height: 8.0),
              Text(
                'Alamat',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              SizedBox(height: 5.0),
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
              SizedBox(height: 8.0),
              Text(
                'Penanggung Jawab',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              SizedBox(height: 5.0),
              TextFormField(
                controller: controller.penanggungJawabC,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Penanggung Jawab is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                  onPressed: controller.createJadwal,
                  child: Center(child: Text('Kirim')))
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
    required bool readOnly,
    int maxLines = 1,
    void Function(String)? onChanged, // Tambahkan onChanged di sini
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
        const SizedBox(height: 4.0),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          maxLines: maxLines,
          readOnly: readOnly,
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
    );
  }
}
