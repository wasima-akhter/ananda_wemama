

import '../../../../app/helper_widgets_export.dart';

class DisableNotificationsPopup extends StatelessWidget {
  const DisableNotificationsPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return SmallPopupDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Disable Notifications",
            style: TxtStyle.interSemiB(fs: 18, w: 700, color: c.primary),
            textAlign: TextAlign.center,
          ),

          Gap(itemGap),

          Text(
            "To completely disable notifications, you need to turn them off from your device settings. Do you want to open settings?",
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
                    Get.back(result: false);
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
                  onTap: () {
                    Get.back(result: true);
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
