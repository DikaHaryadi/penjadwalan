import 'package:example/constant/storage_util.dart';
import 'package:flutter/material.dart';

class HomepageManajer extends StatelessWidget {
  const HomepageManajer({super.key});

  @override
  Widget build(BuildContext context) {
    final storageUtil = StorageUtil();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Welcome ${storageUtil.getName()}'),
        Text('Ini roles manajer'),
      ],
    );
  }
}
