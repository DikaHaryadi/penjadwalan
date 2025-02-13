import 'package:example/screens/admin/controllers/kategori_barang_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MasterKategoriBarang extends StatelessWidget {
  const MasterKategoriBarang({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(KategoriBarangController());
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Master Kategori Barang',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Kategori Barang'),
                        content: Form(
                          key: controller.formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: controller.jenisLimbah,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    label: Text(
                                  'Jenis Limbah',
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                )),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Jenis limbah is required';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 8.0),
                              TextFormField(
                                controller: controller.hargaLimbah,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    label: Text(
                                  'Harga Limbah',
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                )),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Harga limbah is required';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 8.0),
                              TextFormField(
                                controller: controller.satuanLimbah,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    label: Text(
                                  'Satuan Limbah',
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                )),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Satuan limbah is required';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Batalkan')),
                          TextButton(
                              onPressed: () {
                                controller.createMasterBarang();
                              },
                              child: Text('Tambah')),
                        ],
                      );
                    },
                  );
                },
                child: Text('Tambah'))
          ],
        ),
        body: Obx(() {
          if (controller.userList.isEmpty) {
            return const Center(
              child: Text(
                'Tidak ada data',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ListView.builder(
                itemCount: controller.userList.length,
                itemBuilder: (context, index) {
                  final barang = controller.userList[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          barang.jenisLimbah,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                            'Harga : ${barang.hargaLimbah} /${barang.satuanLimbah}')
                      ],
                    ),
                  );
                }),
          );
        }));
  }
}
