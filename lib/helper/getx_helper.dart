import 'package:get/get.dart';

T findOrPut<T extends GetxController>(T Function() creator) {
  return Get.isRegistered<T>() ? Get.find<T>() : Get.put<T>(creator());
}