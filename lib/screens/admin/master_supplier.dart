import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../constant/custom_size.dart';
import '../../theme/app_colors.dart';
import 'controllers/master_supplier_controller.dart';
import 'source/supplier_source.dart';

class MasterSupplier extends StatelessWidget {
  const MasterSupplier({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MasterSupplierController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Master Supplier',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
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
              source: SupplierSource(
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
                    columnName: 'Alamat',
                    label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'Alamat',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ))),
                GridColumn(
                    columnName: 'Email',
                    label: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.lightBlue.shade100,
                        ),
                        child: Text(
                          'Email',
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
