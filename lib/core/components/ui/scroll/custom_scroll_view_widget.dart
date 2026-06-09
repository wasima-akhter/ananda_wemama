import '../../../../app/helper_widgets_export.dart';

class CustomScrollViewWidget extends StatelessWidget {
  final ScrollController controller;
  final List<Widget> slivers;

  const CustomScrollViewWidget({
    super.key,
    required this.controller,
    required this.slivers,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollbarTheme(
      data: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(c.primary),
        trackColor: WidgetStateProperty.all(c.primary.withAlpha(10)),
        trackBorderColor: WidgetStateProperty.all(Colors.transparent),
      ),
      child: Scrollbar(
        controller: controller, // ✅ same instance
        thumbVisibility: true,
        interactive: true,
        radius: Radius.circular(8.r),
        child: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: CustomScrollView(
            controller: controller, // ✅ same instance
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: slivers,
          ),
        ),
      ),
    );
  }
}
