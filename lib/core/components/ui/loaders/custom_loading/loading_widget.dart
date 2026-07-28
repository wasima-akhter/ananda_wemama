import 'package:we_mama/app/helper_widgets_export.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 30.0.h,
        width: 30.0.w,
        child: CircularProgressIndicator(
          color: color ?? Colors.black,
          strokeWidth: 1.5,
        ),
      ),
    );
  }
}
