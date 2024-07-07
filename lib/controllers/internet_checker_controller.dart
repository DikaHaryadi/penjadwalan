import 'dart:async';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetController extends GetxController {
  var isConnectedToInternet = false.obs;

  StreamSubscription? _streamSubscription;

  @override
  void onInit() {
    _streamSubscription = InternetConnection().onStatusChange.listen((event) {
      switch (event) {
        case InternetStatus.connected:
          isConnectedToInternet.value = true;
          break;
        case InternetStatus.disconnected:
        default:
          isConnectedToInternet.value = false;
          break;
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    _streamSubscription?.cancel();
    super.onClose();
  }
}
