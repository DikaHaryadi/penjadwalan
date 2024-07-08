import 'package:example/controllers/expandable_text_controller.dart';
import 'package:example/theme/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpandableTextWidget extends StatelessWidget {
  final String text;

  const ExpandableTextWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final expandableTextController = Get.put(ExpandableTextController(text));

    return Obx(() {
      return expandableTextController.secondHalf.isEmpty
          ? Text(
              expandableTextController.firstHalf,
              style: Theme.of(context).textTheme.bodyMedium,
            )
          : InkWell(
              onTap: () {
                expandableTextController.toggleTextVisibility();
              },
              child: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                    text: (expandableTextController.hiddenText.value
                        ? ('${expandableTextController.firstHalf}...')
                        : (expandableTextController.firstHalf +
                            expandableTextController.secondHalf)),
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: <TextSpan>[
                      TextSpan(
                          text: expandableTextController.hiddenText.value
                              ? 'Lihat selengkapnya'
                              : '',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.apply(color: AppColors.darkGrey),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              expandableTextController.toggleTextVisibility();
                            }),
                    ]),
              ),
            );
    });
  }
}
