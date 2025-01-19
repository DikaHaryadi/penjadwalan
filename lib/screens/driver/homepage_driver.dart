import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/constant/custom_size.dart';
import 'package:example/constant/storage_util.dart';
import 'package:example/models/event_calendar.dart';
import 'package:example/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../controllers/calendar_controller.dart';

class HomepageDriver extends StatelessWidget {
  const HomepageDriver({super.key});

  @override
  Widget build(BuildContext context) {
    final storageUtil = StorageUtil();
    final controller = Get.put(TableEventsController());

    return SafeArea(
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
                )
              ],
            ),
          ),
          Obx(() {
            return TableCalendar<Event>(
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
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                todayDecoration: BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.indigo,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigo.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                todayTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                selectedTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                weekendTextStyle: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w500,
                ),
                defaultTextStyle: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              headerStyle: HeaderStyle(
                titleTextStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                formatButtonTextStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                formatButtonDecoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                leftChevronIcon: const Icon(
                  Icons.chevron_left,
                  color: Colors.black,
                ),
                rightChevronIcon: const Icon(
                  Icons.chevron_right,
                  color: Colors.black,
                ),
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
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isNotEmpty) {
                    return Positioned(
                      right: 1,
                      bottom: 1,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${events.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            );
          }),
          const SizedBox(height: 8.0),
          Obx(() => controller.selectedEvents.isEmpty
              ? Center(
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
                )
              : ListView.builder(
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
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      title: Text(
                                        'Detail Jadwal',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      content: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                              16.0), // Padding global untuk seluruh tampilan
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Nama Usaha dan Alamat
                                              ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                title: Text(
                                                  events.namaUsaha,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium,
                                                ),
                                                subtitle: Text(events.alamat),
                                                leading: const Icon(
                                                  Icons.business,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                              const SizedBox(height: 16.0),
                                              // Informasi Kontak
                                              const Divider(thickness: 1.5),
                                              const SizedBox(height: 8.0),
                                              ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                leading: const Icon(
                                                    Iconsax.mobile,
                                                    color: AppColors.primary),
                                                title: Text(
                                                  'Nomor Telepon',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                                subtitle: Text(
                                                  events.telp,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                ),
                                              ),
                                              ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                leading: const Icon(
                                                    Iconsax.timer,
                                                    color: AppColors.primary),
                                                title: Text(
                                                  'Waktu',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                                subtitle: Text(
                                                  events.waktu,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                ),
                                              ),
                                              const SizedBox(height: 16.0),
                                              // Detail Limbah
                                              const Divider(thickness: 1.5),
                                              const SizedBox(height: 8.0),
                                              ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                leading: const Icon(
                                                    Iconsax.receipt_item,
                                                    color: AppColors.primary),
                                                title: Text(
                                                  'Jenis Limbah',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                                subtitle:
                                                    Text(events.jenisLimbah),
                                              ),
                                              ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                leading: const Icon(
                                                    Iconsax.graph,
                                                    color: AppColors.primary),
                                                title: Text(
                                                  'Jumlah Limbah',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                                subtitle: Text(
                                                    '${events.jumlahLimbah} drum'),
                                              ),
                                              const SizedBox(height: 16.0),
                                              // Informasi Driver
                                              const Divider(thickness: 1.5),
                                              const SizedBox(height: 8.0),
                                              ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                title: Text(
                                                  'Driver',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                                subtitle: Text(events.driver),
                                              ),
                                              ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                title: Text(
                                                  'Plat Nomor',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                                subtitle:
                                                    Text(events.platNomer),
                                              ),
                                              const SizedBox(height: 16.0),
                                              // Status
                                              const Divider(thickness: 1.5),
                                              const SizedBox(height: 8.0),
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12.0,
                                                      vertical: 8.0),
                                                  decoration: BoxDecoration(
                                                    color: (events.status ==
                                                                '0' ||
                                                            events.status ==
                                                                '1')
                                                        ? AppColors.error
                                                            .withOpacity(0.1)
                                                        : Colors.green
                                                            .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        events.status == '0'
                                                            ? Icons
                                                                .error_outline
                                                            : events.status ==
                                                                    '1'
                                                                ? Icons
                                                                    .local_shipping_outlined
                                                                : Icons
                                                                    .check_circle_outline,
                                                        color: (events.status ==
                                                                    '0' ||
                                                                events.status ==
                                                                    '1')
                                                            ? AppColors.error
                                                            : Colors.green,
                                                        size: 18.0,
                                                      ),
                                                      const SizedBox(
                                                          width: 8.0),
                                                      Text(
                                                        events.status == '0'
                                                            ? 'Belum Disetujui Manajer'
                                                            : events.status ==
                                                                    '1'
                                                                ? 'Belum Diangkut'
                                                                : 'Telah Diangkut',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge
                                                            ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: (events.status ==
                                                                          '0' ||
                                                                      events.status ==
                                                                          '1')
                                                                  ? AppColors
                                                                      .error
                                                                  : Colors
                                                                      .green,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Get.back(),
                                          child: const Text(
                                            'Batalkan',
                                            style: TextStyle(
                                                color: AppColors.error),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            await controller
                                                .editStatusByTanggal(
                                              events.date!,
                                              events.status,
                                            );
                                            Navigator.of(Get.overlayContext!)
                                                .pop();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors
                                                .primary, // Warna utama tombol
                                            elevation:
                                                4, // Tinggi bayangan tombol
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  12.0), // Sudut melengkung tombol
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 24.0,
                                              vertical: 16.0,
                                            ), // Padding dalam tombol
                                          ).copyWith(
                                            shadowColor: WidgetStateProperty
                                                .resolveWith<Color?>(
                                              (states) => states.contains(
                                                      WidgetState.hovered)
                                                  ? Colors.blueGrey
                                                  : AppColors.primary
                                                      .withOpacity(0.5),
                                            ),
                                            overlayColor:
                                                WidgetStateProperty.all(
                                              AppColors.primary.withOpacity(
                                                  0.1), // Efek klik (ripple)
                                            ),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.check_circle,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              SizedBox(width: 8.0),
                                              Text(
                                                'Konfirmasi',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                )
                              : null;
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical:
                                8.0, // Increased vertical margin for better separation
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: CustomSize.sm,
                            vertical:
                                CustomSize.sm, // Adjusted padding for balance
                          ),
                          decoration: BoxDecoration(
                            color: Colors
                                .white, // Optional: adding a background color
                            border: Border.all(
                                color: Colors.grey
                                    .shade300), // Lighter border color for subtleness
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(
                                    0.1), // Soft shadow for subtle depth
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors
                                            .black87, // Ensuring readability
                                      ),
                                ),
                              ),
                              Text(
                                events.alamat,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.apply(
                                      color: Colors.grey
                                          .shade700, // Slightly lighter for better contrast
                                    ),
                              ),
                              const SizedBox(height: CustomSize.sm),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Iconsax.receipt_item,
                                          size: 16),
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(width: CustomSize.sm),
                                  Text(events.platNomer),
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
                                            : Colors.green,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ));
                  },
                )),
        ],
      ),
    );
  }

  Widget _buildEventsMarker(DateTime date, int eventCount) {
    return Container(
      width: 16.0, // Set the width
      height: 16.0, // Set the height
      decoration: const BoxDecoration(
        color: Colors.blue, // Customize color based on your requirements
        shape: BoxShape.circle, // Ensures the container is circular
      ),
      child: Center(
        child: Text(
          eventCount.toString(), // Display the event count
          style: const TextStyle(
            color: Colors.white, // Text color inside the circle
            fontSize: 10.0, // Adjusted font size for better fit
            fontWeight: FontWeight.bold, // Optional: make the text bold
          ),
        ),
      ),
    );
  }
}
