import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/inputs/custom_toggle_btn.dart';

class PreferenceTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final void Function(bool) onChanged;

  const PreferenceTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TxtStyle.outfit(fs: 15, w: 500, color: c.primary)),
              Gap(4),
              Text(subtitle, style: TxtStyle.outfit(fs: 12, color: c.primary.withOpacity(.6))),
            ],
          ),
        ),

        CustomToggleButton(value: value, onChanged: onChanged),
      ],
    );
  }
}
