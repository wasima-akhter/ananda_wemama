import '../../../../app/helper_widgets_export.dart';
import '../../../../gen/assets.gen.dart';

class InterestBadge extends StatelessWidget {
  final bool isSelected;

  const InterestBadge({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      child: isSelected
          ? SvgIconColored(
              key: const ValueKey('selected'),
              iconColor: c.strokePrimary,
              iconPath: Assets.icons.verifiedTick,
              width: 13,
              height: 13,
            )
          : SvgIcon(
              key: const ValueKey('unselected'),
              iconPath: Assets.icons.tickL,
              width: 16,
              height: 16,
            ),
    );
  }
}
