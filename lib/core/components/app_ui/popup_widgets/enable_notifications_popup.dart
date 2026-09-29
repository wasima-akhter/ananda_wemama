import 'package:permission_handler/permission_handler.dart' as AppSettings;

import '../../../../app/helper_widgets_export.dart';
import '../../../services/push_notification/push_notification_service.dart';

class EnableNotificationsPopup extends StatelessWidget {
  const EnableNotificationsPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return SmallPopupDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Enable Notifications",
            style: TxtStyle.interSemiB(fs: 18, w: 700, color: c.primary),
            textAlign: TextAlign.center,
          ),

          Gap(itemGap),

          Text(
            "Notifications are disabled. Please enable them from system settings.",
            style: TxtStyle.inter(fs: 12, color: c.primary),
            textAlign: TextAlign.center,
          ),

          Gap(itemGap * 2),

          Row(
            children: [
              Expanded(
                child: CustomBtnWTxt(
                  isLoading: false,
                  isSmall: true,
                  outlined: true,
                  btnTxt: "Cancel",
                  btnColor: ctransp,
                  txtClr: c.primary,
                  rad: 12,
                  padding: 12.pv,
                  onTap: () {
                    Get.back();
                  },
                ),
              ),

              Gap(itemGap),

              Expanded(
                child: CustomBtnWTxt(
                  isLoading: false,
                  isSmall: true,
                  btnTxt: "Open Settings",
                  btnColor: c.primary,
                  txtClr: white,
                  rad: 12,
                  padding: 12.pv,
                  onTap: () async {
                    Get.back();
                    await AppSettings.openAppSettings();

                    await PushNotificationService.to
                        .refreshNotificationPermissionStatus();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
