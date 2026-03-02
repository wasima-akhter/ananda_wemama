import 'package:mama_app/app/helper_widgets_export.dart';
import 'package:mama_app/core/enums/app_enums.dart';
import 'package:mama_app/gen/assets.gen.dart';

class CusSearchBar extends StatelessWidget {
  final void Function()? onTap;
  const CusSearchBar({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double itemGap = 1.sh * 0.01;

    return ContainerBordered(
      hasBrdr: true,

      contClr: c.textSecondary,
      hp: 14,
      // brdrW: 0.6,
      brdrClr: c.inputBorder,
      vp: 0,
      child: Row(
        children: [
          Container(
            height: 50,
            decoration: BoxDeco.decBrdrOneSideCustom(
              side: BrdrSideType.right,
              brdrClr: c.inputBorder,
            ),
            child: Row(
              children: [
                ContainerBordered(
                  rad: 8,

                  child: Row(
                    children: [
                      SvgIcon(iconPath: Assets.icons.locationBold),
                      Gap(itemGap * 0.4),
                      Container(
                        constraints: BoxConstraints(maxWidth: S.w * 0.13),
                        margin: const EdgeInsets.only(right: 8),
                        child: TextFit(
                          Strings.fakeLocationName,
                          style: TxtStyle.inter(color: c.primary, w: 600),
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: CusNameTypeTextFormField(
              isNoBrder: true,
              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
              hintStyle: TxtStyle.inter(color: grey200),
              suffix: SvgIcon(iconPath: Assets.icons.search).mR(5),
              suffixSize: 20,
              controller: TextEditingController(),
              onTap: onTap,
              hintText: Strings.searchSupplies,
            ),
          ),
        ],
      ),
    );
  }
}
