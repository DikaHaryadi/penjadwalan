import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../supplier/controller/supplier_controller.dart';

class JadwalMasukView extends StatelessWidget {
  const JadwalMasukView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SupplierController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jadwal Masuk',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.userList.isEmpty) {
          return const Center(
            child: Text(
              'Tidak ada data',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            controller.onInit();
          },
          child: ListView.builder(
            itemCount: controller.userList.length,
            padding: const EdgeInsets.all(12.0),
            itemBuilder: (context, index) {
              final jadwal = controller.userList[index];
              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                elevation: 6.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          jadwal.namaPerusahaan,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Divider(color: Colors.grey.shade300),
                      const SizedBox(height: 8),
                      Text(
                        'Alamat :',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Text(
                        jadwal.alamat,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.green, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          text: 'Jenis Limbah: ',
                          style: Theme.of(context).textTheme.titleSmall,
                          children: [
                            TextSpan(
                              text: jadwal.jenisLimbah,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Harga: ${jadwal.harga}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Row(children: [
                        Text('Penanggung Jawab:',
                            style: Theme.of(context).textTheme.bodyMedium),
                        Text(' ${jadwal.penanggungJawab}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold)),
                      ]),
                      const SizedBox(height: 16.0),
                      if (jadwal.status == '0')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Tooltip(
                              message: 'Tolak jadwal ini',
                              child: FilledButton.tonal(
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Konfirmasi Penolakan'),
                                      content: const Text(
                                          'Apakah Anda yakin ingin menolak jadwal ini?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(context)
                                              .pop(), // Batal
                                          child: const Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Tutup dialog
                                            controller.updateStatus(jadwal.id!,
                                                '1'); // Lanjutkan tolak
                                          },
                                          child: const Text(
                                            'Tolak',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: const Text('Tolak'),
                              ),
                            ),
                            Tooltip(
                              message: 'Terima jadwal ini',
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title:
                                          const Text('Konfirmasi Penerimaan'),
                                      content: const Text(
                                          'Apakah Anda yakin ingin menerima jadwal ini?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(context)
                                              .pop(), // Batal
                                          child: const Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Tutup dialog
                                            controller.updateStatus(
                                                jadwal.id!, '2');
                                          },
                                          child: const Text(
                                            'Terima',
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: const Text('Terima'),
                              ),
                            ),
                          ],
                        ),
                      if (jadwal.status == '1')
                        Center(
                          child: Text(
                            'Jadwal Masuk Ditolak',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: Colors.red, fontSize: 16),
                          ),
                        ),
                      if (jadwal.status == '2')
                        Center(
                          child: Text(
                            'Jadwal Masuk Diterima',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: Colors.green, fontSize: 16),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
