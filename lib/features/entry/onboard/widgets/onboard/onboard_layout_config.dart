import '../../../../../app/helper_widgets_export.dart';

class OnboardLayoutConfig {
  const OnboardLayoutConfig({required this.width, required this.height});

  final double width;
  final double height;

  bool get isTablet => width >= 600;
  bool get isLarge => width >= 900;

  double get logoScale => isTablet ? 1.3 : 1.0;
  double get titleFs => isTablet ? 22.0 : 16.0;
  double get subFs => isTablet ? 15.0 : 12.0;
  double get loginFs => isTablet ? 14.0 : 12.0;
  double get btnW => !isTablet ? S.w * 0.5 : S.w * 0.6;
  double get textHMargin => isTablet ? 80.0 : 40.0;
}
