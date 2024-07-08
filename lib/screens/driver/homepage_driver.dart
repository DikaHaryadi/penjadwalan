import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/constant/custom_size.dart';
import 'package:example/constant/storage_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../controllers/calendar_controller.dart';
import '../../utils/event_calendar.dart';

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
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () =>
                            print('${controller.selectedEvents[index]}'),
                        title: Text('${controller.selectedEvents[index]}'),
                      ),
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }
}
