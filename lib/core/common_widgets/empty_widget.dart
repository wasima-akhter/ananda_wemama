import 'package:lottie/lottie.dart';
import 'package:mama_app/app/helper_widgets_export.dart';

class EmptyWidget extends StatelessWidget {
  final String title;
  const EmptyWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      contClr: c.bottomSheetBackground.withOpacity(0.2),
      vp: 20.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Gap(itemGap * 2),
          Text(title.capEachWord(), style: TxtStyle.inter(w: 600, color: c.navItemUnselected)),

          Gap(itemGap * 2),

          Image.asset(ImagesPath.noSearchImg, fit: BoxFit.contain, height: S.w * 0.36),
          Gap(itemGap * 7),
        ],
      ),
    ).mT(12);
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
        height: S.h * 0.3, // ensure enough scrollable area
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(title, style: TxtStyle.inter(w: 600)),

            Lottie.asset(
              ImagesPath.nothingYetJson,

              fit: BoxFit.contain,
              repeat: true,
              animate: true,
            ),
          ],
        ).mT(30.h),
      ),
    );
  }
}
