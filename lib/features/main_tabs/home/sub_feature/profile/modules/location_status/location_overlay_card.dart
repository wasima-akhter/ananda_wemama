import '../../../../../../../app/helper_widgets_export.dart';
import 'location_status_row.dart';

class LocationOverlayCard extends StatelessWidget {
  final bool isActive;

  const LocationOverlayCard({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ContainerBordered(
          vp: 16,
          hp: 12,
          contClr: c.scaffoldBackground,
          rad: 18,
          boxShadow: boxShadowAllSides,

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LocationStatusRow(isActive: isActive),

              Gap(5.h),

              Text(
                isActive
                    ? "Nearby moms can discover you now."
                    : Strings.inactiveNotVisible,

                style: TxtStyle.interSemiB(fs: 10, w: 400, color: c.primary),
              ),

              if (!isActive) ...[
                Gap(5.h),

                Text(
                  Strings.enableLocationForMatching,

                  style: TxtStyle.interSemiB(fs: 10, w: 400, color: c.primary),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
