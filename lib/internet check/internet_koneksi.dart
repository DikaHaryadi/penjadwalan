import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'internet_checker_controller.dart';

class InternetKoneksi extends StatelessWidget {
  const InternetKoneksi({super.key});

  @override
  Widget build(BuildContext context) {
    final InternetCheckerController internetCheckerController =
        Get.put(InternetCheckerController());
    return Scaffold(
      body: Center(
        child: Obx(() => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  internetCheckerController.isConnectedToInternet.value
                      ? Icons.wifi
                      : Icons.wifi_off,
                  size: 50,
                  color: internetCheckerController.isConnectedToInternet.value
                      ? Colors.green
                      : Colors.red,
                ),
                Text(internetCheckerController.isConnectedToInternet.value
                    ? 'You are connected to the internet'
                    : "You are not connected to the internet")
              ],
            )),
      ),
    );
  }
}
