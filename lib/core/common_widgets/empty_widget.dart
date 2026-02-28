import 'package:mama_app/app/helper_widgets_export.dart';

class EmptyWidget extends StatelessWidget {
  final String title;
  const EmptyWidget({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [Text(title, style: TxtStyle.inter(w: 600))],
    ).mT(30.h);
  }
}

class EmptyWidgetScrollable extends StatelessWidget {
  final String title;
  const EmptyWidgetScrollable({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: 200, // ensure enough scrollable area
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Text(title, style: TxtStyle.inter(w: 600))],
        ).mT(30.h),
      ),
    );
  }
}
