import '../../app/helper_widgets_export.dart';

class CusScrollbarWidget extends StatelessWidget {
  final Column child;
  final Color? thumbColor; // optional color
  final ScrollController controller;

  const CusScrollbarWidget({
    super.key,
    required this.child,
    this.thumbColor,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollbarTheme(
      data: ScrollbarThemeData(
        thumbColor: MaterialStateProperty.all(c.primary),
        trackColor: MaterialStateProperty.all(c.primary.withOpacity(0.1)),
        trackBorderColor: MaterialStateProperty.all(Colors.transparent),
      ),
      child: Scrollbar(
        controller: controller,
        thumbVisibility: true,
        interactive: true,
        radius: Radius.circular(8.r),
        child: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: SingleChildScrollView(
            controller: controller,
            physics: const ClampingScrollPhysics(),
            child: child,
          ),
        ),
      ),
    );
  }
}
