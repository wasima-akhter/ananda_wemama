import 'package:get/get.dart';

import '../local/app_storage.dart';
import 'color/color_model.dart';
import 'color/colors.dart';

class ThemeController extends GetxController {
  /// Reactive value to track switch (optional UI)
  bool _isSwitched = false;
  bool get isSwitched => _isSwitched;

  void toggleSwitch() {
    _isSwitched = !_isSwitched;
    update(); // update UI if using GetBuilder
  }

  /// Determines whether dark mode is enabled (based on AppStorage)
  bool get isDarkMode => AppStorage.to.getIsDarkMode;

  /// Returns the currently active color theme
  ColorModel get selectedColorTheme => isDarkMode ? darkColors : lightColors;

  /// Toggle theme and persist preference
  void toggleTheme(bool isDark) {
    AppStorage.to.setTheme(isDark);
    update(); // notify listeners
  }

  /// Manually trigger listeners (optional)
  void refresh() {
    update();
  }
}
