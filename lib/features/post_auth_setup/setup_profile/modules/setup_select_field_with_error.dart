import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/feedback/error_field/error_field.dart';
import '../widgets/setup_select_field.dart';

class SetupSelectFieldWithError extends StatelessWidget {
  final String title;
  final String value;
  final String placeholder;
  final String errorText;
  final VoidCallback onTap;
  final bool showArrow;

  const SetupSelectFieldWithError({
    super.key,
    required this.title,
    required this.value,
    required this.placeholder,
    required this.errorText,
    required this.onTap,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SetupSelectField(
          title: title,
          value: value,
          placeholder: placeholder,
          onTap: onTap,
          showArrow: showArrow,
        ),

        SetupFieldError(error: errorText),
      ],
    );
  }
}
