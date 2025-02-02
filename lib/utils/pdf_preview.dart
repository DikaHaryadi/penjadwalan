import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfPreviewScreen extends StatefulWidget {
  final Uint8List pdf;
  final String fileName;

  const PdfPreviewScreen({
    super.key,
    required this.pdf,
    required this.fileName,
  });

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Preview'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _downloadPDF(),
          )
        ],
      ),
      body: Column(
        children: [
          // Tampilkan PDF berdasarkan pilihan
          Expanded(
            child: SfPdfViewer.memory(
              widget.pdf,
            ),
          ),
          // const SizedBox(height: 10),
          // // Tombol pilihan PDF
          // Container(
          //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //     child: Stack(
          //       children: [
          //         Align(
          //           alignment: Alignment.topCenter,
          //           child: Column(
          //             children: [
          //               InkWell(
          //                 onTap: toggleExpansion,
          //                 child: Icon(
          //                   _isExpanded ? Icons.expand_more : Icons.expand_less,
          //                   color: AppColors.black,
          //                 ),
          //               ),
          //               if (!_isExpanded)
          //                 Text('Pilih Format',
          //                     style: Theme.of(context).textTheme.labelMedium)
          //             ],
          //           ),
          //         ),
          //         const SizedBox(height: CustomSize.sm),
          //         SizeTransition(
          //           sizeFactor: animation,
          //           child: Align(
          //             alignment: Alignment.center,
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               children: [
          //                 // Tombol untuk PDF dengan kop surat
          //                 _buildOptionButton(
          //                   title: "Dengan Kop Surat",
          //                   isSelected: isWithHeaderSelected,
          //                   pdfBytes: widget.pdf,
          //                   onTap: () {
          //                     setState(() {
          //                       isWithHeaderSelected = true;
          //                     });
          //                   },
          //                 ),
          //                 // Tombol untuk PDF tanpa kop surat
          //                 _buildOptionButton(
          //                   title: "Tanpa Kop Surat",
          //                   isSelected: !isWithHeaderSelected,
          //                   pdfBytes: widget.pdfBytesWithoutHeader,
          //                   onTap: () {
          //                     setState(() {
          //                       isWithHeaderSelected = false;
          //                     });
          //                   },
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ],
          //     )),
          // const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Widget _buildOptionButton({
  //   required String title,
  //   required bool isSelected,
  //   required Uint8List pdfBytes,
  //   required VoidCallback onTap,
  // }) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Container(
  //       width: 150,
  //       height: 200, // Ukuran untuk thumbnail PDF
  //       decoration: BoxDecoration(
  //         border: isSelected
  //             ? Border.all(color: Colors.blue, width: 3) // Border jika dipilih
  //             : Border.all(color: Colors.transparent, width: 3),
  //       ),
  //       child: Stack(
  //         children: [
  //           // Tampilkan thumbnail PDF
  //           Positioned.fill(
  //             child: SfPdfViewer.memory(
  //               pdfBytes,
  //               canShowPaginationDialog: false,
  //               canShowScrollHead: false,
  //               enableDoubleTapZooming: false,
  //             ),
  //           ),
  //           // Label di bawah thumbnail
  //           isSelected
  //               ? const SizedBox.shrink()
  //               : Align(
  //                   alignment: Alignment.bottomCenter,
  //                   child: Container(
  //                     width: double.infinity,
  //                     color: Colors.black.withOpacity(0.5),
  //                     padding: const EdgeInsets.all(5),
  //                     child: Text(
  //                       title,
  //                       style:
  //                           const TextStyle(color: Colors.white, fontSize: 10),
  //                       textAlign: TextAlign.center,
  //                     ),
  //                   ),
  //                 ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Future<void> _downloadPDF() async {
    try {
      // Tentukan lokasi folder
      Directory downloadDir =
          Directory('/storage/emulated/0/Download/Laporan-Limbah');
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true); // Buat folder jika belum ada
      }

      // Pilih file name berdasarkan opsi yang dipilih
      final fileName = widget.fileName; // Tambahkan _no_kop

      // Simpan PDF ke dalam folder
      final file = File('${downloadDir.path}/$fileName');
      await file.writeAsBytes(
        widget.pdf,
      );

      // Tampilkan notifikasi keberhasilan
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset('assets/animations/success.json'),
                  const SizedBox(height: 16),
                  const Text(
                    "File berhasil diunduh. Periksa folder 'LaporanPDF' di folder 'Download'.",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text("Tutup"),
                    ),
                    TextButton(
                      onPressed: () {
                        // Ganti dengan lokasi file PDF yang sudah diunduh
                        OpenFile.open('${downloadDir.path}/$fileName');
                      },
                      child: const Text("Buka File"),
                    ),
                  ],
                )
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error saving PDF: $e');
    }
  }
}
