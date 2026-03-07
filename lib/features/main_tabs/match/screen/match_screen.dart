import 'package:mama_app/features/main_tabs/match/modules/upgrade_now_module.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../shared/wave_request/controller/wave_request_controller.dart';
import '../controller/match_controller.dart';
import '../modules/searching_cancel_btn.dart';
import '../widgets/match_user_details.dart';

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mc = Get.find<MatchController>();
    final matchRefreshKey = GlobalKey<RefreshIndicatorState>();

    return AppScreenTemplate(
      refreshKey: matchRefreshKey,
      onRefresh: () async {
        print("chat refreshed");
      },
      appBar: CommonAppBarContent(title: Strings.match, hasBackNavArrow: false),
      child: Obx(() {
        switch (mc.matchState.value) {
          /// ---------------- IDLE ----------------
          case MatchState.idle:
            return _tapToSearchUI(mc);

          /// ---------------- SEARCHING ----------------
          case MatchState.searching:
            return _searchingUI(mc);

          /// ---------------- FOUND ----------------
          case MatchState.found:
            return _matchFoundUI(mc);
          case MatchState.noMatch:
            return _noMatchUI(mc);
        }
      }).getcm,
    );
  }

  //
  Widget _tapToSearchUI(MatchController mc) {
    return IntrinsicHeight(
      child: Column(
        children: [
          ContainerBordered(
            contClr: white,
            hp: 12,
            vp: 22,
            child: Column(
              children: [
                Text(
                  textAlign: TextAlign.center,
                  Strings.tapToFindNearbyMums,
                  style: TxtStyle.outfitSmNor500,
                ),
                Gap(itemGap * 2),

                GestureDetector(
                  onTap: mc.startSearching,
                  child: Container(
                    decoration: 0.circleBrdr(
                      brdrW: 4,
                      brdrClr: mc.subUpgradeNeeded.value ? grey200 : c.inputBackground,
                    ),
                    padding: 6.pa,
                    child: CircleAvatar(
                      radius: 35.r,
                      backgroundColor: mc.subUpgradeNeeded.value ? grey200 : c.inputBackground,
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
          Image.asset(ImagesPath.locationMap),

          Gap(itemGap),
          UpgradeNowModule(onTapUgradeNow: mc.onTapUpgradeNow),
          Gap(itemGap * 3),
        ],
      ),
    );
  }

  Widget _searchingUI(MatchController mc) {
    return ContainerBordered(
      contClr: white,
      hp: 12,
      vp: 22,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(textAlign: TextAlign.center, Strings.searching, style: TxtStyle.outfitSmNor500),

          Gap(itemGap),

          GestureDetector(onTap: mc.cancelSearch, child: SearchingCancelButton()),
        ],
      ),
    );
  }

  Widget _matchFoundUI(MatchController mc) {
    return IntrinsicHeight(
      child: Column(
        children: [
          MatchUserDetails(
            user: FakeUserDetailsModel(
              name: "John Doe",
              age: 24,
              imageUrl: Strings.fakeImageUrl,
              aboutMe: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
              infoList: [
                UiInfoItem(iconPath: IconsPath.locationBold, text: 'Ikeja, Lagos'),
                UiInfoItem(iconPath: IconsPath.chartFilled, text: 'TTC: Trying to conceive'),
                UiInfoItem(
                  iconPath: IconsPath.heartHalfFilled,
                  text: 'Interested in: Food delivery, Grocery delivery viudf vugdfv iodfv hdfiu v',
                ),
              ],
              galleryImages: [
                Strings.fakeImageUrl,
                Strings.fakeImageUrl,
                Strings.fakeImageUrl,
                Strings.fakeImageUrl,
              ],
              children: ["👶11 Months", "👶11 Months"],
            ),

            isLoading: mc.isLoading,
            isSeeMore: mc.isSeeMore,

            onTapSeeMore: mc.toggleSeeMore,

            onTapAction: (hasWaved) async {
              await mc.onAction(hasWaved);
            },
          ),

          Gap(itemGap * 2),

          UpgradeNowModule(onTapUgradeNow: mc.onTapUpgradeNow),
          Gap(itemGap * 3),
        ],
      ),
    );
  }

  Widget _noMatchUI(MatchController mc) {
    return IntrinsicHeight(
      child: ContainerBordered(
        contClr: white,
        hp: 12,
        vp: 22,
        child: Column(
          children: [
            Text(
              Strings.noWeMamasNearby,
              textAlign: TextAlign.center,
              style: TxtStyle.outfitSmTitleSec,
            ),
            Text(
              Strings.checkBackLater,
              textAlign: TextAlign.center,
              style: TxtStyle.outfitSmSecNor,
            ),

            Gap(itemGap * 3),

            CustomBtnWTxt(
              btnTxt: Strings.tryAgain.capEachWord(),
              onTap: mc.startSearching,
              isLoading: false,
            ),

            Gap(itemGap * 2),
          ],
        ),
      ),
    );
  }

  ///
}
