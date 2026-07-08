import '../../../app/helper_widgets_export.dart';
import '../../../core/components/ui/helpers/visibility_suffix.dart';
import '../../../core/components/ui/inputs/cus_pass_type_text_form_field.dart';
import '../../../core/utils/validator/validators.dart';

class AuthFormEmailField extends StatelessWidget {
  final TextEditingController emailCtrler;
  final FocusNode emailFocus;
  final String? hintText;
  const AuthFormEmailField({
    super.key,
    required this.emailCtrler,
    required this.emailFocus,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return CusNameTypeTextFormField(
      controller: emailCtrler,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 14.w,
        vertical: ScreenSize.isSmallWidth ? 12.h : 14.h,
      ),
      fillColor: inputBgClr,
      brdrClr: newBorderClr,
      hintStyle: TxtStyle.poppinsSemiBold12Center(),
      style: TxtStyle.poppins(),

      hintText: hintText ?? Strings.email,
      prefix: SvgIcon(
        iconPath: IconsPath.email,
        height: 22,
      ).mOnly(left: 15, right: 6),

      prefixSize: 34,
      brdrW: 1,

      rad: 12,

      focusNode: emailFocus,
      validator: validateEmail,
    );
  }
}

class AuthFormPasswordField extends StatelessWidget {
  final TextEditingController passwordCtrler;
  final FocusNode passwordFocus;
  final bool isPasswordHidden;
  final VoidCallback togglePasswordVisibility;
  final String passwordIcon;
  final String? hintText;

  const AuthFormPasswordField({
    super.key,
    required this.passwordCtrler,
    required this.passwordFocus,
    required this.isPasswordHidden,
    required this.togglePasswordVisibility,
    required this.passwordIcon,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return CusPassTypeTextFormField(
      hintStyle: TxtStyle.poppinsSemiBold12Center(),
      style: TxtStyle.poppins(),
      fillColor: inputBgClr,
      brClr: newBorderClr,

      controller: passwordCtrler,
      focusNode: passwordFocus,

      hintText: hintText ?? Strings.password,

      prefix: SvgIcon(
        iconPath: IconsPath.lock,
        height: 22,
      ).mOnly(left: 15, right: 6),

      prefixSize: 34,

      obscureText: isPasswordHidden,

      suffix: VisibilitySuffix(
        onTap: togglePasswordVisibility,
        icon: passwordIcon,
      ),

      validator: validatePassword,
    );
  }
}

class AuthFormNameField extends StatelessWidget {
  final TextEditingController nameCtrler;
  final FocusNode nameFocus;
  final String? hintText;
  final String? label;
  final Color? hintColor;
  final double? rad;
  const AuthFormNameField({
    super.key,
    required this.nameCtrler,
    required this.nameFocus,
    this.hintText,
    this.label,
    this.hintColor,
    this.rad,
  });

  @override
  Widget build(BuildContext context) {
    return CusNameTypeTextFormField(
      h: 40.h,
      label: label,
      controller: nameCtrler,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 14.w,
        vertical: ScreenSize.isSmallWidth ? 12.h : 14.h,
      ),
      fillColor: inputBgClr,
      brdrClr: newBorderClr,
      hintStyle: TxtStyle.poppinsSemiBold12Center(color: hintColor),
      style: TxtStyle.poppins(),

      hintText: hintText ?? Strings.enterYourFirstName,
      brdrW: 1,

      rad: rad ?? 12,

      focusNode: nameFocus,
      validator: null,
    );
  }
}
