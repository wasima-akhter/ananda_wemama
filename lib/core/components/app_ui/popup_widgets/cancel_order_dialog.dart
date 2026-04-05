import '../../../../app/helper_widgets_export.dart';

class CancelOrderDialog extends StatelessWidget {
  final bool isLoading;
  final Future<void> Function() onCancelOrder;

  const CancelOrderDialog({super.key, required this.isLoading, required this.onCancelOrder});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 35.w, horizontal: 20.w),
      decoration: BoxDeco.decRadiusAll(20, clr: bgClr),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Gap(itemGap * 2),

          SvgIcon(iconPath: IconsPath.closeRed, height: 48),
          Gap(itemGap * 3),

          Text(Strings.areYouSure, style: TxtStyle.inter(fs: 18, w: 600, color: c.primary)),
          Gap(itemGap),

          Text(
            "Do You Want To Cancel".cap,
            textAlign: TextAlign.center,
            style: TxtStyle.inter(w: 600),
          ),
          Gap(itemGap * 6),

          CustomBtnWTxt(
            btnColor: c.primary,
            borderClr: c.primary,
            txtClr: c.textSecondary,
            btnTxt: Strings.cancel,
            isLoading: isLoading,

            onTap: onCancelOrder,
          ),
          Gap(itemGap * 2),
        ],
      ),
    );
  }
}
