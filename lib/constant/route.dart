import 'package:get/get.dart';

import '../screens/driver/rootpage_driver.dart';
import '../screens/login.dart';
import '../screens/manajer/rootpage_manajer.dart';

class AppRoutes {
  static List<GetPage> routes() => [
        GetPage(
          name: '/',
          page: () => const LoginScreen(),
        ),
        GetPage(
          name: '/rootpage-manajer',
          page: () => const RootpageManajer(),
        ),
        GetPage(
          name: '/rootpage-driver',
          page: () => const RootpageDriver(),
        )
      ];
}
