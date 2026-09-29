import 'package:flutter/services.dart';
import 'package:we_mama/app/helper_widgets_export.dart';

class CusNameTypeTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool? isUnderLineBrdr;
  final bool? isNoBrder;
  final bool? readOnly;
  final Widget? suffix;
  final Widget? prefix;
  final Widget? hint;
  final double? h;
  final double? rad;
  final double? brdrW;
  final bool? isDense;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final EdgeInsetsGeometry? contentPadding;
  final FocusNode? focusNode;
  final InputBorder? errorBorder;
  final Color? brdrClr;
  final Color? txtClr;
  final Color? fillColor;
  final double? fs;
  final RegExp? regExp;
  final double? prefixSize;
  final double? suffixSize;
  final TextInputAction? textInputAction;
  final int? hintW;
  final double? cursorHeight;
  final double? cursorWidth;
  final TextAlign? textAlign;
  final String? label;

  const CusNameTypeTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.validator,
    this.isUnderLineBrdr,
    this.suffix,
    this.prefix,
    this.hintStyle,
    this.readOnly,
    this.onTap,
    this.style,
    this.hint,
    this.onChanged,
    this.isNoBrder,
    this.contentPadding,
    this.focusNode,
    this.errorBorder,
    this.h,
    this.brdrClr,
    this.isDense,
    this.fs,
    this.txtClr,
    this.regExp,
    this.textInputAction,
    this.prefixSize,
    this.hintW,
    this.suffixSize,
    this.cursorHeight,
    this.cursorWidth,
    this.textAlign,
    this.rad,
    this.brdrW,
    this.fillColor,
    this.onEditingComplete,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //label text
        if (label != null && label!.isNotEmpty) ...[
          Text(
            label ?? '',
            style: TxtStyle.poppinsSemiB(w: 600, ls: 0.64, fs: 14),
          ),

          Gap(10.h),
        ],
        //
        Container(
          height: h,
          decoration: BoxDecoration(borderRadius: (rad ?? 30).r.brdrRad),
          child: TextFormField(
            controller: controller,
            textInputAction: textInputAction ?? TextInputAction.done,
            textAlign: textAlign ?? TextAlign.start,
            focusNode: focusNode,
            inputFormatters: regExp != null
                ? <TextInputFormatter>[
                    FilteringTextInputFormatter.deny(regExp!),
                  ]
                : [],
            keyboardType: keyboardType ?? TextInputType.text,
            style: style ?? TxtStyle.outfit(fs: 14),
            readOnly: readOnly ?? false,
            autofillHints: keyboardType == TextInputType.emailAddress
                ? [AutofillHints.email]
                : [AutofillHints.name],
            scrollController: ScrollController(),
            cursorWidth: cursorWidth ?? 1,
            cursorColor: c.textPrimary,
            cursorHeight: cursorHeight ?? 18.h,

            decoration: InputDecoration(
              filled: true,
              fillColor: fillColor ?? c.inputBackground,
              contentPadding:
                  contentPadding ??
                  EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
              isDense: isDense, // reduces default vertical padding
              hint:
                  hint ??
                  Text(
                    hintText,
                    style:
                        hintStyle ?? TxtStyle.outfit(fs: 13, w: hintW ?? 500),
                  ),

              suffixIcon: suffix,
              prefixIcon: prefix,
              prefixIconConstraints: BoxConstraints(
                minWidth: (prefixSize ?? 48).w, // default is 48
                minHeight: (prefixSize ?? 48).h,
              ),
              suffixIconConstraints: BoxConstraints(
                minWidth: (suffixSize ?? 48).w, // default is 48
                minHeight: (suffixSize ?? 48).h,
              ),

              focusedBorder: isNoBrder == true
                  ? InputBorder.none
                  : OutlineInputBorder(
                      borderSide: BorderSide(
                        color: brdrClr ?? c.inputBorder,
                        width: brdrW ?? (brdrClr != null ? 0.8 : 1.5),
                      ),
                      borderRadius: (rad ?? 30).brdrRad,
                    ),
              errorBorder:
                  errorBorder ??
                  (isNoBrder == true
                      ? InputBorder.none
                      : OutlineInputBorder(
                          borderSide: BorderSide(
                            color: c.error,
                            width: brdrW ?? (brdrClr != null ? 0.8 : 1.5),
                          ),
                          borderRadius: (rad ?? 30).brdrRad,
                        )),
              focusedErrorBorder: isNoBrder == true
                  ? InputBorder.none
                  : OutlineInputBorder(
                      borderSide: BorderSide(
                        color: c.error,
                        width: brdrW ?? (brdrClr != null ? 0.8 : 1.5),
                      ),
                      borderRadius: (rad ?? 30).brdrRad,
                    ),

              enabledBorder: isNoBrder == true
                  ? InputBorder.none
                  : OutlineInputBorder(
                      borderSide: BorderSide(
                        color: brdrClr ?? c.inputBorder,
                        width: brdrW ?? (brdrClr != null ? 0.8 : 1.5),
                      ),
                      borderRadius: (rad ?? 30).brdrRad,
                    ),
            ),
            onChanged: onChanged,
            validator: validator,
            onTap: onTap,
            // ✅ ADD THIS: Prevents text from being submitted/cleared when keyboard closes
            onEditingComplete:
                onEditingComplete ??
                () {
                  // Do nothing - just prevent default behavior
                  print('controller.text: ${controller.text}');
                },
          ),
        ),
      ],
    );
  }
}
