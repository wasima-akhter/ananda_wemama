import 'package:we_mama/app/helper_widgets_export.dart';

class CusPassTypeTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final bool? obscureText;
  final String? hintText;
  final Widget? suffix;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  final Function(String)? onFieldSubmitted;
  final bool? isUnderLineBrdr;
  final bool? isNoBrder; // ✅ Added
  final Widget? prefix;
  final int? hintW;
  final double? prefixSize;
  final Color? fillColor;
  final Color? brClr;
  final TextStyle? style;
  final TextStyle? hintStyle;

  const CusPassTypeTextFormField({
    super.key,
    required this.controller,
    this.obscureText,
    this.hintText,
    this.suffix,
    this.validator,
    this.keyboardType,
    this.onTap,
    this.onFieldSubmitted,
    this.isUnderLineBrdr,
    this.isNoBrder, // ✅ Added
    this.prefix,
    this.prefixSize,
    this.hintW,
    this.focusNode,
    this.fillColor,
    this.brClr,
    this.style,
    this.hintStyle,
  });

  @override
  Widget build(BuildContext context) {
    final borderColr = brClr ?? c.inputBorder;
    return TextFormField(
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap,
      focusNode: focusNode,
      controller: controller,
      obscureText: obscureText ?? false,
      keyboardType: keyboardType ?? TextInputType.text,
      style: style ?? TxtStyle.outfit(color: c.primary),
      autofillHints: const [AutofillHints.password],
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor ?? c.inputBackground,
        hintText: hintText,
        hintStyle:
            hintStyle ??
            TxtStyle.outfit(fs: 13, color: c.primary, w: hintW ?? 500),
        isDense: false, // important
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: ScreenSize.isSmallWidth ? 12.h : 14.h,
        ),
        focusedBorder: isNoBrder == true
            ? InputBorder.none
            : OutlineInputBorder(
                borderSide: BorderSide(color: borderColr, width: 1),
                borderRadius: 12.brdrRad,
              ),
        errorBorder: isNoBrder == true
            ? InputBorder.none
            : OutlineInputBorder(
                borderSide: BorderSide(color: c.error, width: 1),
                borderRadius: 12.brdrRad,
              ),
        focusedErrorBorder: isNoBrder == true
            ? InputBorder.none
            : OutlineInputBorder(
                borderSide: BorderSide(color: c.error, width: 1),
                borderRadius: 12.brdrRad,
              ),
        enabledBorder: isNoBrder == true
            ? InputBorder.none
            : (isUnderLineBrdr == true
                  ? UnderlineInputBorder(
                      borderSide: BorderSide(color: borderColr, width: 1),
                      borderRadius: 12.brdrRad,
                    )
                  : OutlineInputBorder(
                      borderSide: BorderSide(color: borderColr, width: 1),
                      borderRadius: 12.brdrRad,
                    )),
        suffixIcon: suffix,
        prefixIcon: prefix,
        prefixIconConstraints: BoxConstraints(
          minWidth: (prefixSize ?? 48).w,
          minHeight: (prefixSize ?? 48).h,
        ),
        suffixIconConstraints: BoxConstraints(
          minWidth: (prefixSize ?? 48).w,
          minHeight: (prefixSize ?? 48).h,
        ),
      ),
      onChanged: (value) => print(value),
      validator: validator,
    );
  }
}
