import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../models/event_calendar.dart';
import 'controllers/buatjadwal_controller.dart';

class EditJadwal extends StatefulWidget {
  const EditJadwal({super.key, required this.model});

  final Event model;

  @override
  State<EditJadwal> createState() => _EditJadwalState();
}

class _EditJadwalState extends State<EditJadwal> {
  late String id;
  late TextEditingController alamat;
  late TextEditingController driver;
  late TextEditingController harga;
  late TextEditingController jenisLimbah;
  late TextEditingController jumlahLimbah;
  late TextEditingController namaUsaha;
  late TextEditingController platNomer;
  late DateTime date;
  late TextEditingController telp;
  late TextEditingController waktu;

  @override
  void initState() {
    super.initState();
    id = widget.model.id!;
    alamat = TextEditingController(text: widget.model.alamat);
    driver = TextEditingController(text: widget.model.driver);
    harga = TextEditingController(text: widget.model.harga);
    jenisLimbah = TextEditingController(text: widget.model.jenisLimbah);
    jumlahLimbah = TextEditingController(text: widget.model.jumlahLimbah);
    namaUsaha = TextEditingController(text: widget.model.namaUsaha);
    platNomer = TextEditingController(text: widget.model.platNomer);
    date = widget.model.date!;
    telp = TextEditingController(text: widget.model.telp);
    waktu = TextEditingController(text: widget.model.waktu);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BuatjadwalController>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubah Jadwal'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
                onPressed: () {
                  controller.updateJadwal(
                      id,
                      alamat.text,
                      driver.text,
                      harga.text,
                      jenisLimbah.text,
                      jumlahLimbah.text,
                      platNomer.text,
                      namaUsaha.text,
                      date,
                      waktu.text,
                      telp.text);
                },
                child: Text('Update')),
          )
        ],
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          children: [
            Text('Tanggal'),
            TextFormField(
              keyboardType: TextInputType.none,
              readOnly: true,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      locale: const Locale("id", "ID"),
                      initialDate: date,
                      firstDate: DateTime(1850),
                      lastDate: DateTime(2040),
                    ).then((newSelectedDate) {
                      if (newSelectedDate != null) {
                        setState(() {
                          date = newSelectedDate;
                          print('Ini tanggal yang dipilih : $date');
                        });
                      }
                    });
                  },
                  icon: const Icon(Icons.calendar_today),
                ),
                hintText: DateFormat.yMMMMd('id_ID').format(date),
              ),
            ),
            Text('Alamat'),
            TextFormField(
              controller: alamat,
              maxLines: 10,
              minLines: 1,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Alamat is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 8.0),
            Text('Nama Driver'),
            TextFormField(
              controller: driver,
              keyboardType: TextInputType.name,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama driver is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 8.0),
            Text('Harga'),
            TextFormField(
              controller: harga,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Harga is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 8.0),
            Text('Jenis limbah'),
            TextFormField(
              controller: jenisLimbah,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Jenis limbah is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 8.0),
            Text('Jumlah limbah'),
            TextFormField(
              controller: jumlahLimbah,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Jumlah limbah is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 8.0),
            Text('Nama usaha'),
            TextFormField(
              controller: namaUsaha,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama usaha is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 8.0),
            Text('Plat nomor'),
            TextFormField(
              controller: platNomer,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Plat nomor is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 8.0),
            Text('No Telp'),
            TextFormField(
              controller: telp,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'No Telp is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 8.0),
            Text('Waktu'),
            TextFormField(
              controller: waktu,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Waktu is required';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
