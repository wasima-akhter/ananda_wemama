import 'package:mama_app/app/helper_widgets_export.dart';

class CusSearchBar extends StatelessWidget {
  final void Function()? onTap;
  final TextEditingController controller;
  final FocusNode focusNode;
  const CusSearchBar({super.key, this.onTap, required this.controller, required this.focusNode});

  @override
  Widget build(BuildContext context) {
    return CusNameTypeTextFormField(
      rad: 30,
      isNoBrder: false,
      brdrClr: c.inputBorder,
      fillColor: c.inputBackground,
      focusNode: focusNode,
      contentPadding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 8.w),
      prefix: SvgIcon(iconPath: IconsPath.search, height: 20).mL(15),
      prefixSize: 22.h,
      controller: controller,
      onTap: onTap,
      hintText: Strings.search.cap,
      hintStyle: TxtStyle.outfitSmTitle,
    );
  }
}
