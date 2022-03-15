import 'package:get/get.dart';

import 'package:myfirebase/app/modules/home/bindings/home_binding.dart';
import 'package:myfirebase/app/modules/home/views/home_view.dart';
import 'package:myfirebase/app/modules/login/bindings/login_binding.dart';
import 'package:myfirebase/app/modules/login/views/login_view.dart';
import 'package:myfirebase/app/modules/register/bindings/register_binding.dart';
import 'package:myfirebase/app/modules/register/views/register_view.dart';
import 'package:myfirebase/app/modules/reset_password/bindings/reset_password_binding.dart';
import 'package:myfirebase/app/modules/reset_password/views/reset_password_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD,
      page: () => ResetPasswordView(),
      binding: ResetPasswordBinding(),
    ),
  ];
}
