import 'package:example/screens/supplier/create_pengangkutan.dart';
import 'package:example/splash_screen.dart';
import 'package:get/get.dart';

import '../screens/admin/add_user.dart';
import '../screens/admin/master_barang.dart';
import '../screens/admin/rootpage_admin.dart';
import '../screens/driver/rootpage_driver.dart';
import '../screens/manajer/rootpage_manajer.dart';
import '../screens/supplier/home_supplier.dart';

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
          name: '/rootpage-supplier',
          page: () => const HomeSupplier(),
        ),
        GetPage(
          name: '/add-user',
          page: () => const AddUser(),
        ),
        GetPage(
          name: '/add-jadwal-masuk',
          page: () => const CreatePengangkutan(),
        ),
        GetPage(
          name: '/master-barang',
          page: () => const MasterBarang(),
        ),
      ];
}
