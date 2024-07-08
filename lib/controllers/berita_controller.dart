import 'package:example/models/berita_model.dart';
import 'package:example/repo/berita_repo.dart';
import 'package:get/get.dart';

class BeritaController extends GetxController {
  final isLoading = Rx<bool>(false);
  final beritaRepo = Get.put(BeritaRepository());
  final RxList<BeritaModel> berita = <BeritaModel>[].obs;

  @override
  void onInit() {
    fetchBerita();
    super.onInit();
  }

  Future<void> fetchBerita() async {
    try {
      isLoading.value = true;
      final beritas = await beritaRepo.fetchBeritaContent();
      berita.assignAll(beritas);
    } catch (e) {
      berita.assignAll([]);
    } finally {
      isLoading.value = false;
    }
  }
}
