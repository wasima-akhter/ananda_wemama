import 'package:we_mama/core/components/ui/feedback/ui_state/ui_state_card.dart';
import 'package:we_mama/core/components/ui/media/safe_asset_image/safe_image_asset.dart';
import 'package:we_mama/gen/assets.gen.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/loaders/shimmer_widget.dart';
import '../controller/home_controller.dart';

class GentleReminderCard extends StatelessWidget {
  const GentleReminderCard({super.key});

  @override
  Widget build(BuildContext context) {
    final hc = HomeController.to;
    return Obx(() {
      final state = getUIStateDetail(isLoading: hc.isGentleRemindLoading);
      final message = hc.gentleRemindData.value?.message;
      final msg = (message ?? Strings.restCounts).toString();
      return UIStateHandler(
        state: state,
        loading: () => TodaysReminderShimmer(),

        data: () => ContainerBordered(
          // contClr: c.cardReminder,
          contClr: Color(0xFFF8E6DC),
          rad: 20,
          hp: 14,
          vp: 12,
          alignment: Alignment.centerLeft,

          boxShadow: boxShadowBottom(),
          child: Row(
            children: [
              SizedBox(
                // color: Colors.amber,
                width: 40.w,
                child: SafeAssetImage(
                  shape: AssetImageShape.circle,
                  assetPath: Assets.images.reminderLove.path,
                ),
              ),
              Gap(15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Strings.todaysReminder.capEachWord(),
                      style: TxtStyle.outfitSemiB(fs: 16, w: 500),
                    ),
                    Gap(4),
                    Text(
                      msg.capEachWord(),
                      style: TxtStyle.outfitSemiB(
                        fs: 13,
                        color: c.strokePrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

//

class TodaysReminderShimmer extends StatelessWidget {
  const TodaysReminderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      contClr: c.cardReminder,
      rad: 20,
      hp: 16,
      vp: 12,
      boxShadow: boxShadowBottom(),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title shimmer
          ShimmerWidget.rectangular(
            width: 140.w,
            height: 14.h,
            shimmerClr: c.inputBorder.withOpacity(0.3),
          ),

          Gap(8),

          // Subtitle shimmer
          ShimmerWidget.rectangular(
            width: 200.w,
            height: 12.h,
            shimmerClr: c.inputBorder.withOpacity(0.25),
          ),
        ],
      ),
    );
  }
}
