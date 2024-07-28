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
    final selectedTabLogin = ValueNotifier(_Tab.suplier);
    final tableController = Get.put(TableEventsController());
    return SafeArea(
      child: Column(
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
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
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            selectedTabLogin.value = _Tab.suplier;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: value == _Tab.suplier
                                  ? Colors.green
                                  : Colors.transparent,
                              borderRadius: BorderRadius.zero,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Belum Disetujui",
                              style: TextStyle(
                                color: value == _Tab.suplier
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
                            selectedTabLogin.value = _Tab.driver;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: value == _Tab.driver
                                  ? Colors.green
                                  : Colors.transparent,
                              borderRadius: BorderRadius.zero,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Sudah Disetujui",
                              style: TextStyle(
                                color: value == _Tab.driver
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
                future: tableController
                    .getEventsByStatus(value == _Tab.suplier ? '0' : '1'),
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
                        if ((value == _Tab.suplier && jadwal.status == '0') ||
                            (value == _Tab.driver && jadwal.status == '1')) {
                          return GestureDetector(
                            onTap: () {
                              jadwal.status == '0'
                                  ? showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          actions: [
                                            TextButton(
                                                onPressed: () => Get.back(),
                                                child: const Text('Batalkan')),
                                            TextButton(
                                                onPressed: () async {
                                                  await tableController
                                                      .editStatusByManajer(
                                                          jadwal.id,
                                                          jadwal.status);
                                                  setState(() {});
                                                },
                                                child: const Text('Setujui'))
                                          ],
                                          title: Text(
                                            'Konfirmasi Penyetujuan Limbah',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                jadwal.namaUsaha,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineMedium,
                                              ),
                                              const SizedBox(
                                                  height: CustomSize.md),
                                              Text(jadwal.alamat,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium),
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
                                                            .titleMedium,
                                                        children: [
                                                          const TextSpan(
                                                              text: ' | '),
                                                          TextSpan(
                                                              text: jadwal
                                                                  .jumlahLimbah,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium)
                                                        ]),
                                                  ),
                                                  Text(jadwal.jenisLimbah,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.apply(
                                                              color: AppColors
                                                                  .error))
                                                ],
                                              ),
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
                                                            .titleMedium,
                                                        children: [
                                                          const TextSpan(
                                                              text: ' | '),
                                                          TextSpan(
                                                              text: DateFormat(
                                                                      'dd MMM yyyy')
                                                                  .format(jadwal
                                                                      .date!),
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium)
                                                        ]),
                                                  ),
                                                  Text(jadwal.telp,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.apply(
                                                              color: AppColors
                                                                  .darkGrey))
                                                ],
                                              ),
                                              const SizedBox(
                                                  height: CustomSize.sm),
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  jadwal.status == '0'
                                                      ? 'Meminta Persetujuan'
                                                      : 'Sudah Disetujui',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: jadwal
                                                                      .status ==
                                                                  '0'
                                                              ? AppColors.error
                                                              : Colors.green),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                  : null;
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              padding: const EdgeInsets.all(CustomSize.sm),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.black),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    jadwal.namaUsaha,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                  ),
                                  const SizedBox(height: CustomSize.md),
                                  Text(jadwal.alamat,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                            text: 'Jumlah Limbah',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                            children: [
                                              const TextSpan(text: ' | '),
                                              TextSpan(
                                                  text: jadwal.jumlahLimbah,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium)
                                            ]),
                                      ),
                                      Text(jadwal.jenisLimbah,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.apply(color: AppColors.error))
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // RichText(
                                      //   text: TextSpan(
                                      //       text: 'Tgl',
                                      //       style: Theme.of(context)
                                      //           .textTheme
                                      //           .titleMedium,
                                      //       children: [
                                      //         const TextSpan(text: ' | '),
                                      //         TextSpan(
                                      //             text:
                                      //                 DateFormat('dd MMM yyyy')
                                      //                     .format(jadwal.date!),
                                      //             style: Theme.of(context)
                                      //                 .textTheme
                                      //                 .bodyMedium)
                                      //       ]),
                                      // ),
                                      Text(jadwal.telp,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.apply(
                                                  color: AppColors.darkGrey))
                                    ],
                                  ),
                                  const SizedBox(height: CustomSize.sm),
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
                                                  : Colors.green),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                          // return ListTile(
                          //     title: Text(jadwal.namaUsaha),
                          //     subtitle: Text(jadwal.alamat),
                          //     trailing: Text(jadwal.status == '0'
                          //         ? 'Belum Disetujui'
                          //         : 'Sudah Disetujui'));
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

enum _Tab { suplier, driver }
