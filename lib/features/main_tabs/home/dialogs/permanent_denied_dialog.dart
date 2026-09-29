import 'package:geolocator/geolocator.dart';

import '../../../../app/helper_widgets_export.dart';

class PermanentDeniedDialog extends StatelessWidget {
  const PermanentDeniedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(Strings.permissionIsRequired.capEachWord()),
      content: Text(
        Strings.locationPermissionDeniedForeverPlzEnable.capEachWord(),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(Strings.cancel.capEachWord()),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: c.secondary),
          onPressed: () {
            Geolocator.openAppSettings();
            Get.back();
          },
          child: Text(
            Strings.openSettings.capEachWord(),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
