import '../../app/helper_widgets_export.dart';
import 'back_arrow_in_circle.dart';

class CommonAppBarContent extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? suffix;
  final VoidCallback? onTapBack;
  final bool? hasBackNavArrow;
  final bool? isBgTransp;

  const CommonAppBarContent({
    super.key,
    required this.title,
    this.suffix,
    this.onTapBack,
    this.hasBackNavArrow,
    this.isBgTransp,
  });

  @override
  Widget build(BuildContext context) {
    final finalBg = isBgTransp == true ? ctransp : bgClr;
    return AppBar(
      backgroundColor: finalBg,
      leading: SizedBox.shrink(),

      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: finalBg,
          padding: const EdgeInsets.only(top: 30, left: 25, right: 25, bottom: 10),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (hasBackNavArrow == null)
                BackArrowInCircle(onTap: onTapBack ?? () => GNav.pop())
              else if (hasBackNavArrow == false)
                const SizedBox(width: 40),

              Expanded(
                child: Text(
                  title.capEachWord(),
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: 18.titleMclrCusFSOutfit,
                ),
              ),

              suffix ?? const SizedBox(width: 40),
            ],
          ),
        ),
      ),
      toolbarHeight: 80,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
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
