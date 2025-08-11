import 'package:get/get.dart';
import 'package:osc25/features/authentication/presentation/screens/login_screen.dart';
import 'package:osc25/features/splash/presentation/screen/splash_screen.dart';
import 'package:osc25/routing/routes.dart';

final routes = [
  GetPage(name: Routes.splash, page: () => const SplashScreen()),
  GetPage(name: Routes.login, page: () => const LoginScreen()),
];
