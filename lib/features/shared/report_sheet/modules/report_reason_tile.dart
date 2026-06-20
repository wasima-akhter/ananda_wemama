import '../../../../app/helper_widgets_export.dart';
import '../controller/report_controller.dart';

class ReasonTile extends StatelessWidget {
  const ReasonTile({super.key, required this.reason, required this.controller});

  final String reason;
  final ReportController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.selectedReason.value == reason;

      return CusGestureDetector(
        onTap: () => controller.selectReason(reason),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? c.primary : c.cardPrimary,
            borderRadius: 35.brdrRad,
          ),
          child: Row(
            children: [
              Expanded(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TxtStyle.outfitSemiB(fs: 14, color: isSelected ? white : c.foregroundPrimary),
                  child: Text(reason),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isSelected
                    ? SvgIconColored(
                        key: const ValueKey("tick"),
                        iconPath: IconsPath.smallTick,
                        iconColor: white,
                        height: 18,
                      )
                    : const SizedBox.shrink(key: ValueKey("empty")),
              ),
            ],
          ),
        ),
      );
    });
  }
}
