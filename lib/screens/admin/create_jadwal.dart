import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'controllers/buatjadwal_controller.dart';

class CreateJadwal extends StatelessWidget {
  const CreateJadwal({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BuatjadwalController>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Buat Jadwal Baru'),
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
            Text('Tanggal'),
            Obx(
              () => TextFormField(
                keyboardType: TextInputType.none,
                readOnly: true,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        locale: const Locale("id", "ID"),
                        initialDate: controller.tgl.value,
                        firstDate: DateTime(1850),
                        lastDate: DateTime(2040),
                      ).then((newSelectedDate) {
                        if (newSelectedDate != null) {
                          controller.tgl.value = newSelectedDate;
                          print(
                              'Ini tanggal yang dipilih : ${controller.tgl.value}');
                        }
                      });
                    },
                    icon: const Icon(Icons.calendar_today),
                  ),
                  hintText:
                      DateFormat.yMMMMd('id_ID').format(controller.tgl.value),
                ),
              ),
            ),
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
            const SizedBox(height: 8.0),
            Text('Nama'),
            TextFormField(
              controller: controller.driverC,
              keyboardType: TextInputType.name,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama is required';
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
              controller: controller.jumlahLimbahC,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Jumlah limbah is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 8.0),
            Text('Nama usaha'),
            TextFormField(
              controller: controller.namaUsahaC,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama usaha is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 8.0),
            Text('Plat nomor'),
            TextFormField(
              controller: controller.platNomorC,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Plat nomor is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 8.0),
            Text('No Telp'),
            TextFormField(
              controller: controller.telpC,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'No Telp is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 8.0),
            Text('Waktu'),
            TextFormField(
              controller: controller.waktuC,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Waktu is required';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
