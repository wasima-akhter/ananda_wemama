import '../../../../app/helper_widgets_export.dart';

class FileSizeExceededPopup extends StatelessWidget {
  const FileSizeExceededPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return SmallPopupDialog(
      child: Column(
        children: [
          SvgIcon(iconPath: IconsPath.info, height: S.w * 0.18),

          Gap(itemGap * 2),

          Text(
            "File Too Large",
            style: TxtStyle.interSemiB(fs: 18, w: 700, color: c.primary),
          ),

          Gap(4),

          Text(
            "Please upload files smaller than 1 MB.",
            textAlign: TextAlign.center,
            style: TxtStyle.inter(fs: 12, color: c.primary),
          ),

          Gap(itemGap * 2),

          CustomBtnWTxt(
            isLoading: false,
            isSmall: true,
            btnTxt: "Okay",
            btnColor: c.primary,
            txtClr: white,
            rad: 12,
            onTap: () => Get.back(),
          ),
        ],
      ),
    );
  }
}
