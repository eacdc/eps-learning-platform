import 'package:get/get.dart';

class DashboardController extends GetxController {
  RxInt selectedIndex = 0.obs;
  var  isListStyle = false.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  
  void changeListStyle(bool listStyle) {
    isListStyle.value = listStyle;
  }
}
