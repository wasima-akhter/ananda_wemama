import 'package:mama_app/app/helper_widgets_export.dart';

class CusSearchBar extends StatelessWidget {
  final void Function()? onTap;
  final TextEditingController controller;
  const CusSearchBar({super.key, this.onTap, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      hasBrdr: true,

      contClr: c.inputBackground,
      hp: 14,
      rad: 30,
      brdrClr: c.inputBorder,
      vp: 0,
      child: Row(
        children: [
          Expanded(
            child: CusNameTypeTextFormField(
              isNoBrder: true,
              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
              prefix: SvgIcon(iconPath: IconsPath.search),
              prefixSize: 22,
              controller: controller,
              onTap: onTap,
              hintText: Strings.search.cap,
              hintStyle: TxtStyle.outfitSmTitle,
            ),
          ),
        ],
      ),
    );
  }
}
