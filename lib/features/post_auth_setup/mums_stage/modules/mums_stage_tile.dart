import '../../../../app/helper_widgets_export.dart';
import '../controller/mums_stage_controller.dart';

class MumsStageTile extends GetView<MumsStageController> {
  final MumStageUIDataModel item;
  final bool isSelected;

  const MumsStageTile({
    super.key,
    required this.item,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.toggleStage(item.id),
      child: ContainerBordered(
        vp: ScreenSize.isSmallWidth ? 8 : 10,
        hp: 14,
        alignment: Alignment.centerLeft,
        mv: ScreenSize.isSmallWidth ? 3 : 5,
        rad: 12,
        contClr: isSelected
            ? Color(0xFF942200).withValues(alpha: 0.9)
            : inputBgClr,
        hasBrdr: true,
        brdrClr: isSelected ? c.strokePrimary : newBorderClr,
        brdrW: 1,
        child: Row(
          children: [
            SvgIconColored(
              iconPath: item.leftIcon,
              iconColor: isSelected ? c.scaffoldBackground : Color(0xFF942200),
              height: 20,
            ),

            const Gap(12),

            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: item.title,
                      style: TxtStyle.interSemiB(
                        //  fs: 14,
                        w: isSelected ? 600 : 600,
                        ls: 0.1,
                        color: isSelected
                            ? c.scaffoldBackground
                            : c.foregroundPrimary,
                      ),
                    ),
                    if (item.info.isNotEmpty)
                      TextSpan(
                        text: " ${item.info}",
                        style: TxtStyle.interSemiB(
                          //  fs: 14,
                          w: isSelected ? 500 : 600,
                          ls: 0.1,
                          color: isSelected
                              ? c.scaffoldBackground
                              : c.foregroundPrimary,
                        ),
                      ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            AppCheckbox(
              size: 20,
              value: isSelected,
              onChanged: (_) => controller.toggleStage(item.id),
              borderColor: isSelected
                  ? c.scaffoldBackground
                  : c.foregroundPrimary,
              checkColor: isSelected ? c.scaffoldBackground : c.strokePrimary,
            ),
          ],
        ),
      ),
    );
  }
}
