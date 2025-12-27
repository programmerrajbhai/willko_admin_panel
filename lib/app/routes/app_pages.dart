import 'package:get/get.dart';
import 'package:willko_admin_panel/app/modules/home/home_view.dart';
import 'app_routes.dart'; // এই লাইনটি Routes ক্লাস চিনতে সাহায্য করে
import '../modules/auth/login_view.dart';


class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
    ),
  ];
}