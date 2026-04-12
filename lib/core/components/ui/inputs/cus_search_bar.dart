import 'package:mama_app/app/helper_widgets_export.dart';

class CusSearchBar extends StatelessWidget {
  final void Function()? onTap;
  final Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final TextEditingController controller;
  final FocusNode focusNode;
  final double? rad;
  final Color? fillColor;
  const CusSearchBar({
    super.key,
    this.onTap,
    required this.controller,
    required this.focusNode,
    this.onChanged,
    this.onEditingComplete,
    this.rad,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return CusNameTypeTextFormField(
      rad: rad ?? 30,
      isNoBrder: false,
      brdrClr: c.inputBorder,
      fillColor: fillColor ?? c.inputBackground,
      focusNode: focusNode,
      contentPadding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 8.w),
      prefix: SvgIcon(iconPath: IconsPath.search, height: 20).mL(12),
      prefixSize: 22.h,
      controller: controller,
      onTap: onTap,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      hintText: Strings.search.cap,
      hintStyle: TxtStyle.outfitSmSecNor,
    );
  }
}
