import '../../../../app/helper_widgets_export.dart';

class CusScrollbarWidget extends StatelessWidget {
  final Widget child;
  final Color? thumbColor;
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
        thumbColor: WidgetStateProperty.all(thumbColor ?? c.primary),
        trackColor: WidgetStateProperty.all(c.primary.withOpacity(0.1)),
        trackBorderColor: WidgetStateProperty.all(Colors.transparent),
      ),
      child: Scrollbar(
        // ✅ NO controller here — Scrollbar finds the position via
        //    ScrollNotification from the CustomScrollView below
        thumbVisibility: true,
        interactive: true,
        radius: Radius.circular(8.r),
        child: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: child,
        ),
      ),
    );
  }
}
