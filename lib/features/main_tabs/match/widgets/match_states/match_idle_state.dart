import 'package:we_mama/core/components/ui/media/safe_asset_image.dart/safe_image_asset.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../../../../../gen/assets.gen.dart';
import '../../controller/match_controller.dart';
import '../../modules/upgrade_now_module.dart';

class MatchIdleState extends StatelessWidget {
  const MatchIdleState({super.key, required this.mc});

  final MatchController mc;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isPremium = mc.isPaidUser.value;
      final limitReached = mc.subUpgradeNeeded.value;
      final remaining = mc.remainingSearchesToday;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ContainerBordered(
            contClr: white,
            hp: 12,
            vp: 12,
            child: Column(
              children: [
                Text(
                  Strings.tapToFindNearbyMums,
                  textAlign: TextAlign.center,
                  style: TxtStyle.outfitSmNor500,
                ),

                Gap(itemGap),

                // Free users see remaining count; premium users get no
                // limit copy at all.
                if (!isPremium)
                  Text(
                    limitReached
                        ? "You've used all ${mc.freeDailyLimit} free searches today"
                        : "$remaining of ${mc.freeDailyLimit} free searches left today",
                    textAlign: TextAlign.center,
                    style: TxtStyle.outfitSmNor500.copyWith(
                      color: limitReached ? c.error : c.textSecondary,
                    ),
                  ),

                Gap(itemGap * 2),

                GestureDetector(
                  onTap: mc.startSearching, // internal limit check still fires
                  child: Container(
                    decoration: 0.circleBrdr(
                      brdrW: 4,
                      brdrClr: limitReached ? grey200 : c.inputBackground,
                    ),
                    padding: 6.pa,
                    child: CircleAvatar(
                      radius: 35.r,
                      backgroundColor: limitReached
                          ? grey200
                          : c.inputBackground,
                      child: Text(
                        Strings.tap,
                        style: TxtStyle.outfitSemiB(
                          fs: 13,
                          w: limitReached ? 700 : 400,
                          color: limitReached ? white : c.strokePrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Gap(itemGap),
          SafeAssetImage(assetPath: Assets.images.matchMap.path),
          Gap(itemGap),

          // No point upselling someone who's already premium.
          if (!isPremium)
            UpgradeNowModule(
              onTapUgradeNow: mc.onTapUpgradeNow,
              remainingCount: mc.remainingSearchesToday,
              dailyLimit: mc.freeDailyLimit,
            ),

          Gap(itemGap * 3),
        ],
      );
    });
  }
}
