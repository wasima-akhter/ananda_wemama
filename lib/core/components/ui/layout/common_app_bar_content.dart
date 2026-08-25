import 'package:we_mama/features/main_nav/controller/main_nav_controller.dart';

import '../../../../app/helper_widgets_export.dart';
import '../buttons/back_arrow_in_circle.dart';

class CommonAppBarContent extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final Widget? suffix;
  final VoidCallback? onTapBack;
  final bool? hasBackNavArrow;
  final bool? isBgTransp;
  final bool? titleInLeft;
  final Widget? titleLeftWidget;
  final Widget? titleWidget;
  final bool? expandTitle;

  const CommonAppBarContent({
    super.key,
    required this.title,
    this.suffix,
    this.onTapBack,
    this.hasBackNavArrow,
    this.isBgTransp,
    this.titleInLeft,
    this.titleLeftWidget,
    this.titleWidget,
    this.expandTitle,
  });
  @override
  Widget build(BuildContext context) {
    final finalBg = isBgTransp == true ? ctransp : bgClrNew;

    return AppBar(
      backgroundColor: finalBg,
      surfaceTintColor: finalBg,
      elevation: 0,
      centerTitle: titleInLeft != true,

      leadingWidth: 60.w,

      leading: hasBackNavArrow == false
          ? const SizedBox.shrink()
          : Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: BackArrowInCircle(
                onTap: onTapBack ?? () => GNav.pop(),
              ).marginAll(2),
            ),

      titleSpacing: titleInLeft == true ? 0 : null,

      title:
          titleWidget ??
          (titleInLeft == true
              ? Row(
                  children: [
                    titleLeftWidget ?? const SizedBox.shrink(),

                    Gap(itemGap),

                    Expanded(
                      child: Text(
                        title.capEachWord(),
                        overflow: TextOverflow.ellipsis,
                        style: TxtStyle.outfitSemiB(fs: 18, w: 600),
                      ),
                    ),
                  ],
                )
              : Text(
                  title.capEachWord(),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TxtStyle.outfitSemiB(fs: 18, w: 600),
                )),

      actions: [
        expandTitle == true && suffix == null
            ? const SizedBox(width: 10)
            : Padding(
                padding: EdgeInsets.only(right: 20.w),
                child: suffix ?? SizedBox(width: 40.w),
              ),
      ],

      toolbarHeight: 40.h,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(40.h);
}

class CommunityTopbarContent extends StatelessWidget {
  final Widget? suffix;
  final VoidCallback? onTapBack;
  final bool? isBgTransp;

  const CommunityTopbarContent({
    super.key,
    this.suffix,
    this.onTapBack,
    this.isBgTransp,
  });

  @override
  Widget build(BuildContext context) {
    final finalBg = isBgTransp == true ? ctransp : bgClr;
    return Container(
      color: ctransp,
      padding: const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 10),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          BackArrowInCircle(
            onTap:
                onTapBack ??
                () {
                  Get.offAllNamed(RoutePaths.mainNav);
                  MainNavController.to.goToTab(3);
                },
          ),

          suffix ?? const SizedBox(width: 40),
        ],
      ),
    );
  }
}
