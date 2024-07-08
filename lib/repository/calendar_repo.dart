import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/models/event_calendar.dart';

class CalendarRepository {
  final CollectionReference<Map<String, dynamic>> _calendarCollection =
      FirebaseFirestore.instance.collection('BuatJadwal');

  Future<void> addEvent(Event event) async {
    await _calendarCollection.add(event.toMap());
  }

  Future<void> updateEvent(String id, Event event) async {
    await _calendarCollection.doc(id).update(event.toMap());
  }

  Future<void> deleteEvent(String id) async {
    await _calendarCollection.doc(id).delete();
  }

  Future<Event?> getEvent(String id) async {
    final document = await _calendarCollection.doc(id).get();
    return document.exists
        ? Event.fromMap(document.data()!, document.id)
        : null;
  }

  Stream<List<Event>> getEvents() {
    return _calendarCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Event.fromMap(doc.data(), doc.id))
          .toList();
    });
  }
}
