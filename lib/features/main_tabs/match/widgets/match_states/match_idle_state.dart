import 'package:mama_app/core/components/ui/media/safe_asset_image.dart/safe_image_asset.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../../controller/match_controller.dart';
import '../../modules/upgrade_now_module.dart';

class MatchIdleState extends StatelessWidget {
  const MatchIdleState({super.key, required this.mc});

  final MatchController mc;

  @override
  Widget build(BuildContext context) {
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

              Gap(itemGap * 2),

              GestureDetector(
                onTap: mc.startSearching,
                child: Container(
                  decoration: 0.circleBrdr(
                    brdrW: 4,
                    brdrClr: mc.subUpgradeNeeded.value
                        ? grey200
                        : c.inputBackground,
                  ),
                  padding: 6.pa,
                  child: CircleAvatar(
                    radius: 35.r,
                    backgroundColor: mc.subUpgradeNeeded.value
                        ? grey200
                        : c.inputBackground,
                    child: Text(
                      Strings.tap,
                      style: TxtStyle.outfitSemiB(
                        fs: 13,
                        w: mc.subUpgradeNeeded.value ? 700 : 400,
                        color: mc.subUpgradeNeeded.value ? white : c.secondary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        Gap(itemGap),
        SafeAssetImage(assetPath: ImagesPath.locationMap),
        Gap(itemGap),
        UpgradeNowModule(onTapUgradeNow: mc.onTapUpgradeNow),
        Gap(itemGap * 3),
      ],
    );
  }
}
