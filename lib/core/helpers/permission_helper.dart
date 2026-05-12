import 'package:permission_handler/permission_handler.dart';

import '../../app/helper_widgets_export.dart';
import '../components/ui/dialogs/popups.dart';
import '../components/ui/dialogs/small_popup_dialog.dart';

Future<bool> requestPermissions() async {
  final result = await [
    Permission.camera,
    Permission.microphone,
    Permission.storage,
  ].request();

  final allGranted = result.values.every((status) => status.isGranted);

  if (!allGranted) {
    await showAnimatedDialog(
      context: Get.context!,
      barrierDismissible: true,
      child: const PermissionDeniedPopup(),
    );
  }

  return allGranted;
}

class PermissionDeniedPopup extends StatelessWidget {
  const PermissionDeniedPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return SmallPopupDialog(
      child: Column(
        children: [
          SvgIcon(
            iconPath: IconsPath.info, // change icon if needed
            height: S.w * 0.18,
          ),

          Gap(itemGap * 2),

          Text(
            "Permission Required",
            style: TxtStyle.interSemiB(fs: 18, w: 700, color: c.primary),
          ),

          Gap(4),

          Text(
            "Please allow camera, microphone and storage permissions.",
            textAlign: TextAlign.center,
            style: TxtStyle.inter(fs: 12, color: c.primary),
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
                  onTap: () => Get.back(),
                ),
              ),

              Gap(itemGap),

              Expanded(
                child: CustomBtnWTxt(
                  isLoading: false,
                  isSmall: true,
                  btnTxt: "Settings",
                  btnColor: c.primary,
                  txtClr: white,
                  rad: 12,
                  onTap: () async {
                    Get.back();
                    await openAppSettings();
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
