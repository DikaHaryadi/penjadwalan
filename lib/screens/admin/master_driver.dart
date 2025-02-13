import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../constant/custom_size.dart';
import '../../models/user_model.dart';
import '../../theme/app_colors.dart';
import 'controllers/add_user_controller.dart';
import 'controllers/master_driver_controller.dart';
import 'source/driver_source.dart';

class MasterDriver extends StatelessWidget {
  const MasterDriver({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MasterDriverController());
    final driverUser = Get.put(AddUserController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Master Driver',
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nama driver'),
                            Obx(() {
                              String? selectedValue =
                                  controller.nameC.text.isNotEmpty
                                      ? controller.nameC.text
                                      : null;

                              return DropdownButtonFormField<String>(
                                value: selectedValue,
                                hint: Text('Pilih Nama Driver'),
                                items: driverUser.userList
                                    .where((driver) => driver.roles == '1')
                                    .map((user) {
                                  return DropdownMenuItem(
                                    value: user
                                        .name, // Sesuaikan dengan field yang ada di UserModel
                                    child: Text(user.name),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    // Cari data yang sesuai dengan nama yang dipilih
                                    final selectedUser =
                                        driverUser.userList.firstWhere(
                                      (user) => user.name == value,
                                      orElse: () => UserModel
                                          .empty(), // Pastikan ada fallback
                                    );

                                    // Perbarui nilai pada TextEditingController di MasterDriverController
                                    controller.nameC.text = selectedUser.name;
                                    controller.telpC.text =
                                        selectedUser.telp; // Pastikan field ada
                                  }
                                },
                              );
                            }),
                            const SizedBox(height: 8.0),
                            Text(
                              'Telp Driver',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            TextFormField(
                              controller: controller.telpC,
                              readOnly: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Telp Driver is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Plat Nomor',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            TextFormField(
                              controller: controller.platNomorC,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Plat Nomor is required';
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
                              controller.createNewUser();
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
      body: RefreshIndicator(onRefresh: () async {
        await controller.fetchUser();
      }, child: Obx(() {
        if (controller.isLoading.value && controller.userList.isEmpty) {
          return Center(
            child: Container(
              width: 50,
              height: 50,
              padding: const EdgeInsets.all(CustomSize.sm),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
          );
        } else {
          return SfDataGrid(
              source: DriverSource(
                model: controller.userList,
              ),
              frozenColumnsCount: 2,
              rowHeight: 65,
              columnWidthMode: controller.userList.isEmpty
                  ? ColumnWidthMode.fill
                  : ColumnWidthMode.auto,
              gridLinesVisibility: GridLinesVisibility.both,
              headerGridLinesVisibility: GridLinesVisibility.both,
              columns: [
                GridColumn(
                    width: 50,
                    columnName: 'No',
                    label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'No',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ))),
                GridColumn(
                    columnName: 'Nama',
                    label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'Nama',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ))),
                GridColumn(
                    columnName: 'Telp',
                    label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'Telp',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ))),
                GridColumn(
                    columnName: 'Plat Nomor',
                    label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'Plat Nomor',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ))),
                GridColumn(
                    columnName: 'Status',
                    columnWidthMode: ColumnWidthMode.fitByColumnName,
                    label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'Status',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ))),
              ]);
        }
      })),
    );
  }
}
