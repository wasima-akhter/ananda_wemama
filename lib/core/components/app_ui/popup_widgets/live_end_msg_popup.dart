import 'package:mama_app/core/components/ui/dialogs/small_popup_dialog.dart';
import 'package:mama_app/features/main_nav/controller/main_nav_controller.dart';

import '../../../../app/helper_widgets_export.dart';

class LiveEndMsgPopup extends StatelessWidget {
  const LiveEndMsgPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return SmallPopupDialog(
      hm: 15,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.liveEndPopupMsg1.capEachWord(),
            style: TxtStyle.outfitSemiB(fs: 15, w: 600, color: c.primary),
          ),
          Gap(itemGap),
          Text(
            Strings.liveEndPopupMsg2.capEachWord(),
            style: TxtStyle.urbanist(fs: 13, color: c.primary),
          ),

          Gap(itemGap * 3),

          Row(
            children: [
              Gap(4),
              Expanded(
                child: CusGestureDetector(
                  onTap: () {
                    Get.back();
                    // how to remove all previous page routes and then redirecto this page
                    Get.offAllNamed(RoutePaths.mainNav);
                    MainNavController.to.goToTab(4);
                  },
                  child: ContainerBordered(
                    hasBrdr: true,
                    rad: 30,
                    vp: 8,

                    child: Text(
                      Strings.back,
                      style: TxtStyle.interSemiB(fs: 13, w: 600, color: c.primary),
                    ),
                  ),
                ),
              ),
              Gap(itemGap),
              Expanded(
                child: CusGestureDetector(
                  onTap: () {
                    Get.back();
                    // how to remove all previous page routes and then redirecto this page
                    Get.offAllNamed(RoutePaths.ongoingSessions);
                  },
                  child: ContainerBordered(
                    rad: 30,
                    contClr: c.primary,
                    vp: 8,

                    child: Text(
                      Strings.browseMore,
                      style: TxtStyle.interSemiB(fs: 13, w: 600, color: white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ).mHV(0, 10),
    );
  }
}
