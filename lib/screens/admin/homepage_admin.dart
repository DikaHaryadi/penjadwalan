import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/screens/admin/create_jadwal.dart';
import 'package:example/screens/admin/edit_jadwal.dart';
import 'package:example/screens/admin/jadwal_masuk_view.dart';
import 'package:example/screens/admin/master_driver.dart';
import 'package:example/screens/admin/master_kategori.dart';
import 'package:example/screens/admin/master_supplier.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:popover/popover.dart';

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
          padding: const EdgeInsets.all(16.0),
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28.0,
                  backgroundImage:
                      CachedNetworkImageProvider(storageUtil.getImage()),
                  onBackgroundImageError: (_, __) =>
                      Icon(Icons.error, size: 28.0),
                ),
                const SizedBox(width: CustomSize.spaceBtwItems),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('👋 Hallo...',
                        style: Theme.of(context).textTheme.headlineMedium),
                    Text(storageUtil.getName(),
                        style: Theme.of(context).textTheme.headlineMedium),
                  ],
                ),
                Spacer(),
                ButtonAdmin(
                  create: () => Get.to(() => JadwalMasukView()),
                  masterKategori: () => Get.to(() => MasterKategoriBarang()),
                  masterSupplier: () => Get.to(() => MasterSupplier()),
                  masterDriver: () => Get.to(() => MasterDriver()),
                  createText: 'Jadwal Masuk',
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Daftar Jadwal',
                    style: Theme.of(context).textTheme.titleLarge),
                IconButton(
                  onPressed: () => Get.to(() => CreateJadwal()),
                  icon: Icon(Icons.add),
                ),
              ],
            ),
            Obx(() {
              if (controller.userList.isEmpty) {
                return const Center(child: Text('Tidak ada data pengguna'));
              }
              return ListView.builder(
                itemCount: controller.userList.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final jadwal = controller.userList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(jadwal.namaUsaha,
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              if (jadwal.status == '0')
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => Get.to(
                                          () => EditJadwal(model: jadwal)),
                                      icon: Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () => showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('Konfirmasi Penghapusan'),
                                          content: Text(
                                              'Apakah anda yakin untuk menghapus ini?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(
                                                      Get.overlayContext!)
                                                  .pop(),
                                              child: Text('Batalkan'),
                                            ),
                                            TextButton(
                                              onPressed: () => controller
                                                  .deleteJadwal(jadwal.id!),
                                              child: Text('Hapus'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Text(jadwal.alamat,
                              style: Theme.of(context).textTheme.bodyMedium),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: 'Jumlah Limbah | ',
                                  style: Theme.of(context).textTheme.titleSmall,
                                  children: [
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
                          Row(children: [
                            Text('Penanggung Jawab:',
                                style: Theme.of(context).textTheme.bodyMedium),
                            Text(' ${jadwal.penanggungJawab}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold)),
                          ]),
                          const SizedBox(height: 8.0),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              jadwal.status == '0'
                                  ? 'Meminta Persetujuan'
                                  : jadwal.status == '1'
                                      ? 'Sudah Disetujui Manajer'
                                      : jadwal.status == '2'
                                          ? 'Sedang Diangkut'
                                          : jadwal.status == '3'
                                              ? 'Selesai Diantar'
                                              : 'Status Tidak Dikenal',
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
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

class ButtonAdmin extends StatelessWidget {
  const ButtonAdmin(
      {super.key,
      required this.create,
      required this.masterKategori,
      required this.masterSupplier,
      required this.masterDriver,
      required this.createText});

  final Function create;
  final Function masterKategori;
  final Function masterSupplier;
  final Function masterDriver;
  final String createText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Icon(
        Icons.more_horiz,
        color: AppColors.secondarySoft,
      ),
      onTap: () {
        showPopover(
          context: context,
          bodyBuilder: (context) => ListItems(
            create: () {
              if (context.mounted) {
                Navigator.of(context).pop();
                create();
              }
            },
            masterKategori: () {
              if (context.mounted) {
                Navigator.of(context).pop();
                masterKategori();
              }
            },
            masterSupplier: () {
              if (context.mounted) {
                Navigator.of(context).pop();
                masterSupplier();
              }
            },
            masterDriver: () {
              if (context.mounted) {
                Navigator.of(context).pop();
                masterDriver();
              }
            },
            createText: createText,
          ),
          direction: PopoverDirection.bottom,
          backgroundColor: AppColors.darkGrey,
          width: 200,
          height: 210,
          arrowHeight: 10,
          arrowWidth: 10,
        );
      },
    );
  }
}

class ListItems extends StatelessWidget {
  const ListItems({
    super.key,
    required this.create,
    required this.masterKategori,
    required this.masterSupplier,
    required this.masterDriver,
    required this.createText,
  });

  final Function()? create;
  final Function()? masterKategori;
  final Function()? masterSupplier;
  final Function()? masterDriver;
  final String createText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          GestureDetector(
            onTap: create,
            child: Container(
              height: 50,
              color: AppColors.white,
              child: Center(child: Text(createText)),
            ),
          ),
          const Divider(),
          GestureDetector(
            onTap: masterKategori,
            child: Container(
              height: 50,
              color: AppColors.white,
              child: Center(child: Text('Master Kategori')),
            ),
          ),
          const Divider(),
          GestureDetector(
            onTap: () => Get.toNamed('/master-barang'),
            child: Container(
              height: 50,
              color: AppColors.white,
              child: const Center(child: Text('Master Barang')),
            ),
          ),
          const Divider(),
          GestureDetector(
            onTap: masterSupplier,
            child: Container(
              height: 50,
              color: AppColors.white,
              child: Center(child: Text('Master Supplier')),
            ),
          ),
          const Divider(),
          GestureDetector(
            onTap: masterDriver,
            child: Container(
              height: 50,
              color: AppColors.white,
              child: Center(child: Text('Master Driver')),
            ),
          ),
          const Divider(),
          GestureDetector(
            onTap: () => Get.toNamed('/add-user'),
            child: Container(
              height: 50,
              color: AppColors.white,
              child: const Center(child: Text('Buat User Baru')),
            ),
          ),
        ],
      ),
    );
  }
}
