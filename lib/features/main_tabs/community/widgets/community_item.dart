import '../../../../app/helper_widgets_export.dart';
import '../../../../core/common_widgets/common_components/small_outlined_btn.dart';

class CommunityItem extends StatelessWidget {
  final void Function()? onTapItemBtn;
  final void Function()? onTapItem;
  final bool isLoading;
  final String btnTxt;
  const CommunityItem({
    super.key,
    this.onTapItemBtn,
    required this.isLoading,
    required this.btnTxt,
    this.onTapItem,
  });

  @override
  Widget build(BuildContext context) {
    final stats = ["32", "656"];

    return CusGestureDetector(
      onTap: onTapItem,
      child: ContainerBordered(
        vp: 12,
        hp: 12,
        hasBrdr: true,
        brdrClr: c.inputBorder.withOpacity(0.3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Make the text column expand naturally
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFit(
                    "Lagos Single Mom's Community dfgv dydfvb uhdfbvu dfgvy df",
                    style: TxtStyle.outfitSmTitle,
                  ),

                  Gap(6),

                  Row(
                    children: List.generate(stats.length, (index) {
                      final text = index == 0 ? "New post" : "Members";
                      return Padding(
                        padding: EdgeInsets.only(right: index == stats.length - 1 ? 0 : 12.w),
                        child: Row(
                          children: [
                            CircleAvatar(radius: 4.r, backgroundColor: c.primary),
                            Gap(4),
                            Text("${stats[index]} $text", style: TxtStyle.outfitSmSecNor),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            Gap(12),

            SmallOutlinedBtn(isLoading: isLoading, btnTxt: btnTxt, onTap: onTapItemBtn),
          ],
        ),
      ),
    );
  }
}
