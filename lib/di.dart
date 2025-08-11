import 'package:get/get.dart';
import 'package:osc25/core/app_config.dart';
import 'package:osc25/core/data/local_storage.dart';
import 'package:osc25/core/data/network_client.dart';

class DI extends Bindings {
  @override
  void dependencies() {
    Get.put<AppConfig>(DevConfiguration());
    Get.put<LocalStorage>(LocalStorage());
    Get.put<NetworkClient>(NetworkClient(Get.find(), Get.find()));
  }
}
