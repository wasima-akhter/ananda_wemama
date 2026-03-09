import 'package:mama_app/core/common_widgets/small_popup_dialog.dart';

import '../../../app/helper_widgets_export.dart';

class LockCommentPopup extends StatelessWidget {
  const LockCommentPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return SmallPopupDialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.lock.capEachWord(),
            style: TxtStyle.interSemiB(fs: 18, w: 700, color: c.primary),
          ),
          Gap(4),
          Text(Strings.commentLocked, style: TxtStyle.inter(fs: 12, color: c.primary)),
        ],
      ),
    );
  }
}
