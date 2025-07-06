import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/screens/supplier/controller/supplier_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    final selectedTabLogin = ValueNotifier(_Tab.memintaPersetujuan);
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
            Center(
              child: Text(
                "Data Pengajuan Pengangkutan",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: ValueListenableBuilder<_Tab>(
                valueListenable: selectedTabLogin,
                builder: (context, value, child) {
                  return Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.zero,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              selectedTabLogin.value = _Tab.memintaPersetujuan;
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: value == _Tab.memintaPersetujuan
                                    ? Colors.green
                                    : Colors.transparent,
                                borderRadius: BorderRadius.zero,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "Meminta Persetujuan",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: value == _Tab.memintaPersetujuan
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              selectedTabLogin.value = _Tab.pending;
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: value == _Tab.pending
                                    ? Colors.green
                                    : Colors.transparent,
                                borderRadius: BorderRadius.zero,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "Ditolak",
                                style: TextStyle(
                                  color: value == _Tab.pending
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              selectedTabLogin.value = _Tab.finish;
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: value == _Tab.finish
                                    ? Colors.green
                                    : Colors.transparent,
                                borderRadius: BorderRadius.zero,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "Selesai",
                                style: TextStyle(
                                  color: value == _Tab.finish
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Use ValueListenableBuilder to listen to changes in selectedTabLogin
            ValueListenableBuilder<_Tab>(
              valueListenable: selectedTabLogin,
              builder: (context, value, child) {
                // Pilih list berdasarkan tab
                final list = value == _Tab.memintaPersetujuan
                    ? controller.memintaPersetujuanList
                    : value == _Tab.pending
                        ? controller.pendingList
                        : controller.finishList;

                return Obx(() {
                  if (list.isEmpty) {
                    return const Center(child: Text('No data available'));
                  }

                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final jadwal = list[index];
                      return GestureDetector(
                        onTap: () {
                          if (jadwal.status == '0') {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  elevation: 5.0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Konfirmasi Penyetujuan Limbah',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.apply(
                                                fontWeightDelta: 2,
                                                color: Colors.black,
                                              ),
                                        ),
                                        const SizedBox(height: 16.0),
                                        Text(
                                          jadwal.namaPerusahaan,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.apply(
                                                fontWeightDelta: 2,
                                              ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          jadwal.alamat,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                        const SizedBox(height: 12.0),
                                        RichText(
                                          text: TextSpan(
                                            text: 'Jenis Limbah',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.apply(
                                                  fontWeightDelta: 1,
                                                  color: Colors.black87,
                                                ),
                                            children: [
                                              const TextSpan(text: ' | '),
                                              TextSpan(
                                                text: jadwal.jenisLimbah,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 6.0),
                                        RichText(
                                          text: TextSpan(
                                            text: 'Jumlah Limbah',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.apply(
                                                  fontWeightDelta: 1,
                                                  color: Colors.black87,
                                                ),
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
                                        const SizedBox(height: 6.0),
                                        RichText(
                                          text: TextSpan(
                                            text: 'Penanggung Jawab',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.apply(
                                                  fontWeightDelta: 1,
                                                  color: Colors.black87,
                                                ),
                                            children: [
                                              const TextSpan(text: ' | '),
                                              TextSpan(
                                                text: jadwal.penanggungJawab,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 12.0),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            jadwal.status == '0'
                                                ? 'Meminta Persetujuan'
                                                : jadwal.status == '1'
                                                    ? 'Ditolak'
                                                    : 'Selesai',
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
                          }
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 20.0),
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  jadwal.namaPerusahaan,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  jadwal.alamat,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Penanggung Jawab :',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    Text(' '),
                                    Text(
                                      jadwal.penanggungJawab,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.apply(
                                            color: AppColors.darkGrey,
                                          ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Telp :',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    Text(' '),
                                    Text(
                                      jadwal.noTelp,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.apply(
                                            color: AppColors.darkGrey,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    jadwal.status == '0'
                                        ? 'Meminta Persetujuan'
                                        : jadwal.status == '1'
                                            ? 'Ditolak'
                                            : 'Selesai',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: jadwal.status == '0' ||
                                                  jadwal.status == '1'
                                              ? AppColors.error
                                              : Colors.green,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 12.0),
                  );
                });
              },
            ),
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

enum _Tab { memintaPersetujuan, pending, finish }
