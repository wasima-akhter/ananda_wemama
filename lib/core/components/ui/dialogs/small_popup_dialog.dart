import '../../../../app/helper_widgets_export.dart';

class SmallPopupDialog extends StatelessWidget {
  final Widget child; // <-- the content to show
  final double? hm;

  const SmallPopupDialog({super.key, required this.child, this.hm});

  @override
  Widget build(BuildContext context) {
    return Center(
      // center ensures dialog content wraps naturally
      child: Material(
        color: Colors.transparent, // remove default material color
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 30.w, horizontal: (15).w),
          decoration: BoxDeco.decRadiusAll(20, clr: c.textOnPrimary),
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: (hm ?? 30).w),

          child: Column(
            mainAxisSize: MainAxisSize.min, // <-- keeps height to content
            children: [
              child, // <-- whatever content you pass
            ],
          ),
        ),
      ),
    );
  }
}

class LargePopupDialog extends StatelessWidget {
  final Widget child; // <-- the content to show

  const LargePopupDialog({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      // center ensures dialog content wraps naturally
      child: Material(
        color: Colors.transparent, // remove default material color
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 20.w),
          decoration: BoxDeco.decRadiusAll(20, clr: c.textOnPrimary),
          width: double.infinity,

          child: child,
        ).get10cm,
      ),
    );
  }
}
