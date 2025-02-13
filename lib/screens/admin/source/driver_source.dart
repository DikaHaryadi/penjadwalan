import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../constant/custom_size.dart';
import '../../../models/master_driver_model.dart';

class DriverSource extends DataGridSource {
  final List<MasterDriverModel> model;
  int startIndex = 0;

  DriverSource({required this.model}) {
    _updateDataPager(model, startIndex);
  }

  List<DataGridRow> data = [];
  int index = 0;

  @override
  List<DataGridRow> get rows => data;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    int rowIndex = data.indexOf(row);
    bool isEvenRow = rowIndex % 2 == 0;

    List<Widget> cells = row.getCells().map<Widget>((e) {
      if (e.columnName == 'Status' && e.value is Widget) {
        return Container(
          alignment: Alignment.center,
          child: e.value, // Menampilkan icon secara langsung
        );
      } else {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: CustomSize.md),
          child: Text(
            e.value.toString(),
            textAlign: TextAlign.justify,
            style: const TextStyle(fontSize: 14),
          ),
        );
      }
    }).toList();

    return DataGridRowAdapter(
      color: isEvenRow ? Colors.white : Colors.grey[200],
      cells: cells,
    );
  }

  List<DataGridRow> _generateEmptyRows(int count) {
    return List.generate(
      count,
      (index) {
        return const DataGridRow(cells: [
          DataGridCell<String>(columnName: 'No', value: '-'),
          DataGridCell<String>(columnName: 'Nama', value: '-'),
          DataGridCell<String>(columnName: 'Telp', value: '-'),
          DataGridCell<String>(columnName: 'Plat Nomor', value: '-'),
          DataGridCell<String>(columnName: 'Status', value: '-'),
        ]);
      },
    );
  }

  void _updateDataPager(List<MasterDriverModel> model, int startIndex) {
    this.startIndex = startIndex;
    index = startIndex;

    if (model.isEmpty) {
      data = _generateEmptyRows(1);
    } else {
      data = model.skip(startIndex).map<DataGridRow>((data) {
        index++;
        // Create row cells
        List<DataGridCell> cells = [
          DataGridCell<int>(columnName: 'No', value: index),
          DataGridCell<String>(columnName: 'Nama', value: data.namaDriver),
          DataGridCell<String>(columnName: 'Telp', value: data.telp),
          DataGridCell<String>(columnName: 'Plat Nomor', value: data.platNomor),
          DataGridCell<Widget>(
              columnName: 'Status',
              value: data.statusPengangkutan == '0' ||
                      data.statusPengangkutan == '1'
                  ? Icon(
                      Icons.close,
                      color: Colors.red,
                    )
                  : Icon(
                      Icons.check,
                      color: Colors.green,
                    )),
        ];

        return DataGridRow(cells: cells);
      }).toList();
    }

    notifyListeners();
  }
}
