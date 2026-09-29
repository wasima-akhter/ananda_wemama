import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../app/helper_widgets_export.dart';
import '../components/ui/dialogs/popups.dart';
import '../components/ui/dialogs/small_popup_dialog.dart';

Future<bool> requestPermissions() async {
  final permissions = <Permission>[Permission.camera, Permission.microphone];

  if (Platform.isAndroid) {
    final sdk = (await DeviceInfoPlugin().androidInfo).version.sdkInt;

    //

    //
    if (sdk >= 33) {
      // Android 13+: granular media permissions
      permissions.addAll([Permission.photos, Permission.audio]);
    } else {
      // Android 10–12: legacy storage (capped in manifest at API 29/32)
      permissions.add(Permission.storage);
    }
  }

  final result = await permissions.request();

  for (final entry in result.entries) {
    print('PERMISSION: ${entry.key} => ${entry.value}');
  }
  final allGranted = result.entries.every(
    (entry) => isPermissionAccepted(entry.key, entry.value),
  );

  if (!allGranted) {
    await showAnimatedDialog(
      context: Get.context!,
      barrierDismissible: true,
      child: const PermissionDeniedPopup(),
    );
  }

  return allGranted;
}

bool isPermissionAccepted(Permission permission, PermissionStatus status) {
  if (status.isGranted) {
    return true;
  }

  // Limited access is relevant for Photos.
  if (permission == Permission.photos && status.isLimited) {
    return true;
  }

  return false;
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
            Platform.isIOS
                ? "Please enable microphone access from Settings > Privacy & Security > Microphone."
                : "Please allow microphone permission from Settings.",
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
