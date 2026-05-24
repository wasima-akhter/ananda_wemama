import '../../../../../../../app/helper_widgets_export.dart';
import '../../../../../../../core/components/app_ui/tags/tag_type_widgets.dart';
import '../../../../../../../core/components/ui/dropdowns/cus_flexible_dropdown.dart';
import '../../../../../../../core/network/helpers/location/location_manager_global/app_location_manager.dart';
import 'location_overlay_card.dart';

class ActiveInfoDropdown extends StatelessWidget {
  const ActiveInfoDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final alm = AppLocationManager.to;
    final overlayHeight = 10.h;

    return Obx(() {
      final isActive = alm.isLocationActive.value;

      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ActiveTag(isActive: isActive),

          Gap(itemGap),

          CusFlexibleDropdown(
            items: [],
            offset: Offset(0, overlayHeight),

            customOverlay: Container(
              margin: EdgeInsets.only(left: S.w * 0.2, right: S.w * 0.07),

              child: LocationOverlayCard(isActive: isActive),
            ),

            child: ActiveInfo(isActive: isActive),
          ),
        ],
      );
    });
  }
}
