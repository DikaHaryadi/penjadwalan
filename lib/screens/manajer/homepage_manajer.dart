import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/constant/custom_size.dart';
import 'package:example/constant/storage_util.dart';
import 'package:example/controllers/calendar_controller.dart';
import 'package:example/screens/manajer/kartu_manajer.dart';
import 'package:example/theme/app_colors.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../models/event_calendar.dart';

class HomepageManajer extends StatefulWidget {
  const HomepageManajer({super.key});

  @override
  State<HomepageManajer> createState() => _HomepageManajerState();
}

class _HomepageManajerState extends State<HomepageManajer> {
  @override
  Widget build(BuildContext context) {
    final storageUtil = StorageUtil();
    final selectedTabLogin = ValueNotifier(_Tab.belumDisetujui);
    final tableController = Get.put(TableEventsController());

    String getStatusText(String status) {
      if (status == '0') return 'Meminta Persetujuan';
      if (status == '1') return 'Sudah Disetujui';
      if (status == '2' || status == '3') return 'Selesai Diantar';
      return 'Status Tidak Dikenal';
    }

    Color getStatusColor(String status) {
      if (status == '0') return AppColors.error;
      return Colors.green;
    }

    return SafeArea(
      child: ListView(
        children: [
          Row(
            children: [
              Container(
                width: 56.0,
                height: 56.0,
                margin: const EdgeInsets.only(left: 20.0),
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
              const SizedBox(width: CustomSize.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '👋 Halo Manajer',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    storageUtil.getName(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
              Expanded(child: Container()),
              IconButton(
                  onPressed: () {
                    showGeneralDialog(
                      barrierDismissible: true,
                      barrierLabel: "Kartu",
                      context: context,
                      transitionDuration: const Duration(milliseconds: 400),
                      transitionBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, -1),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOut,
                          )),
                          child: child,
                        );
                      },
                      pageBuilder: (context, _, __) => Center(
                        child: Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 1.8,
                          child: const Scaffold(
                            body: KartuManajer(),
                          ),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Iconsax.card))
            ],
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 0, 10),
            child: Text(
              "Data Persetujuan",
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
                            selectedTabLogin.value = _Tab.belumDisetujui;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: value == _Tab.belumDisetujui
                                  ? Colors.green
                                  : Colors.transparent,
                              borderRadius: BorderRadius.zero,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Belum Disetujui",
                              style: TextStyle(
                                color: value == _Tab.belumDisetujui
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
                            selectedTabLogin.value = _Tab.sudahDisetujui;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: value == _Tab.sudahDisetujui
                                  ? Colors.green
                                  : Colors.transparent,
                              borderRadius: BorderRadius.zero,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Sudah Disetujui",
                              style: TextStyle(
                                color: value == _Tab.sudahDisetujui
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
                              "Selesai Diantar",
                              textAlign: TextAlign.center,
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
              return FutureBuilder<List<Event>>(
                future: tableController.getEventsByStatus(
                  value == _Tab.belumDisetujui
                      ? ['0']
                      : value == _Tab.sudahDisetujui
                          ? ['1']
                          : ['2', '3'], // _Tab.finish
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No data available'));
                  } else {
                    List<Event>? jadwalList = snapshot.data;
                    return ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: jadwalList!.length,
                      itemBuilder: (context, index) {
                        var jadwal = jadwalList[index];
                        final isValid = (value == _Tab.belumDisetujui &&
                                jadwal.status == '0') ||
                            (value == _Tab.sudahDisetujui &&
                                jadwal.status == '1') ||
                            (value == _Tab.finish &&
                                (jadwal.status == '2' || jadwal.status == '3'));

                        if (isValid) {
                          // tampilkan kartu
                        } else {
                          return const SizedBox.shrink();
                        }

                        if (isValid) {
                          return GestureDetector(
                            onTap: () {
                              if (jadwal.status == '0') {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
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
                                              jadwal.namaUsaha,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.apply(fontWeightDelta: 2),
                                            ),
                                            const SizedBox(height: 8.0),
                                            Text(
                                              jadwal.alamat,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                            const SizedBox(height: 12.0),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                    text: 'Jumlah Limbah',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.apply(
                                                            fontWeightDelta: 1,
                                                            color:
                                                                Colors.black87),
                                                    children: [
                                                      const TextSpan(
                                                          text: ' | '),
                                                      TextSpan(
                                                        text:
                                                            jadwal.jumlahLimbah,
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
                                                      ?.apply(
                                                          color:
                                                              AppColors.error),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 12.0),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                    text: 'Tgl',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium,
                                                    children: [
                                                      const TextSpan(
                                                          text: ' | '),
                                                      TextSpan(
                                                        text: DateFormat(
                                                                'dd MMM yyyy')
                                                            .format(
                                                                jadwal.date!),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  jadwal.telp,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.apply(
                                                          color: AppColors
                                                              .darkGrey),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 12.0),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                getStatusText(jadwal.status),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: getStatusColor(
                                                          jadwal.status),
                                                    ),
                                              ),
                                            ),
                                            const SizedBox(height: 16.0),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextButton(
                                                  onPressed: () => Get.back(),
                                                  child: Text(
                                                    'Batalkan',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                          color:
                                                              Colors.redAccent,
                                                        ),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                        title: const Text(
                                                            'Konfirmasi Persetujuan'),
                                                        content: const Text(
                                                            'Apakah Anda yakin ingin menyetujui jadwal ini?'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(), // Batal
                                                            child: const Text(
                                                                'Batal'),
                                                          ),
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(); // Tutup dialog
                                                              await tableController
                                                                  .editStatusByManajer(
                                                                      jadwal
                                                                          .id!,
                                                                      jadwal
                                                                          .status);
                                                              setState(() {});
                                                            },
                                                            child: const Text(
                                                              'Setujui',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .green),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.green,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 12.0,
                                                        horizontal: 24.0),
                                                  ),
                                                  child: const Text('Setujui'),
                                                ),
                                              ],
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
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
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
                                      jadwal.namaUsaha,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      jadwal.alamat,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            text: 'Jumlah Limbah',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          DateFormat('dd MMM yyyy')
                                              .format(jadwal.date!),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                        Text(
                                          jadwal.telp,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.apply(
                                                  color: AppColors.darkGrey),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8.0),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        getStatusText(jadwal.status),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  getStatusColor(jadwal.status),
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 12.0),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

enum _Tab { belumDisetujui, sudahDisetujui, finish }
