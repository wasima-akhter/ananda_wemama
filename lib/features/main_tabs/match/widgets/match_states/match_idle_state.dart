import 'package:flutter/foundation.dart';
import 'package:we_mama/core/components/ui/media/safe_asset_image/safe_image_asset.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../shared/subscription/subscription_access/premium_access_service.dart';
import '../../controller/match_controller.dart';
import '../../modules/upgrade_now_module.dart';

class MatchIdleState extends StatelessWidget {
  const MatchIdleState({super.key, required this.mc});

  final MatchController mc;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final premium = PremiumAccessService.to;
      final premiumReady = premium.isReady.value;
      final profileReady = mc.profile.value != null;
      final isPremium = true ?? premiumReady && premium.isPremiumUserNow;

      // ✅ Show loading until both are ready
      if (!premiumReady || !profileReady) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LoadingPrimary(),
              SizedBox(height: 16),
              Text('Loading premium status...', style: TxtStyle.outfit()),
              if (kDebugMode) ...[
                SizedBox(height: 16),
                Text('DEBUG: premium.isReady=${premium.isReady.value}'),
                Text('DEBUG: profile.ready=$profileReady'),
              ],
            ],
          ),
        );
      }

      final limitReached = mc.isWaveLimitReached;
      final remaining = mc.remainingWaves;
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
                if (premiumReady && !isPremium)
                  Text(
                    limitReached
                        ? "You've used all ${mc.dailyWaveLimit} free waves today."
                        : "${mc.remainingWaves} of ${mc.dailyWaveLimit} free waves left today.",
                    textAlign: TextAlign.center,
                    style: TxtStyle.outfitSmNor500.copyWith(
                      color: limitReached ? c.error : c.textSecondary,
                    ),
                  ),
                Gap(itemGap * 2),

                CusGestureDetector(
                  onTap: !isPremium && limitReached
                      ? null
                      : mc.startSearching, // internal limit check still fires
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
          if (premiumReady && !isPremium)
            UpgradeNowModule(
              onTapUgradeNow: mc.onTapUpgradeNow,
              remainingCount: mc.remainingWaves,
              dailyLimit: mc.dailyWaveLimit,
            ),

          Gap(itemGap * 3),
        ],
      );
    });
  }
}
