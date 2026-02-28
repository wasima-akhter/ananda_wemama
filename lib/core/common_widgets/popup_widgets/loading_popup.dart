import '../../../app/helper_widgets_export.dart';

class LoadingPopup extends StatelessWidget {
  const LoadingPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,

        padding: EdgeInsets.only(bottom: S.bottomInset),
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: (S.w * 0.1).pv,
              margin: (S.w * 0.2).ph,
              decoration: BoxDecoration(color: bgClr, borderRadius: BorderRadius.circular(20)),
              child: Column(mainAxisSize: MainAxisSize.min, children: [Loading()]),
            ),
          ),
        ),
      ),
    );
  }
}
