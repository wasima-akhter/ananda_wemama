import 'package:we_mama/app/helper_widgets_export.dart';

import '../../../../../../../core/network/helpers/location/location_manager_global/app_location_manager.dart';

class EnableLocationButton extends StatelessWidget {
  const EnableLocationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CusGestureDetector(
      onTap: () async {
        Get.back();
        final result = await AppLocationManager.to.enableLocationGateway();

        closeAllSnackbar();
        // Get.back();

        if (result == LocationFlowResult.success) {
          Snack.showSuccess("Location enabled");
        } else {
          Snack.showError("Please enable location fully");
        }
      },

      child: ContainerBordered(
        rad: 30,
        vp: 2.5,
        hp: 9,
        contClr: c.primary,

        child: Text(
          "Enable",

          style: TxtStyle.outfitSemiB(fs: 13, w: 400, color: white),
        ),
      ),
    );
  }
}
