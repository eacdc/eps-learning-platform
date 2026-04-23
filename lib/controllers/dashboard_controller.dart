import 'package:get/get.dart';

class DashboardController extends GetxController {
  RxInt selectedIndex = 0.obs;
  var isListStyle = false.obs;

  /// true = user tapped "Learn" (show only Learn in chapter sheet), false = "Quiz" (show only Start Quiz)
  RxBool isLearnMode = false.obs;

  /// Center "Classroom" FAB expanded to show Learn / Quiz options
  RxBool isClassroomExpanded = false.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  void setCenterMode(bool isLearn) {
    isLearnMode.value = isLearn;
  }

  void toggleClassroomExpanded() {
    isClassroomExpanded.value = !isClassroomExpanded.value;
  }

  void collapseClassroom() {
    isClassroomExpanded.value = false;
  }

  void changeListStyle(bool listStyle) {
    isListStyle.value = listStyle;
  }
}
