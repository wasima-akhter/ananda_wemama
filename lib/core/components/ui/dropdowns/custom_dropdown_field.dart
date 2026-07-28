import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:we_mama/app/helper_widgets_export.dart';

enum DropdownSize { small, medium, large }

class CustomDropdownField<T> extends StatelessWidget {
  final String hintText;
  final List<T> items;
  final T? value;
  final String Function(T)? labelBuilder;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final bool isRequired;
  final Color? fillColor;
  final String? errorText;
  final bool enabled;
  final DropdownSize size;

  const CustomDropdownField({
    super.key,
    required this.hintText,
    required this.items,
    this.value,
    this.labelBuilder,
    this.onChanged,
    this.validator,
    this.isRequired = false,
    this.fillColor,
    this.errorText,
    this.enabled = true,
    this.size = DropdownSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final message = "Field Is Required";

    final validationFunction =
        validator ??
        (isRequired ? (val) => val == null ? message : null : null);

    final bool hasError = errorText != null && errorText!.isNotEmpty;

    /// -------- SIZE CONFIG --------
    double height;
    double fontSize;
    EdgeInsets padding;

    switch (size) {
      case DropdownSize.small:
        height = 36.h;
        fontSize = 12.sp;
        padding = EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h);
        break;

      case DropdownSize.medium:
        height = 44.h;
        fontSize = 14.sp;
        padding = EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h);
        break;

      case DropdownSize.large:
        height = 52.h;
        fontSize = 16.sp;
        padding = EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h);
        break;
    }

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: fillColor ?? c.inputBackground,
        borderRadius: 6.brdrRad,
        boxShadow: boxShadowAllSides,
      ),
      child: DropdownButtonFormField2<T>(
        isExpanded: true,
        value: items.contains(value) ? value : null,

        /// -------- INPUT --------
        decoration: InputDecoration(
          contentPadding: padding,

          border: OutlineInputBorder(
            borderRadius: 6.brdrRad,
            borderSide: BorderSide(
              color: hasError ? c.error : c.inputBorder,
              width: 0.7.w,
            ),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: 6.brdrRad,
            borderSide: BorderSide(color: c.inputBorder, width: 0.5.w),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: 6.brdrRad,
            borderSide: BorderSide(color: c.primary, width: 0.8.w),
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: 6.brdrRad,
            borderSide: BorderSide(color: c.error, width: 0.7.w),
          ),

          filled: true,
          fillColor: fillColor ?? c.inputBackground,

          errorText: errorText,
          errorStyle: TxtStyle.errTxt.copyWith(color: c.error),
        ),

        /// -------- HINT --------
        hint: Text(
          hintText,
          style: TxtStyle.outfit(fs: fontSize, color: c.textSecondary),
        ),

        /// -------- ITEMS --------
        items: items
            .map(
              (item) => DropdownMenuItem<T>(
                value: item,
                child: Text(
                  labelBuilder?.call(item) ?? item.toString(),
                  style: TxtStyle.outfit(fs: fontSize, w: 400),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(),

        onChanged: enabled ? onChanged : null,
        validator: validationFunction,

        style: TxtStyle.outfit(fs: fontSize, color: c.textSecondary),

        /// -------- BUTTON --------
        buttonStyleData: ButtonStyleData(
          height: height,
          padding: EdgeInsets.only(left: 6.w, right: 4.w),
        ),

        /// -------- ICON --------
        iconStyleData: IconStyleData(
          icon: Icon(Icons.keyboard_arrow_down, color: c.textSecondary),
          iconSize: (fontSize + 4).sp,
        ),

        /// -------- DROPDOWN --------
        dropdownStyleData: DropdownStyleData(
          maxHeight: S.h * 0.3,
          decoration: BoxDecoration(
            borderRadius: 8.brdrRad,
            color: c.scaffoldBackground,
            boxShadow: boxShadowAllSides,
          ),
        ),

        /// -------- MENU ITEM --------
        menuItemStyleData: MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        ),
      ),
    );
  }
}
