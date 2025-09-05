import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app_theme.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  /// Reactive dark mode state
  RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Load theme from storage
    isDarkMode.value = _loadThemeFromBox();
    // Apply saved theme immediately
    Get.changeTheme(isDarkMode.value ? AppTheme.dark : AppTheme.light);
  }

  bool _loadThemeFromBox() => _box.read(_key) ?? false;

  void _saveThemeToBox(bool isDark) => _box.write(_key, isDark);

  /// Toggle theme and persist choice
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeTheme(isDarkMode.value ? AppTheme.dark : AppTheme.light);
    _saveThemeToBox(isDarkMode.value);
  }
}

/* class ThemeController extends GetxController {
  final box = GetStorage();

  RxBool isDarkMode = true.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = box.read('isDarkMode') ?? false;
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeTheme(isDarkMode.value ? AppTheme.dark : AppTheme.light);
    box.write('isDarkMode', isDarkMode.value);
  }}
 */
