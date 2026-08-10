import 'package:we_mama/app/helper_widgets_export.dart';

class CusSearchBar extends StatelessWidget {
  final void Function()? onTap;
  final Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final void Function()? onClear;
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
    this.onClear,
    this.rad,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return CusNameTypeTextFormField(
          rad: rad ?? 30,
          h: 36.h,
          isNoBrder: false,
          brdrClr: c.inputBorder,
          fillColor: fillColor ?? c.inputBackground,
          focusNode: focusNode,
          contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
          prefix: SvgIcon(iconPath: IconsPath.search, height: 20).mL(12),
          prefixSize: 22,
          suffix: controller.text.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18),
                  onPressed: () {
                    controller.clear();
                    onClear?.call();
                  },
                ),
          controller: controller,
          onTap: onTap,
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
          hintText: Strings.search.cap,
          hintStyle: TxtStyle.outfitSmSecNor,
        );
      },
    );
  }
}
