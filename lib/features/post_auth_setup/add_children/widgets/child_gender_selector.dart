import '../../../../app/helper_widgets_export.dart';
import 'child_gender_option.dart';

class ChildGenderSelector extends StatelessWidget {
  const ChildGenderSelector({
    super.key,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  final String selectedGender;
  final ValueChanged<String> onGenderChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Sex",
          style: TxtStyle.poppinsSemiB(fs: 12, w: 600, h: 1.4, ls: -0.1),
        ),
        Gap(6.h),
        Row(
          children: [
            ChildGenderOption(
              label: "Girl",
              selected: selectedGender == "girl",
              onTap: () => onGenderChanged("girl"),
            ),
            Gap(10.w),
            ChildGenderOption(
              label: "Boy",
              selected: selectedGender == "boy",
              onTap: () => onGenderChanged("boy"),
            ),
          ],
        ),
      ],
    );
  }
}
