import 'package:we_mama/app/helper_widgets_export.dart';

class CusDesTypeTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final Widget? suffix;
  final Widget? prefix;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final double? maxHeight;
  final double? minHeight;
  final double? thickness;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final FocusNode? focusNode;
  final int? minLines;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final bool? readOnly;
  final bool? isNoBrder;
  final bool? isReq;
  final bool? isPaddingLess;
  final Color? brdrClr;
  final Color? bgClr;
  final double? rad;

  const CusDesTypeTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.suffix,
    this.prefix,
    this.hintStyle,
    this.style,
    this.maxHeight,
    this.minHeight,
    this.thickness,
    this.contentPadding,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.focusNode,
    this.minLines,
    this.onTap,
    this.onChanged,
    this.readOnly,
    this.isNoBrder,
    this.isReq,
    this.brdrClr,
    this.rad,
    this.bgClr,
    this.isPaddingLess,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: (maxHeight ?? 120).h,
        minHeight: (minHeight ?? 80).h,
      ),
      child: Scrollbar(
        thickness: thickness?.w ?? 0,
        interactive: thickness != null,
        radius: thickness != null ? Radius.circular(4.r) : null,
        child: TextFormField(
          controller: controller,
          readOnly: readOnly ?? false,
          focusNode: focusNode,
          keyboardType: TextInputType.multiline,
          style: style ?? TxtStyle.outfit(fs: 14),
          maxLines: null,
          minLines: minLines ?? 3,
          textInputAction: TextInputAction.newline,
          //
          cursorColor: c.primary,
          decoration: InputDecoration(
            filled: true,
            fillColor: bgClr ?? c.inputBackground, // background color
            contentPadding:
                contentPadding ??
                (isPaddingLess == true
                    ? EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h)
                    : EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h)),
            hint: Text(
              hintText,
              style:
                  hintStyle ??
                  TxtStyle.outfit(
                    fs: 13,
                    color: c.foregroundPrimary.withOpacity(0.6),
                  ),
            ),
            suffixIcon: suffix,

            prefix: prefix,
            focusedBorder: isNoBrder == true
                ? InputBorder.none
                : OutlineInputBorder(
                    borderSide: BorderSide(
                      color: brdrClr ?? newBorderClr2_30,
                      width: brdrClr != null ? 0.5 : 1.5,
                    ),
                    borderRadius: (rad ?? 30).brdrRad,
                  ),
            errorBorder:
                errorBorder ??
                (isNoBrder == true
                    ? InputBorder.none
                    : OutlineInputBorder(
                        borderSide: BorderSide(color: c.error, width: 1.5),
                        borderRadius: (rad ?? 30).brdrRad,
                      )),
            focusedErrorBorder: isNoBrder == true
                ? InputBorder.none
                : OutlineInputBorder(
                    borderSide: BorderSide(color: c.error, width: 1.5),
                    borderRadius: (rad ?? 30).brdrRad,
                  ),

            enabledBorder: isNoBrder == true
                ? InputBorder.none
                : OutlineInputBorder(
                    borderSide: BorderSide(
                      color: brdrClr ?? c.inputBorder,
                      width: brdrClr != null ? 0.8 : 1.5,
                    ),
                    borderRadius: (rad ?? 30).brdrRad,
                  ),
          ),
          onChanged: onChanged,
          validator: validator,
          onTap: onTap,
        ),
      ),
    );
  }
}
