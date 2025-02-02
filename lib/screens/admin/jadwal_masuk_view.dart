import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_colors.dart';
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
            child: Text('Tidak ada data'),
          );
        }
        return ListView.builder(
          itemCount: controller.userList.length,
          padding: const EdgeInsets.only(top: 12.0),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final jadwal = controller.userList[index];
            return Card(
              margin:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        jadwal.namaPerusahaan,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(),
                    Text('Alamat :',
                        style: Theme.of(context).textTheme.labelMedium),
                    Text(
                      jadwal.alamat,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.apply(color: Colors.green),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Jenis Limbah',
                        style: Theme.of(context).textTheme.titleSmall,
                        children: [
                          const TextSpan(text: ' | '),
                          TextSpan(
                            text: jadwal.jenisLimbah,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      jadwal.harga,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8.0),
                    if (jadwal.status == '0')
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton(
                              onPressed: () =>
                                  controller.updateStatus(jadwal.id!, '1'),
                              child: Text('Tolak')),
                          ElevatedButton(
                              onPressed: () =>
                                  controller.updateStatus(jadwal.id!, '2'),
                              child: Text('Terima'))
                        ],
                      ),
                    if (jadwal.status == '1')
                      Center(
                        child: Text(
                          'Jadwal Masuk Di Tolak',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.apply(color: Colors.red),
                        ),
                      ),
                    if (jadwal.status == '2')
                      Center(
                        child: Text(
                          'Jadwal Masuk Di Terima',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.apply(color: Colors.green),
                        ),
                      )
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
