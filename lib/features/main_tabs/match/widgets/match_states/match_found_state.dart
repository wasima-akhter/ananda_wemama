import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/common_widgets/common_components/user_detaIl_component/controller/user_detail_controller.dart';
import '../../controller/match_controller.dart';
import '../../modules/upgrade_now_module.dart';
import '../match_user_details.dart';

class MatchFoundState extends StatelessWidget {
  const MatchFoundState({super.key, required this.mc});

  final MatchController mc;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
            galleryImages: List.filled(4, Strings.fakeImageUrl),
            children: ["👶11 Months", "👶11 Months"],
          ),
          isLoading: mc.isLoading,
          isSeeMore: mc.isSeeMore,
          onTapSeeMore: mc.toggleSeeMore,
          onTapAction: (hasWaved) async => await mc.onAction(hasWaved),
        ),

        Gap(itemGap * 2),
        UpgradeNowModule(onTapUgradeNow: mc.onTapUpgradeNow),
        Gap(itemGap * 3),
      ],
    );
  }
}
