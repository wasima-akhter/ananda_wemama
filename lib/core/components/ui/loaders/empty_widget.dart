import 'package:mama_app/app/helper_widgets_export.dart';

class EmptyWidget extends StatelessWidget {
  final String title;
  final bool? isSmaller;
  const EmptyWidget({super.key, required this.title, this.isSmaller});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      contClr: c.bottomSheetBackground.withOpacity(0.2),
      vp: 20.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Gap(itemGap * 2),
          Text(title.capEachWord(), style: TxtStyle.inter(w: 600, color: c.secondary)),

          Gap(itemGap * 2),

          Image.asset(
            ImagesPath.noSearchImg,
            fit: BoxFit.contain,
            height: isSmaller == true ? S.w * 0.25 : S.w * 0.36,
          ),
          Gap(itemGap * 7),
        ],
      ),
    ).mT(12);
  }
}

class EmptyNoSearchWidget extends StatelessWidget {
  final String title;
  final bool? isSmaller;
  const EmptyNoSearchWidget({super.key, required this.title, this.isSmaller});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      contClr: c.bottomSheetBackground.withOpacity(0.2),
      vp: 20.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Gap(itemGap * 2),
          Text(title.capEachWord(), style: TxtStyle.inter(w: 600, color: c.secondary)),

          Gap(itemGap * 2),

          Image.asset(
            ImagesPath.emptyList,
            fit: BoxFit.contain,
            height: isSmaller == true ? S.w * 0.2 : S.w * 0.25,
          ),
          Gap(itemGap * 5),
        ],
      ),
    ).mT(12);
  }
}

class EmptySessionWidget extends StatelessWidget {
  final String title;
  const EmptySessionWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      contClr: c.bottomSheetBackground.withOpacity(0.2),
      vp: 20.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Gap(itemGap),
          Text(title.capEachWord(), style: TxtStyle.inter(w: 600, color: c.secondary)),

          Gap(itemGap),

          Image.asset(ImagesPath.noSearchImg, fit: BoxFit.contain, height: S.w * 0.3),
          Gap(itemGap * 2),
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
      child:
          // ensure enough scrollable area
          ContainerBordered(
            h: S.h * 0.3,
            contClr: c.bottomSheetBackground.withOpacity(0.2),
            vp: 20.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Gap(itemGap),
                Text(title.capEachWord(), style: TxtStyle.inter(w: 600, color: c.secondary)),

                Gap(itemGap),

                Image.asset(ImagesPath.noSearchImg, fit: BoxFit.contain, height: S.w * 0.3),
                Gap(itemGap * 2),
              ],
            ),
          ),
    );
  }
}
