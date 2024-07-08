import 'package:example/utils/event_calendar.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class TableEventsController extends GetxController {
  var selectedEvents = <Event>[].obs;
  var calendarFormat = CalendarFormat.month.obs;
  var rangeSelectionMode = RangeSelectionMode.toggledOff.obs;
  var focusedDay = DateTime.now().obs;
  var selectedDay = Rx<DateTime?>(DateTime.now());
  var rangeStart = Rx<DateTime?>(null);
  var rangeEnd = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    selectedEvents.value = getEventsForDay(selectedDay.value!);
  }

  List<Event> getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);
    return [
      for (final d in days) ...getEventsForDay(d),
    ];
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(this.selectedDay.value, selectedDay)) {
      this.selectedDay.value = selectedDay;
      this.focusedDay.value = focusedDay;
      rangeStart.value = null; // Important to clean those
      rangeEnd.value = null;
      rangeSelectionMode.value = RangeSelectionMode.toggledOff;

      selectedEvents.value = getEventsForDay(selectedDay);
    }
  }

  void onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    selectedDay.value = null;
    this.focusedDay.value = focusedDay;
    rangeStart.value = start;
    rangeEnd.value = end;
    rangeSelectionMode.value = RangeSelectionMode.toggledOn;

    if (start != null && end != null) {
      selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      selectedEvents.value = getEventsForDay(start);
    } else if (end != null) {
      selectedEvents.value = getEventsForDay(end);
    }
  }
}
