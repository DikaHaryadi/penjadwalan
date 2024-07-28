import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/constant/custom_size.dart';
import 'package:example/constant/storage_util.dart';
import 'package:example/models/event_calendar.dart';
import 'package:example/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../controllers/calendar_controller.dart';

class HomepageDriver extends StatelessWidget {
  const HomepageDriver({super.key});

  @override
  Widget build(BuildContext context) {
    final storageUtil = StorageUtil();
    final controller = Get.put(TableEventsController());

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
                )
              ],
            ),
          ),
          Obx(() => TableCalendar<Event>(
                locale: 'id_ID',
                firstDay: kFirstDay,
                lastDay: kLastDay,
                focusedDay: controller.focusedDay.value,
                selectedDayPredicate: (day) =>
                    isSameDay(controller.selectedDay.value, day),
                rangeStartDay: controller.rangeStart.value,
                rangeEndDay: controller.rangeEnd.value,
                calendarFormat: controller.calendarFormat.value,
                rangeSelectionMode: controller.rangeSelectionMode.value,
                eventLoader: controller.getEventsForDay,
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: const CalendarStyle(
                  outsideDaysVisible: false,
                ),
                onDaySelected: controller.onDaySelected,
                onRangeSelected: controller.onRangeSelected,
                onFormatChanged: (format) {
                  if (controller.calendarFormat.value != format) {
                    controller.calendarFormat.value = format;
                  }
                },
                onPageChanged: (focusedDay) {
                  controller.focusedDay.value = focusedDay;
                },
              )),
          const SizedBox(height: 8.0),
          Expanded(
            child: Obx(() => ListView.builder(
                  itemCount: controller.selectedEvents.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final events = controller.selectedEvents[index];
                    return GestureDetector(
                      onTap: () {
                        events.status == '1'
                            ? showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return AlertDialog(
                                      actions: [
                                        TextButton(
                                          onPressed: () => Get.back(),
                                          child: const Text('Batalkan'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await controller
                                                .editStatusByTanggal(
                                                    events.date!,
                                                    events.status);
                                            Navigator.of(Get.overlayContext!)
                                                .pop();
                                          },
                                          child: const Text('Konfirmasi'),
                                        )
                                      ],
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            title: Text(
                                              events.namaUsaha,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall,
                                            ),
                                          ),
                                          Text(events.alamat),
                                          const SizedBox(height: CustomSize.sm),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(Iconsax.mobile),
                                                  const SizedBox(
                                                      width: CustomSize.sm),
                                                  Text(events.telp)
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(Iconsax.timer),
                                                  const SizedBox(
                                                      width: CustomSize.sm),
                                                  Text(events.waktu)
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: CustomSize.sm),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                      Iconsax.receipt_item),
                                                  const SizedBox(
                                                      width: CustomSize.sm),
                                                  Text(events.jenisLimbah)
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(Iconsax.graph),
                                                  const SizedBox(
                                                      width: CustomSize.sm),
                                                  Text(events.jumlahLimbah)
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: CustomSize.sm),
                                          Row(
                                            children: [
                                              Text(
                                                'Driver',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge,
                                              ),
                                              const SizedBox(
                                                  width: CustomSize.sm),
                                              Text(events.driver)
                                            ],
                                          ),
                                          const SizedBox(height: CustomSize.sm),
                                          Row(
                                            children: [
                                              Text(
                                                'Plat Nomor',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge,
                                              ),
                                              const SizedBox(
                                                  width: CustomSize.sm),
                                              Text(events.platNomer)
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
                                                      : 'Telah Diangkut',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: (events.status ==
                                                                  '0' ||
                                                              events.status ==
                                                                  '1')
                                                          ? AppColors.error
                                                          : Colors.green),
                                            ),
                                          )
                                        ],
                                      ));
                                },
                              )
                            : null;
                      },
                      child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 4.0,
                          ),
                          padding: const EdgeInsets.only(
                              left: CustomSize.sm,
                              right: CustomSize.sm,
                              bottom: CustomSize.sm),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  events.namaUsaha,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                              ),
                              Text(events.alamat),
                              const SizedBox(height: CustomSize.sm),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Iconsax.mobile),
                                      const SizedBox(width: CustomSize.sm),
                                      Text(events.telp)
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Iconsax.timer),
                                      const SizedBox(width: CustomSize.sm),
                                      Text(events.waktu)
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: CustomSize.sm),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Iconsax.receipt_item),
                                      const SizedBox(width: CustomSize.sm),
                                      Text(events.jenisLimbah)
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Iconsax.graph),
                                      const SizedBox(width: CustomSize.sm),
                                      Text(events.jumlahLimbah)
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: CustomSize.sm),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Driver',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      const SizedBox(width: CustomSize.sm),
                                      Text(events.driver)
                                    ],
                                  ),
                                  const SizedBox(width: CustomSize.sm),
                                  Row(
                                    children: [
                                      Text(
                                        'Plat Nomor',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      const SizedBox(width: CustomSize.sm),
                                      Text(events.platNomer)
                                    ],
                                  ),
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
                                          : 'Telah Diangkut',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: (events.status == '0' ||
                                                  events.status == '1')
                                              ? AppColors.error
                                              : Colors.green),
                                ),
                              )
                            ],
                          )),
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }
}
