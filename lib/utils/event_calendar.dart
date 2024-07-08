class Event {
  final String title;
  const Event(this.title);

  @override
  String toString() => title;
}

final Map<DateTime, List<Event>> kEvents = {
  DateTime(2023, 7, 7): [const Event('Event 1'), const Event('Event 2')],
  DateTime(2023, 7, 8): [const Event('Event 3')],
};

List<DateTime> daysInRange(DateTime start, DateTime end) {
  final days = <DateTime>[];
  for (int i = 0; i <= end.difference(start).inDays; i++) {
    days.add(DateTime(start.year, start.month, start.day + i));
  }
  return days;
}

final kFirstDay = DateTime.utc(2010, 10, 16);
final kLastDay = DateTime.utc(2030, 3, 14);
