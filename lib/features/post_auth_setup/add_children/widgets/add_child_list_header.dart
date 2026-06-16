import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/helpers/shapes/custom_divider.dart';

class AddChildrenListHeader extends StatelessWidget {
  const AddChildrenListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Saved List",
          style: TxtStyle.poppinsSemiB(
            fs: 13,
            w: 600,
            h: 1.4,
            color: c.foregroundPrimary.withValues(alpha: .7),
          ),
        ),
        Gap(10.w),
        Expanded(
          child: CustomDivider(
            h: 0.3,
            clr: c.foregroundPrimary.withValues(alpha: .5),
          ),
        ),
      ],
    );
  }
}
