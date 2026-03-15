import '../../../app/helper_widgets_export.dart';
import '../../../core/common_widgets/cus_flexible_dropdown.dart';
import '../../../core/helpers/widgets_helper.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NetworkImageWidget(imageUrl: Strings.fakeImageUrl, isCircle: true, radius: 18),

        Gap(10),

        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Darrell Steward", style: TxtStyle.outfit(fs: 13, w: 600)),
                  Gap(6),
                  Text("11:16 pm", style: TxtStyle.outfit(fs: 11, color: c.textSecondary)),
                ],
              ),

              Gap(4),

              Text(
                "However Rare Side Effects Observed Among Children Can Be Metabolic Acidosis, Coma, Respiratory Depression",
                style: TxtStyle.outfit(fs: 12),
              ),
            ],
          ),
        ),

        CusFlexibleDropdown(
          items: [
            CusDropdownItem(
              title: Strings.reportContent,
              onTap: () async => await showReportBottomSheet(),
            ),
          ],
          child: SvgIconColored(iconPath: IconsPath.moreVertical, height: 20),
        ),
      ],
    );
  }
}
