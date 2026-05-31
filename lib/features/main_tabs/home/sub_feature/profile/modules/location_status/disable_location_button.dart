import '../../../../../../../app/helper_widgets_export.dart';
import '../../../../../../../core/network/helpers/location/location_manager_global/app_location_manager.dart';

class DisableLocationButton extends StatelessWidget {
  const DisableLocationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CusGestureDetector(
      onTap: () async {
        Get.back();
        final success = await AppLocationManager.to.disableLocation();

        if (success) {
          AppLocationManager.to.isLocationActive.value = false;
          closeAllSnackbar();

          Snack.showWarning("Location disabled. You are now inactive.");
        }
      },

      child: ContainerBordered(
        rad: 30,
        vp: 2.5,
        hp: 9,

        contClr: c.cardReminder.withValues(alpha: 0.5),

        child: Text(
          "Disable",

          style: TxtStyle.outfitSemiB(fs: 13, w: 400, color: c.primary),
        ),
      ),
    );
  }
}
