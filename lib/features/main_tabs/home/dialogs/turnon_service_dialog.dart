import 'package:geolocator/geolocator.dart';

import '../../../../app/helper_widgets_export.dart';

class TurnOnServiceDialog extends StatelessWidget {
  const TurnOnServiceDialog({super.key, required this.onTurnOn});

  final VoidCallback onTurnOn;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: 20.brdrRad),
      title: Row(
        children: [
          Icon(Icons.location_off_rounded, color: Colors.orange),
          Gap(8.w),
          Expanded(
            child: Text(
              Strings.enableLocation.capEachWord(),
              style: TxtStyle.fs18.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.locationNeededForMatchingExplained,
            style: TxtStyle.norTxt,
          ),
          Gap(12.w),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: c.secondary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.favorite_rounded, color: c.secondary, size: 16),
                Gap(6.w),
                Expanded(
                  child: Text(
                    Strings.locationUsedForMatchingOnly,
                    style: TxtStyle.norTxt.copyWith(
                      fontSize: 12,
                      color: c.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            Strings.notNow.capEachWord(),
            style: TextStyle(color: c.textSecondary),
          ),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: c.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          icon: Icon(Icons.settings_rounded, size: 16, color: Colors.white),
          label: Text(
            Strings.turnOn.capEachWord(),
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            onTurnOn();
            Get.back();
            await Geolocator.openLocationSettings();
          },
        ),
      ],
    );
  }
}
