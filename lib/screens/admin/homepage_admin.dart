import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/screens/admin/create_jadwal.dart';
import 'package:example/screens/admin/edit_jadwal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../constant/custom_size.dart';
import '../../constant/storage_util.dart';
import '../../theme/app_colors.dart';
import 'controllers/buatjadwal_controller.dart';

class HomepageAdmin extends StatelessWidget {
  const HomepageAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final storageUtil = StorageUtil();
    final controller = Get.put(BuatjadwalController());
    return RefreshIndicator(
      onRefresh: () async {
        await controller.fetchJadwal();
      },
      child: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: CustomSize.spaceBtwItems),
              child: Row(
                children: [
                  Container(
                    width: 56.0,
                    height: 56.0,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(100)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        imageUrl: storageUtil.getImage(),
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (_, __, ___) =>
                            const CircularProgressIndicator(),
                        errorWidget: (_, __, ___) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                  const SizedBox(width: CustomSize.spaceBtwItems),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('👋 Hallo...',
                          style: Theme.of(context).textTheme.headlineMedium),
                      Text(storageUtil.getName(),
                          style: Theme.of(context).textTheme.headlineMedium)
                    ],
                  ),
                  Expanded(child: Container()),
                  IconButton(
                      onPressed: () => Get.toNamed('/add-user'),
                      icon: Icon(Iconsax.user_add))
                ],
              ),
            ),
            Divider(),
            Row(
              children: [
                Expanded(child: Container()),
                Text('Daftar Jadwal',
                    style: Theme.of(context).textTheme.headlineMedium),
                Expanded(child: Container()),
                IconButton(
                    onPressed: () {
                      Get.to(() => CreateJadwal());
                    },
                    icon: Icon(Icons.add))
              ],
            ),
            Obx(() {
              if (controller.userList.isEmpty) {
                return const Center(
                  child: Text('Tidak ada data pengguna'),
                );
              }

              return ListView.builder(
                itemCount: controller.userList.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final jadwal = controller.userList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 5.0),
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: jadwal.status == '0'
                                ? MainAxisAlignment.spaceBetween
                                : MainAxisAlignment.start,
                            children: [
                              Text(
                                jadwal.namaUsaha,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              if (jadwal.status == '0')
                                Row(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          Get.to(
                                              () => EditJadwal(model: jadwal));
                                        },
                                        child: Icon(Icons.edit)),
                                    InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text(
                                                    'Konfirmasi Penghapusan'),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                        'Apakah anda yakin untuk menghapus ini?')
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(Get
                                                                .overlayContext!)
                                                            .pop();
                                                      },
                                                      child: Text('Batalkan')),
                                                  TextButton(
                                                      onPressed: () {
                                                        controller.deleteJadwal(
                                                            jadwal.id!);
                                                      },
                                                      child: Text('Hapus')),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        )),
                                  ],
                                )
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            jadwal.alamat,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: 'Jumlah Limbah',
                                  style: Theme.of(context).textTheme.titleSmall,
                                  children: [
                                    const TextSpan(text: ' | '),
                                    TextSpan(
                                      text: jadwal.jumlahLimbah,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                jadwal.jenisLimbah,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.apply(color: AppColors.error),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat('dd MMM yyyy').format(jadwal.date!),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                jadwal.telp,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.apply(color: AppColors.darkGrey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              jadwal.status == '0'
                                  ? 'Meminta Persetujuan'
                                  : 'Sudah Disetujui',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: jadwal.status == '0'
                                        ? AppColors.error
                                        : Colors.green,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            })
          ],
        ),
      ),
    );
  }
}
