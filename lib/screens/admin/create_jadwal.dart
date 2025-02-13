import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../supplier/controller/supplier_controller.dart';
import 'controllers/buatjadwal_controller.dart';
import 'controllers/master_driver_controller.dart';

class CreateJadwal extends StatelessWidget {
  const CreateJadwal({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BuatjadwalController>();
    final supplierController = Get.put(SupplierController());
    final masterDriver = Get.put(MasterDriverController());
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
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;

          if (controller.waktuC.text.isEmpty &&
              controller.telpC.text.isEmpty &&
              controller.platNomorC.text.isEmpty &&
              controller.jumlahLimbahC.text.isEmpty &&
              controller.namaUsahaC.text.isEmpty &&
              controller.alamatC.text.isEmpty &&
              controller.hargaC.text.isEmpty &&
              controller.jenisLimbahC.text.isEmpty &&
              controller.jumlahLimbahC.text.isEmpty &&
              controller.driverC.text.isEmpty) {
            Get.back();
          } else {
            final isConfirmed = await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Peringatan'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                          'Perubahan belum disimpan. Apakah Anda ingin melanjutkan?')
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(Get.overlayContext!).pop(false);
                        },
                        child: Text('Batalkan')),
                    TextButton(
                        onPressed: () {
                          controller.resetEditState();
                          Navigator.of(Get.overlayContext!).pop(true);
                        },
                        child: Text('Kembali')),
                  ],
                );
              },
            );

            if (isConfirmed == true) {
              Get.back();
            }
          }
        },
        child: Form(
          key: controller.formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            children: [
              Text('Nama usaha'),
              Obx(() {
                // Tentukan nilai default yang dipilih
                String? selectedNamaPerusahaan =
                    supplierController.userList.isEmpty
                        ? null
                        : controller.namaUsahaC.text.isEmpty
                            ? 'Pilih Nama Perusahaan'
                            : controller.namaUsahaC.text;

                // Ambil semua nama perusahaan yang memiliki status '2'
                final dropdownValues = supplierController.userList
                    .where((supplier) => supplier.status == '2')
                    .map((e) => e.namaPerusahaan)
                    .toList();

                // Debugging: Cetak daftar perusahaan yang ada
                print("=== Dropdown Values ===");
                print(dropdownValues);

                // Pastikan nilai selectedNamaPerusahaan ada di dalam dropdown
                if (!dropdownValues.contains(selectedNamaPerusahaan)) {
                  selectedNamaPerusahaan = 'Pilih Nama Perusahaan';
                }

                print("Selected Nama Perusahaan: $selectedNamaPerusahaan");

                return DropdownButtonFormField<String>(
                  value: selectedNamaPerusahaan,
                  items: [
                    DropdownMenuItem<String>(
                      value: 'Pilih Nama Perusahaan',
                      child: Text('Pilih Nama Perusahaan'),
                    ),
                    // Tambahkan hanya perusahaan dengan status '2'
                    ...supplierController.userList
                        .where((supplier) => supplier.status == '2')
                        .map((supplier) {
                      print(
                          "Menambahkan ke dropdown: ${supplier.namaPerusahaan}");
                      return DropdownMenuItem(
                        value: supplier.namaPerusahaan,
                        child: Text(supplier.namaPerusahaan),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    if (value != null && value != 'Pilih Nama Perusahaan') {
                      // Cari data berdasarkan nama perusahaan yang dipilih
                      final selectedSupplier = supplierController.userList
                          .firstWhere((s) => s.namaPerusahaan == value);

                      // Set nilai ke controller
                      controller.namaUsahaC.text =
                          selectedSupplier.namaPerusahaan;
                      controller.alamatC.text = selectedSupplier.alamat;
                      controller.hargaC.text = selectedSupplier.harga;
                      controller.jenisLimbahC.text =
                          selectedSupplier.jenisLimbah;
                      controller.jumlahLimbahC.text =
                          selectedSupplier.jumlahLimbah;
                      controller.telpC.text = selectedSupplier.noTelp;
                    }
                  },
                );
              }),
              const SizedBox(height: 8.0),
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
                          firstDate: DateTime
                              .now(), // Membatasi tanggal sebelum hari ini
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
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8.0),
              Text('Nama Driver'),
              Obx(() {
                String? selectedValue = masterDriver.userList.isEmpty
                    ? null
                    : controller.driverC.text.isEmpty
                        ? 'Pilih Nama Driver' // Default value
                        : controller.driverC.text;

                return DropdownButtonFormField<String>(
                  value: selectedValue,
                  items: [
                    DropdownMenuItem<String>(
                      value: 'Pilih Nama Driver',
                      child: Text('Pilih Nama Driver'),
                    ),
                    // Filter userList agar tidak menampilkan nama perusahaan yang sudah ada di Firebase
                    ...masterDriver.userList
                        .where((supplier) =>
                            (supplier.statusPengangkutan == '0' ||
                                supplier.statusPengangkutan == '1'))
                        .map((supplier) => DropdownMenuItem(
                              value: supplier.namaDriver,
                              child: Text(supplier.namaDriver),
                            ))
                        .toList(),
                  ],
                  onChanged: (value) {
                    if (value != null && value != 'Pilih Nama Driver') {
                      // Cari data yang sesuai dengan nama usaha yang dipilih
                      final selectedSupplier = masterDriver.userList
                          .firstWhere((s) => s.namaDriver == value);

                      // Set nilai pada controller sesuai dengan data yang ditemukan
                      controller.driverC.text = selectedSupplier.namaDriver;
                      controller.platNomorC.text = selectedSupplier.platNomor;
                    }
                  },
                );
              }),
              const SizedBox(height: 8.0),
              Text('Harga'),
              TextFormField(
                controller: controller.hargaC,
                readOnly: true,
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
                readOnly: true,
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
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah limbah is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8.0),
              Text('Plat nomor'),
              TextFormField(
                controller: controller.platNomorC,
                readOnly: true,
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
                readOnly: true,
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
                readOnly: true, // Supaya user tidak bisa mengetik manual
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (!context.mounted) return; // Pastikan context masih valid

                  if (pickedTime != null) {
                    // Format waktu menjadi HH:mm (24 jam format)
                    final formattedTime = pickedTime.format(context);
                    controller.waktuC.text =
                        formattedTime; // Set hasil ke TextFormField
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Waktu is required';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Pilih Waktu",
                  suffixIcon: Icon(Icons.access_time), // Tambahkan ikon jam
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
