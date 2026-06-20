import '../../../../app/helper_widgets_export.dart';
import '../controller/lifestyle_and_interests_controller.dart';
import 'interest_badge.dart';
import 'interest_icon.dart';
import 'interest_label.dart';

class LifestyleInterestTile extends StatelessWidget {
  final InterestItem item;

  const LifestyleInterestTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final controller = LifestyleAndInterestsController.to;

    return Obx(() {
      final isSelected = controller.isSelected(item.label);

      return CusGestureDetector(
        onTap: () => controller.toggle(item.label),

        child: ContainerBordered(
          hasBrdr: true,
          vp: 8,
          hp: 8,
          brdrClr: c.foregroundSecondary.withValues(alpha: 0.1),
          brdrW: 1,
          alignment: Alignment.center,
          contClr: contBgClr,

          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // MAIN CONTENT
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InterestIcon(iconPath: item.iconPath),
                    Gap(4.h),
                    InterestLabel(label: item.label),
                  ],
                ),
              ),

              // BADGE
              Positioned(
                top: ScreenSize.isSmallWidth ? -2 : -4,
                right: ScreenSize.isSmallWidth ? -2 : -4,
                child: InterestBadge(isSelected: isSelected),
              ),
            ],
          ),
        ),
      );
    });
  }
}
