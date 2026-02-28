import '../../app/helper_widgets_export.dart';
import 'back_arrow_in_circle.dart';

class CommonAppBarContent extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? suffix;
  final VoidCallback? onTapBack;
  final bool? hasBackNavArrow;

  const CommonAppBarContent({
    super.key,
    required this.title,
    this.suffix,
    this.onTapBack,
    this.hasBackNavArrow,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: bgClr,
      leading: SizedBox.shrink(),

      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: bgClr,
          padding: const EdgeInsets.only(top: 30, left: 25, right: 25),
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
                  title,
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
      toolbarHeight: 60,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
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
