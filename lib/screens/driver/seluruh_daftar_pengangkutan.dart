import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';

import '../../constant/custom_size.dart';
import '../../theme/app_colors.dart';
import 'seluruh_daftar_pengangkutan_controller.dart';

class SeluruhDaftarPengangkutan extends StatelessWidget {
  const SeluruhDaftarPengangkutan({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SeluruhDaftarPengangkutanController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Seluruh Daftar Pengangkutan'),
      ),
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.seluruhDaftarPengangkutanModels.isEmpty) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (controller.seluruhDaftarPengangkutanModels.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/animations/y0vHJ9cAfQ.json',
                  width: MediaQuery.of(context).size.width / 2,
                ),
                Text(
                  'Jadwal Tidak Ditemukan',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: controller.seluruhDaftarPengangkutanModels.length,
          itemBuilder: (context, index) {
            final events = controller.seluruhDaftarPengangkutanModels[index];
            return Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical:
                    8.0, // Increased vertical margin for better separation
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: CustomSize.sm,
                vertical: CustomSize.sm, // Adjusted padding for balance
              ),
              decoration: BoxDecoration(
                color: Colors.white, // Optional: adding a background color
                border: Border.all(
                    color: Colors
                        .grey.shade300), // Lighter border color for subtleness
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.1), // Soft shadow for subtle depth
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2), // Shadow direction
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment
                    .start, // Ensure all child elements are aligned to the left
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      events.namaUsaha,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87, // Ensuring readability
                              ),
                    ),
                  ),
                  Text(
                    events.alamat,
                    style: Theme.of(context).textTheme.bodyMedium?.apply(
                          color: Colors.grey
                              .shade700, // Slightly lighter for better contrast
                        ),
                  ),
                  const SizedBox(height: CustomSize.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Iconsax.mobile, size: 16),
                          const SizedBox(width: CustomSize.sm),
                          Text(events.telp),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Iconsax.timer, size: 16),
                          const SizedBox(width: CustomSize.sm),
                          Text(events.waktu),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: CustomSize.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Iconsax.receipt_item, size: 16),
                          const SizedBox(width: CustomSize.sm),
                          Text(events.jenisLimbah),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Iconsax.graph, size: 16),
                          const SizedBox(width: CustomSize.sm),
                          Text('${events.jumlahLimbah} drum'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: CustomSize.sm),
                  Row(
                    children: [
                      Text(
                        'Driver',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(width: CustomSize.sm),
                      Text(events.driver),
                    ],
                  ),
                  const SizedBox(height: CustomSize.sm),
                  Row(
                    children: [
                      Text(
                        'Plat Nomor',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(width: CustomSize.sm),
                      Text(events.platNomer),
                    ],
                  ),
                  const SizedBox(height: CustomSize.sm),
                  Row(
                    children: [
                      Text(
                        'Penanggung Jawab',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(width: CustomSize.sm),
                      Text(events.penanggungJawab),
                    ],
                  ),
                  const SizedBox(height: CustomSize.md),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      events.status == '0'
                          ? 'Belum Disetujui Manajer'
                          : events.status == '1'
                              ? 'Belum Diangkut'
                              : events.status == '2'
                                  ? 'Sedang Diangkut'
                                  : 'Telah Diantarkan',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color:
                                (events.status == '0' || events.status == '1')
                                    ? AppColors.error
                                    : events.status == '2'
                                        ? Colors.blue
                                        : Colors.green,
                          ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
