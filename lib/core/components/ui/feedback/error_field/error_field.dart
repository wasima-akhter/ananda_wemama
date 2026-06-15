import '../../../../../app/helper_widgets_export.dart';

class SetupFieldError extends StatelessWidget {
  final String error;

  const SetupFieldError({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    if (error.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: 3.h),
      child: Text(error, style: TxtStyle.poppins(fs: 12, color: Colors.red)),
    );
  }
}
