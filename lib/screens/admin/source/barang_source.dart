import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../constant/custom_size.dart';
import '../../../models/event_calendar.dart';

class BarangSource extends DataGridSource {
  final List<Event> model;
  int startIndex = 0;

  BarangSource({required this.model}) {
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

    // Create cells for the first 6 columns
    List<Widget> cells = [
      ...row.getCells().map<Widget>((e) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: CustomSize.md),
          child: Text(
            e.value.toString(),
            textAlign: TextAlign.justify,
            style: const TextStyle(fontSize: 14),
          ),
        );
      }),
    ];

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
          DataGridCell<String>(columnName: 'Perusahaan', value: '-'),
          DataGridCell<String>(columnName: 'Telp', value: '-'),
          DataGridCell<String>(columnName: 'Alamat', value: '-'),
          DataGridCell<String>(columnName: 'Jenis Limbah', value: '-'),
          DataGridCell<String>(columnName: 'Jumlah Limbah', value: '-'),
          DataGridCell<String>(columnName: 'Driver', value: '-'),
          DataGridCell<String>(columnName: 'Status', value: '-'),
        ]);
      },
    );
  }

  void _updateDataPager(List<Event> model, int startIndex) {
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
          DataGridCell<String>(columnName: 'Perusahaan', value: data.namaUsaha),
          DataGridCell<String>(columnName: 'Telp', value: data.telp),
          DataGridCell<String>(columnName: 'Alamat', value: data.alamat),
          DataGridCell<String>(
              columnName: 'Jenis Limbah', value: data.jenisLimbah),
          DataGridCell<String>(
              columnName: 'Jumlah Limbah', value: data.jumlahLimbah),
          DataGridCell<String>(columnName: 'Driver', value: data.driver),
          DataGridCell<String>(
              columnName: 'Status',
              value: data.status == '0'
                  ? 'Pending'
                  : data.status == '1'
                      ? 'Belum Diangkut'
                      : '✅'),
        ];

        return DataGridRow(cells: cells);
      }).toList();
    }

    notifyListeners();
  }
}
