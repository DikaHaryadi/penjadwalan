import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/screens/supplier/controller/supplier_controller.dart';
import 'package:example/screens/supplier/edit_pengangkutan.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:popover/popover.dart';

import '../../constant/custom_size.dart';
import '../../constant/storage_util.dart';
import '../../theme/app_colors.dart';

class HomeSupplier extends StatelessWidget {
  const HomeSupplier({super.key});

  @override
  Widget build(BuildContext context) {
    final storageUtil = StorageUtil();
    final controller = Get.put(SupplierController());
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchPengangkutan();
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
                    children: [
                      Text('👋 Hallo...',
                          style: Theme.of(context).textTheme.headlineMedium),
                      Text(storageUtil.getName(),
                          style: Theme.of(context).textTheme.headlineMedium),
                    ],
                  ),
                  Expanded(child: Container()),
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Button(
                      create: () => Get.toNamed('/add-jadwal-masuk'),
                      logout: storageUtil.logout,
                      createText: 'Buat Jadwal Masuk',
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Obx(() {
              if (controller.userList.isEmpty) {
                return const Center(
                  child: Text('Tidak ada data'),
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Konfirmasi Penghapusan'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                  'Apakah anda yakin untuk menghapus ini?')
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(
                                                          Get.overlayContext!)
                                                      .pop();
                                                },
                                                child: Text('Batalkan')),
                                            TextButton(
                                                onPressed: () {
                                                  controller
                                                      .deleteJadwal(jadwal.id!);
                                                },
                                                child: Text('Hapus')),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Icon(
                                    Iconsax.trash,
                                    color: Colors.red,
                                  )),
                              Text(
                                jadwal.namaPerusahaan,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Get.to(
                                        () => EditPengangkutan(model: jadwal));
                                  },
                                  child: Icon(
                                    Iconsax.edit,
                                    color: Colors.grey,
                                  )),
                            ],
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
                          RichText(
                            text: TextSpan(
                              text: 'Jumlah Limbah',
                              style: Theme.of(context).textTheme.titleSmall,
                              children: [
                                const TextSpan(text: ' | '),
                                TextSpan(
                                  text: jadwal.jumlahLimbah,
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
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              jadwal.status == '0'
                                  ? 'Meminta Persetujuan'
                                  : jadwal.status == '1'
                                      ? 'Di Tolak'
                                      : 'Di Terima',
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
        )),
      ),
    );
  }
}

class Button extends StatelessWidget {
  const Button(
      {super.key,
      required this.create,
      required this.logout,
      required this.createText});

  final Function create;
  final Function logout;
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
            logout: () {
              if (context.mounted) {
                Navigator.of(context).pop();
                logout();
              }
            },
            createText: createText,
          ),
          direction: PopoverDirection.bottom,
          backgroundColor: AppColors.darkGrey,
          width: 200,
          height: 150,
          arrowHeight: 10,
          arrowWidth: 10,
        );
      },
    );
  }
}

class ListItems extends StatelessWidget {
  const ListItems(
      {super.key,
      required this.create,
      required this.logout,
      required this.createText});

  final Function()? create;
  final Function()? logout;
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
            onTap: logout,
            child: Container(
              height: 50,
              color: AppColors.white,
              child: const Center(child: Text('Logout')),
            ),
          ),
        ],
      ),
    );
  }
}
