import '../widgets/match_user_details.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../shared/wave_request/controller/wave_request_controller.dart';
import '../controller/match_controller.dart';

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
        }
      }).getcm,
    );
  }

  //
  Widget _tapToSearchUI(MatchController mc) {
    return Column(
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
                    brdrClr: c.inputBackground,
                  ),
                  padding: 6.pa,
                  child: CircleAvatar(
                    radius: 35.r,
                    backgroundColor: c.inputBackground,
                    child: Text(Strings.tap, style: TxtStyle.outfitSmSecNor),
                  ),
                ),
              ),
            ],
          ),
        ),

        Gap(itemGap * 2),
        Image.asset(ImagesPath.locationMap),
      ],
    );
  }

  Widget _searchingUI(MatchController mc) {
    return ContainerBordered(
      contClr: white,
      hp: 12,
      vp: 22,
      child: Column(
        children: [
          Text(
            textAlign: TextAlign.center,
            Strings.searching,
            style: TxtStyle.outfitSmNor500,
          ),

          Gap(itemGap * 5),

          GestureDetector(
            onTap: mc.cancelSearch,
            child: Container(
              decoration: 0.circleBrdr(brdrW: 4, brdrClr: c.inputBackground),
              child: Container(
                decoration: 0.circleBrdr(brdrW: 4, brdrClr: c.inputBackground),
                child: Container(
                  decoration: 0.circleBrdr(
                    brdrW: 4,
                    brdrClr: c.inputBackground,
                  ),
                  padding: 6.pa,
                  child: CircleAvatar(
                    radius: 35.r,
                    backgroundColor: c.inputBackground,
                    child: Text(Strings.cancel, style: TxtStyle.outfitSmSecNor),
                  ),
                ),
              ),
            ),
          ),

          Gap(itemGap * 5),
        ],
      ),
    );
  }

  Widget _matchFoundUI(MatchController mc) {
    return Column(
      children: [
        MatchUserDetails(
          user: FakeUserDetailsModel(
            name: "John Doe",
            age: 24,
            imageUrl: Strings.fakeImageUrl,
            aboutMe: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
            infoList: [
              UiInfoItem(
                iconPath: IconsPath.locationBold,
                text: 'Ikeja, Lagos',
              ),
              UiInfoItem(
                iconPath: IconsPath.chartFilled,
                text: 'TTC: Trying to conceive',
              ),
              UiInfoItem(
                iconPath: IconsPath.heartHalfFilled,
                text:
                    'Interested in: Food delivery, Grocery delivery viudf vugdfv iodfv hdfiu v',
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

        _makeChatUnlockMsges(
          title: Strings.dailyWaveLimit,
          subtitle: Strings.waveLimitDescription,
          iconPath: IconsPath.security,
        ),

        Gap(itemGap * 2),

        IntrinsicWidth(
          child: CustomBtnWTxt(
            isSmall: true,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
            btnTxt: Strings.upgradeNow,
            isLoading: false,
            rad: 8,
          ),
        ),
        Gap(itemGap * 3),
      ],
    );
  }

  Widget _makeChatUnlockMsges({
    required String title,
    required String subtitle,
    required String iconPath,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgIcon(iconPath: iconPath, height: 25),

        Gap(itemGap),

        ///
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TxtStyle.interSemiB(fs: 13, w: 500, color: c.primary),
              ),
              Gap(6),
              Text(subtitle, style: TxtStyle.inter(fs: 12, color: c.secondary)),
            ],
          ),
        ),
      ],
    );
  }

  ///
}
