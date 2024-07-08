import 'package:get/get.dart';

class ExpandableTextController extends GetxController {
  final String text;
  late String firstHalf;
  late String secondHalf;
  var hiddenText = true.obs;
  double textHeight = Get.height / 3;

  ExpandableTextController(this.text) {
    if (text.length > textHeight) {
      firstHalf = text.substring(0, textHeight.toInt());
      secondHalf = text.substring(textHeight.toInt() + 1, text.length);
    } else {
      firstHalf = text;
      secondHalf = "";
    }
  }

  void toggleTextVisibility() {
    hiddenText.value = !hiddenText.value;
  }
}
