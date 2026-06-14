import '../../../app/helper_widgets_export.dart';

class AuthButton extends StatelessWidget {
  final bool isLoading;
  final void Function()? onTap;
  final String? btnText;

  const AuthButton({
    super.key,
    required this.isLoading,
    this.onTap,
    this.btnText,
  });

  @override
  Widget build(BuildContext context) {
    return CustomBtnWTxtNew(
      btnTxt: btnText ?? Strings.continueTxt,
      fs: ScreenSize.isSmallWidth ? 14 : 14,
      btnColor: c.strokePrimary,
      txtClr: c.backgroundPrimary,
      isLoading: isLoading,
      onTap: onTap,
    );
  }
}
