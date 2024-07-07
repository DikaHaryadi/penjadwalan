import 'package:example/constant/storage_util.dart';
import 'package:flutter/material.dart';

class HomepageDriver extends StatelessWidget {
  const HomepageDriver({super.key});

  @override
  Widget build(BuildContext context) {
    final storageUtil = StorageUtil();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Welcome: ${storageUtil.getName()}'),
        Text('Status: ${storageUtil.getRoles()}'),
        Text('ini homepage driver')
      ],
    );
  }
}
