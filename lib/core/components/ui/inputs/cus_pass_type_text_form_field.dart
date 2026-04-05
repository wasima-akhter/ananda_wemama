import 'package:mama_app/app/helper_widgets_export.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap,
      focusNode: focusNode,
      controller: controller,
      obscureText: obscureText ?? false,
      keyboardType: keyboardType ?? TextInputType.text,
      style: TxtStyle.outfit(color: c.primary),
      autofillHints: const [AutofillHints.password],
      decoration: InputDecoration(
        filled: true,
        fillColor: c.inputBackground,
        hintText: hintText,
        hintStyle: TxtStyle.outfit(fs: 13, color: c.primary, w: hintW ?? 500),
        isDense: false, // important
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
        focusedBorder: isNoBrder == true
            ? InputBorder.none
            : OutlineInputBorder(
                borderSide: BorderSide(color: c.inputBorder, width: 1.5),
                borderRadius: 30.brdrRad,
              ),
        errorBorder: isNoBrder == true
            ? InputBorder.none
            : OutlineInputBorder(
                borderSide: BorderSide(color: c.error, width: 1.5),
                borderRadius: 30.brdrRad,
              ),
        focusedErrorBorder: isNoBrder == true
            ? InputBorder.none
            : OutlineInputBorder(
                borderSide: BorderSide(color: c.error, width: 1.5),
                borderRadius: 30.brdrRad,
              ),
        enabledBorder: isNoBrder == true
            ? InputBorder.none
            : (isUnderLineBrdr == true
                  ? UnderlineInputBorder(
                      borderSide: BorderSide(color: c.inputBorder, width: 1),
                      borderRadius: 30.brdrRad,
                    )
                  : OutlineInputBorder(
                      borderSide: BorderSide(color: c.inputBorder, width: 0.8),
                      borderRadius: 30.brdrRad,
                    )),
        suffixIcon: suffix,
        prefixIcon: prefix,
        prefixIconConstraints: BoxConstraints(
          minWidth: prefixSize ?? 48,
          minHeight: prefixSize ?? 48,
        ),
      ),
      onChanged: (value) => debugPrint(value),
      validator: validator,
    );
  }
}
