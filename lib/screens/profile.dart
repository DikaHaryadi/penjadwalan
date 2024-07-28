import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/constant/custom_size.dart';
import 'package:example/constant/storage_util.dart';
import 'package:example/utils/curved_edges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import '../controllers/calendar_controller.dart';
import '../models/event_calendar.dart';
import '../theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storageUtil = StorageUtil();
    final tableController = Get.put(TableEventsController());

    return SafeArea(
      child: ListView(
        children: [
          ClipPath(
            clipper: TCustomCurvedEdges(),
            child: Container(
              color: Colors.blueAccent,
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: CustomSize.lg),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: CustomSize.lg, vertical: CustomSize.md),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: storageUtil.logout,
                        icon: const Icon(Iconsax.logout),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(70),
                      child: CachedNetworkImage(
                        width: CustomSize.profileImageSize,
                        height: CustomSize.profileImageSize,
                        imageUrl: storageUtil.getImage(),
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (_, __, ___) =>
                            const CircularProgressIndicator(),
                        errorWidget: (_, __, ___) => const Icon(Icons.error),
                      ),
                    ),
                    const SizedBox(height: CustomSize.spaceBtwItems),
                    Text(storageUtil.getName(),
                        style: Theme.of(context).textTheme.headlineMedium)
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: CustomSize.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Iconsax.direct),
                    SizedBox(width: CustomSize.sm),
                    Text('E-mail'),
                  ],
                ),
                const SizedBox(height: CustomSize.sm),
                Text(storageUtil.getEmail()),
                const SizedBox(height: CustomSize.spaceBtwSections),
                const Row(
                  children: [
                    Icon(Iconsax.direct),
                    SizedBox(width: CustomSize.sm),
                    Text('Nomer Telepon'),
                  ],
                ),
                const SizedBox(height: CustomSize.sm),
                Text(storageUtil.getTelp()),
                const SizedBox(height: CustomSize.spaceBtwSections),
                const Row(
                  children: [
                    Icon(Iconsax.direct),
                    SizedBox(width: CustomSize.sm),
                    Text('Roles'),
                  ],
                ),
                const SizedBox(height: CustomSize.sm),
                Text(
                  storageUtil.getRoles() == '0'
                      ? 'Manajer'
                      : storageUtil.getRoles() == '1'
                          ? 'Driver'
                          : 'Anda belum memasukkan roles di Firebase',
                ),
                Text('Laporan Barang',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: CustomSize.spaceBtwItems),
                FutureBuilder<List<Event>>(
                  future: tableController.getEventsByStatus('2'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No data available'));
                    } else {
                      List<Event>? jadwalList = snapshot.data;
                      return ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: jadwalList!.length,
                        itemBuilder: (context, index) {
                          var jadwal = jadwalList[index];
                          return Container(
                            padding: const EdgeInsets.all(CustomSize.sm),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.black),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  jadwal.namaUsaha,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                GestureDetector(
                                  onTap: () => _generatePdf(jadwal, context),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Buka laporan',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.apply(color: AppColors.primary),
                                      ),
                                      const SizedBox(width: 5.0),
                                      const Icon(
                                        Iconsax.document_download,
                                        size: 15,
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: CustomSize.md),
                                Text(jadwal.alamat,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                          text: 'Jumlah Limbah',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                          children: [
                                            const TextSpan(text: ' | '),
                                            TextSpan(
                                                text: jadwal.jumlahLimbah,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium)
                                          ]),
                                    ),
                                    Text(jadwal.jenisLimbah,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.apply(color: AppColors.error))
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                          text: 'Tgl',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                          children: [
                                            const TextSpan(text: ' | '),
                                            TextSpan(
                                              text: jadwal.date.toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            )
                                          ]),
                                    ),
                                    Text(jadwal.telp,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.apply(color: AppColors.darkGrey))
                                  ],
                                ),
                                const SizedBox(height: CustomSize.sm),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    jadwal.status == '0'
                                        ? 'Meminta Persetujuan'
                                        : 'Sudah Disetujui',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: jadwal.status == '0'
                                                ? AppColors.error
                                                : Colors.green),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12.0),
                      );
                    }
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Loading..."),
              ],
            ),
          ),
        );
      },
    );
  }

  void _hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  Future<void> _generatePdf(Event event, BuildContext context) async {
    _showLoadingDialog(context); // Menampilkan loading dialog

    final pdf = pw.Document();

    final regularFont =
        await rootBundle.load("assets/fonts/Urbanist-Regular.ttf");
    final ttfRegular = pw.Font.ttf(regularFont);
    final boldFont = await rootBundle.load("assets/fonts/Urbanist-Bold.ttf");
    final ttfBold = pw.Font.ttf(boldFont);

    // load image from assets
    final ByteData imageData =
        await rootBundle.load('assets/images/ajj_logo.png');
    final Uint8List imageBytes = imageData.buffer.asUint8List();
    final image = pw.MemoryImage(imageBytes);

    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
                pw.Image(image, width: 50, height: 50),
                pw.SizedBox(width: 10),
                pw.Text('PT. ANDESTAN JADI JAYA',
                    style: pw.TextStyle(fontSize: 24, font: ttfBold)),
              ]),
              pw.Text(
                  'Alamat: Gedung IS Plaza, Lantai 8, Ruang 801, Jl. Pramuka Raya Kav. 150 Utan Kayu, Matraman - Jakarta Timur',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(font: ttfRegular)),
              pw.SizedBox(height: 20),
              pw.Text('MANIFES LIMBAH BAHAN BERBAHAYA DAN BERACUN',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(fontSize: 20, font: ttfBold)),
              pw.SizedBox(height: 10),
              pw.Text(
                  'Berikut adalah surat resmi yang dikeluarkan oleh PT. Andestan Jadi Jaya untuk mengajukan pengambilan limbah B3',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(font: ttfRegular)),
              pw.SizedBox(height: 20),
              _buildAlignedText('Nomor Manifes', event.id, ttfBold, ttfRegular),
              _buildAlignedText(
                  'Jenis Limbah', event.jenisLimbah, ttfBold, ttfRegular),
              _buildAlignedText(
                  'Pemilik Limbah', event.namaUsaha, ttfBold, ttfRegular),
              _buildAlignedText(
                  'Alamat Pemilik Limbah', event.alamat, ttfBold, ttfRegular),
              _buildAlignedText(
                  'Nomor Kendaraan', event.platNomer, ttfBold, ttfRegular),
              _buildAlignedText('Penerima', event.driver, ttfBold, ttfRegular),
              _buildAlignedText(
                  'Jumlah', event.jumlahLimbah, ttfBold, ttfRegular),
              _buildAlignedText(
                  'Tanggal', _formatDate(event.date), ttfBold, ttfRegular),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    children: [
                      pw.Text('Yang Menyerahkan:',
                          style: pw.TextStyle(font: ttfRegular)),
                      pw.SizedBox(height: 50),
                      pw.Text('[...............................]',
                          style: pw.TextStyle(font: ttfRegular)),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Text('Yang Menerima:',
                          style: pw.TextStyle(font: ttfRegular)),
                      pw.SizedBox(height: 50),
                      pw.Text('[...............................]',
                          style: pw.TextStyle(font: ttfRegular)),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Bullet(
                  text:
                      'Manifes ini merupakan dokumen resmi yang mencatat proses pengangkutan dan penerimaan limbah B3 dari pemilik limbah hingga penerima limbah.',
                  style: pw.TextStyle(font: ttfRegular)),
              pw.Bullet(
                  text:
                      'Pastikan untuk mengisi dan menandatangani manifes dengan benar sesuai dengan prosedur yang berlaku.',
                  style: pw.TextStyle(font: ttfRegular)),
            ],
          ),
        );
      },
    ));

    try {
      if (await Permission.storage.request().isGranted) {
        final downloadsDirectory = await getExternalStorageDirectories(
            type: StorageDirectory.downloads);
        if (downloadsDirectory == null || downloadsDirectory.isEmpty) {
          throw Exception('Could not find downloads directory');
        }
        final downloadPath = downloadsDirectory.first.path;
        final filePath = '$downloadPath/laporan_limbah.pdf';

        final file = File(filePath);
        await file.writeAsBytes(await pdf.save());
        _hideLoadingDialog(Get.context!); // Menyembunyikan loading dialog

        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(content: Text('PDF has been saved to $filePath')),
        );
        print('PDF has been saved to $filePath');
        await PdfHelper.openFile(file);
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(
              content: Text('Storage permission is required to save PDF')),
        );
        _hideLoadingDialog(Get.context!); // Menyembunyikan loading dialog
      }
    } catch (e) {
      _hideLoadingDialog(Get.context!); // Menyembunyikan loading dialog
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text('Error saving PDF: $e')),
      );
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '-';
    }
    return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
  }

  pw.Widget _buildAlignedText(
      String label, String value, pw.Font boldFont, pw.Font regularFont) {
    return pw.Row(
      children: [
        pw.Expanded(
          flex: 1,
          child:
              pw.Text(label, style: pw.TextStyle(fontSize: 16, font: boldFont)),
        ),
        pw.Text(' | ', style: pw.TextStyle(fontSize: 16, font: regularFont)),
        pw.Expanded(
          flex: 2,
          child: pw.Text(value,
              style: pw.TextStyle(fontSize: 16, font: regularFont)),
        ),
      ],
    );
  }
}

class PdfHelper {
  static Future<File> saveDocument({
    required String name,
    required pw.Document pdf,
  }) async {
    final directory = await getExternalStorageDirectory();
    final file = File('${directory!.path}/$name');

    return file.writeAsBytes(await pdf.save());
  }

  static Future<void> openFile(File file) async {
    final result = await OpenFile.open(file.path);
    print(result.message);
  }
}
