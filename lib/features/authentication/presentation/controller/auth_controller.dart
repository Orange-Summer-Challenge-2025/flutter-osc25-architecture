import 'package:get/get.dart';
import 'package:osc25/features/authentication/domain/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;

  AuthController(this._authRepository);

  var email = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs;

  Future<void> login() async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    isLoading.value = true;

    final result = await _authRepository.login(email.value, password.value);
    
    isLoading.value = false;

    result.fold(
      (failure) => Get.snackbar('Login Failed', failure.message),
      (success) => Get.snackbar('Login Successful', success.id),
    );
  }
}
