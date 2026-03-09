import '../../../../app/helper_widgets_export.dart';

class UserShortDetailWidget extends StatelessWidget {
  const UserShortDetailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NetworkImageWidget(imageUrl: Strings.fakeImageUrl, isCircle: true, radius: 25),
        Gap(itemGap * 1.5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFit("Username, 30", style: TxtStyle.outfitSmNor500),
            Row(
              children: [
                SvgIcon(iconPath: IconsPath.locationBold, height: 16),
                TextFit("Lagos", style: TxtStyle.outfitxSmNor500),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
