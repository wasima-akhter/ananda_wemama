import '../../../../app/helper_widgets_export.dart';

class LoadingPopup extends StatelessWidget {
  const LoadingPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return SmallPopupDialog(
      hm: S.w * 0.3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [LoadingPrimary()],
      ),
    );
  }
}
