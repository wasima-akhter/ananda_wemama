import '../../../../app/helper_widgets_export.dart';

class LockCommentPopup extends StatelessWidget {
  final bool isLocked;
  const LockCommentPopup({super.key, required this.isLocked});

  @override
  Widget build(BuildContext context) {
    return SmallPopupDialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            (isLocked ? Strings.unlock : Strings.lock).capEachWord(),
            style: TxtStyle.interSemiB(fs: 18, w: 700, color: c.primary),
          ),
          Gap(4),
          Text(
            isLocked ? Strings.commentUnlocked : Strings.commentLocked,
            style: TxtStyle.inter(fs: 12, color: c.primary),
          ),
        ],
      ),
    );
  }
}
