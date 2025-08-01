import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/repository/calendar_repo.dart';
import 'package:example/models/event_calendar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../constant/storage_util.dart';

class TableEventsController extends GetxController {
  RxBool isLoading = false.obs;
  final CalendarRepository _calendarRepository = CalendarRepository();
  var selectedEvents = <Event>[].obs;
  var calendarFormat = CalendarFormat.month.obs;
  var rangeSelectionMode = RangeSelectionMode.toggledOff.obs;
  var focusedDay = DateTime.now().obs;
  var selectedDay = Rx<DateTime?>(DateTime.now());
  var rangeStart = Rx<DateTime?>(null);
  var rangeEnd = Rx<DateTime?>(null);
  var events = <Event>[].obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    _calendarRepository.getEvents().listen((eventList) {
      events.value = eventList;
// Ambil nama driver
      final driverName = StorageUtil().getName();

// Filter hanya event milik driver dan status != '3'
      final filteredDriverEvents = eventList
          .where((e) => e.driver == driverName && e.status != '3')
          .toList();

// Cari event yang sesuai dengan hari ini, kalau tidak ada ambil yang pertama
      final firstEventToday = filteredDriverEvents.firstWhere(
        (e) => isSameDay(e.date, DateTime.now()),
        orElse: () => filteredDriverEvents.isNotEmpty
            ? filteredDriverEvents.first
            : Event(
                alamat: '',
                driver: '',
                harga: '',
                jenisLimbah: '',
                jumlahLimbah: '',
                namaUsaha: '',
                platNomer: '',
                status: '',
                date: DateTime.now(),
                telp: '',
                waktu: '',
                penanggungJawab: '',
              ),
      );

// Update selected dan focused day
      selectedDay.value = firstEventToday.date!;
      focusedDay.value = firstEventToday.date!;
      selectedEvents.value = getEventsForDay(selectedDay.value!);
    });
  }

  List<Event> getEventsForDay(DateTime day) {
    final name = StorageUtil().getName();
    return events.where((event) {
      return isSameDay(event.date, day) &&
          event.driver == name &&
          event.status != '3'; // hanya status != 3
    }).toList();
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

  Future<List<Event>> getEventsByStatus(List<String> statuses) async {
    try {
      await Future.delayed(const Duration(seconds: 1)); // Simulasi delay

      return events.where((event) => statuses.contains(event.status)).toList();
    } catch (e) {
      throw Exception('Failed to fetch events: $e');
    }
  }

  Future<void> editStatusByManajer(String eventId, String status) async {
    try {
      if (status == '0') {
        final docRef = _firestore.collection('BuatJadwal').doc(eventId);
        await docRef.update({'Status': '1'});

        Navigator.of(Get.overlayContext!).pop();

        Get.snackbar(
          'Success',
          'Event status updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: const Icon(Icons.check, color: Colors.white),
        );
      } else {
        Get.snackbar(
          'Info',
          'Event status is already approved',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          icon: const Icon(Icons.info, color: Colors.white),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update event status: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
  }

  Future<void> updateStatusPengangkutan(
      String driverName, String statusPengangkutan) async {
    final firestore = FirebaseFirestore.instance;

    // Cari ID dokumen di koleksi MasterDriver berdasarkan Nama_Driver
    final querySnapshot = await firestore
        .collection('MasterDriver')
        .where('Nama_Driver', isEqualTo: driverName)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Ambil document ID pertama yang cocok
      final driverDocId = querySnapshot.docs.first.id;

      // Update Status_Pengangkutan menjadi '1'
      await firestore.collection('MasterDriver').doc(driverDocId).update({
        'Status_Pengangkutan': statusPengangkutan,
      });

      print('Status_Pengangkutan diperbarui untuk $driverName');
    } else {
      print('Driver dengan nama $driverName tidak ditemukan.');
    }
  }

  Future<void> editStatusByTanggal(
      DateTime tanggal, String status, String updateStatus) async {
    try {
      final eventsToUpdate = events
          .where((event) =>
              isSameDay(event.date, tanggal) && event.status == status)
          .toList();

      if (eventsToUpdate.isEmpty) {
        Get.snackbar(
          'Info',
          'No events found for the specified date and status',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          icon: const Icon(Icons.info, color: Colors.white),
        );
        return;
      }

      for (var event in eventsToUpdate) {
        final docRef = _firestore.collection('BuatJadwal').doc(event.id);
        await docRef
            .update({'Status': updateStatus}); // Ubah status menjadi '2'
        // 🔥 Update Status_Pengangkutan di MasterDriver
        if (updateStatus == '2') {
          await updateStatusPengangkutan(event.driver, '1');
        }
        if (updateStatus == '3') {
          await updateStatusPengangkutan(
              event.driver, '0'); // balik lagi driver bisa digunain
        }

        // Hapus dari list lokal setelah update
        // if (updateStatus == '3') events.removeWhere((e) => e.id == event.id);
      }

      // Update UI
      selectedEvents.value = getEventsForDay(selectedDay.value!);
      update();

      Get.snackbar(
        'Success',
        'Event statuses updated successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: const Icon(Icons.check, color: Colors.white),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update event statuses: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
      );
      print('INI ERROR YG TERJADI : $e');
    }
  }
}
