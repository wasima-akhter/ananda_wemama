import '../../../../app/helper_widgets_export.dart';
import '../buttons/back_arrow_in_circle.dart';

class CommonAppBarContent extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? suffix;
  final VoidCallback? onTapBack;
  final bool? hasBackNavArrow;
  final bool? isBgTransp;
  final bool? titleInLeft;
  final Widget? titleLeftWidget;
  final Widget? titleWidget;

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
  });

  @override
  Widget build(BuildContext context) {
    final finalBg = isBgTransp == true ? ctransp : bgClr;
    return AppBar(
      backgroundColor: finalBg,
      leading: SizedBox.shrink(),

      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            // color: Colors.amber,
            color: finalBg,
          ),
          padding: EdgeInsets.only(top: 30.h, left: 20.w, right: 20.w, bottom: 10.h),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (hasBackNavArrow == null)
                BackArrowInCircle(onTap: onTapBack ?? () => GNav.pop())
              else if (hasBackNavArrow == false)
                SizedBox(width: 40.w),

              Expanded(
                child:
                    titleWidget ??
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: titleInLeft == true
                              ? Row(
                                  children: [
                                    titleLeftWidget ?? const SizedBox.shrink(),

                                    Text(
                                      title.capEachWord(),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      textAlign: TextAlign.left,
                                      style: 18.titleMclrCusFSOutfit,
                                    ),
                                  ],
                                )
                              : Text(
                                  title.capEachWord(),
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: 18.titleMclrCusFSOutfit,
                                ),
                        ),
                      ],
                    ),
              ),
              suffix ?? Container(width: 40.w),
            ],
          ),
        ),
      ),
      toolbarHeight: 60.h,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60.h);
}

class AppBarLikeTitle extends StatelessWidget {
  final String title;
  const AppBarLikeTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TxtStyle.fs18,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      textAlign: TextAlign.center,
    );
  }
}

class CommunityTopbarContent extends StatelessWidget {
  final Widget? suffix;
  final VoidCallback? onTapBack;
  final bool? isBgTransp;

  const CommunityTopbarContent({super.key, this.suffix, this.onTapBack, this.isBgTransp});

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
          BackArrowInCircle(onTap: onTapBack ?? () => GNav.pop()),

          suffix ?? const SizedBox(width: 40),
        ],
      ),
    );
  }
}
