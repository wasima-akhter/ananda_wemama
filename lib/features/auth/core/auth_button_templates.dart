import '../../../app/helper_widgets_export.dart';

class AuthButton extends StatelessWidget {
  final bool isLoading;
  final void Function()? onTap;
  final String? btnText;

  final BtnVariant? variant;
  final double? fs;

  const AuthButton({
    super.key,
    required this.isLoading,
    this.onTap,
    this.btnText,
    this.fs,
    this.variant,
  });

  @override
  Widget build(BuildContext context) {
    final bool small = ScreenSize.isSmallWidth;

    final double fontSize = fs ?? (small ? 14 : 14);

    return CustomBtnWTxtNew(
      btnTxt: btnText ?? Strings.continueTxt,
      variant: variant ?? BtnVariant.primary,
      fs: fontSize,
      isLoading: isLoading,
      onTap: onTap,
    );
  }
}

// class IconTextButton extends StatelessWidget {
//   const IconTextButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return CustomBtnWIcon(
//       onTap: onTap,
//       text: text,
//       bgColor: bgColor,
//       textColor: textColor,
//       iconPath: iconPath,
//     );
//   }
// }
