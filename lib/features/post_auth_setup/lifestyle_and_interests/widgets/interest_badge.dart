import '../../../../app/helper_widgets_export.dart';
import '../../../../gen/assets.gen.dart';

class InterestBadge extends StatelessWidget {
  final bool isSelected;

  const InterestBadge({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      switchInCurve: Curves.easeInOutCubic,
      switchOutCurve: Curves.easeInOutCubic,
      child: isSelected
          ? SvgIcon(
              key: const ValueKey('selected'),
              iconPath: Assets.icons.tickLFilled,
              width: ScreenSize.isSmallWidth ? 14 : 16,
              height: ScreenSize.isSmallWidth ? 14 : 16,
            )
          : SvgIcon(
              key: const ValueKey('unselected'),
              iconPath: Assets.icons.tickLOutlined,
              width: ScreenSize.isSmallWidth ? 14 : 16,
              height: ScreenSize.isSmallWidth ? 14 : 16,
            ),
    );
  }
}
