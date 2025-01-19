import 'package:example/splash_screen.dart';
import 'package:get/get.dart';

import '../screens/admin/add_user.dart';
import '../screens/admin/rootpage_admin.dart';
import '../screens/driver/rootpage_driver.dart';
import '../screens/manajer/rootpage_manajer.dart';

class AppRoutes {
  static List<GetPage> routes() => [
        GetPage(
          name: '/',
          page: () => const SplashScreen(),
        ),
        GetPage(
          name: '/rootpage-manajer',
          page: () => const RootpageManajer(),
        ),
        GetPage(
          name: '/rootpage-driver',
          page: () => const RootpageDriver(),
        ),
        GetPage(
          name: '/rootpage-admin',
          page: () => const RootpageAdmin(),
        ),
        GetPage(
          name: '/add-user',
          page: () => const AddUser(),
        )
      ];
}
