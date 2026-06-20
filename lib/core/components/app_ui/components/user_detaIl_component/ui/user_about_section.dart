import '../../../../../../app/helper_widgets_export.dart';
import '../../../../../helpers/string_helper.dart';

class UserAboutSection extends StatelessWidget {
  final String aboutText;
  final RxBool isExpanded;
  final VoidCallback onToggle;

  const UserAboutSection({
    super.key,
    required this.aboutText,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.aboutMe.cap, style: TxtStyle.outfitSemiB(fs: 15, w: 500)),
        Obx(() {
          return Text(
            aboutText,
            style: TxtStyle.outfit(fs: 13),
            maxLines: isExpanded.value ? null : 3,
            overflow: isExpanded.value
                ? TextOverflow.visible
                : TextOverflow.ellipsis,
          );
        }),
        if (_shouldShowButton())
          GestureDetector(
            onTap: onToggle,
            child: Obx(
              () => Text(
                isExpanded.value ? Strings.seeLess.cap : Strings.seeMore.cap,
                style: TxtStyle.outfitxSmNor500,
              ).mHV(0, 2),
            ),
          ),
      ],
    );
  }

  bool _shouldShowButton() {
    return isTextOverflowing(
      text: aboutText,
      style: TxtStyle.outfitSmNor500,
      maxWidth: S.w * 0.8,
      maxLines: 3,
    );
  }
}
