import '../../../../app/helper_widgets_export.dart';

class NotificationPermissionPopup extends StatelessWidget {
  final String title;
  final String body;
  final String confirmLabel;
  final String denyLabel;

  const NotificationPermissionPopup({
    super.key,
    required this.title,
    required this.body,
    required this.confirmLabel,
    required this.denyLabel,
  });

  @override
  Widget build(BuildContext context) {
    return SmallPopupDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: 16.pa,
            decoration: BoxDecoration(
              color: c.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_outlined,
              size: S.w * 0.12,
              color: c.primary,
            ),
          ),

          Gap(itemGap * 2),

          Text(
            title,
            style: TxtStyle.interSemiB(fs: 18, w: 700, color: c.primary),
            textAlign: TextAlign.center,
          ),

          Gap(6),

          Text(
            body,
            style: TxtStyle.inter(fs: 12, color: c.primary),
            textAlign: TextAlign.center,
          ),

          Gap(itemGap * 2),

          CustomBtnWTxt(
            isLoading: false,
            isSmall: true,
            btnTxt: confirmLabel,
            btnColor: c.primary,
            txtClr: white,
            rad: 12,
            padding: 12.pv,
            onTap: () {
              Get.back(result: true);
            },
          ),

          Gap(itemGap),

          TextButton(
            onPressed: () {
              Get.back(result: false);
            },
            child: Text(
              denyLabel,
              style: TxtStyle.inter(
                fs: 12,
                color: c.primary.withValues(alpha: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
