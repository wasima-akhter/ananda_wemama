import '../../../../app/helper_widgets_export.dart';

class HomeSupplierItem extends StatelessWidget {
  final bool? hasShadow;
  final Color? brdrClr;
  final Color? titleTxtClr;

  final String name;
  final String location;
  final String fuelRate;
  final String dieselRate;
  const HomeSupplierItem({
    super.key,
    this.hasShadow,
    this.brdrClr,
    this.titleTxtClr,
    required this.name,
    required this.location,
    required this.fuelRate,
    required this.dieselRate,
  });

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      // contClr: Colors.grey.shade100,
      hasBrdr: true,
      hp: 15,
      vp: 15,
      brdrClr: brdrClr,
      brdrW: 1.2,
      boxShadow: hasShadow == true ? boxShadowAllSides : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name.capEachWord(), style: componentTxtStyle),
                Gap(itemGap),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgIconColored(
                      iconPath: IconsPath.locationBold,
                      height: 24,
                      iconColor: grey200,
                    ),
                    Expanded(
                      child: TextFit(
                        location.capEachWord(),
                        maxLines: null,
                        overflow: TextOverflow.visible,
                        style: TxtStyle.inter(fs: 12, color: greyLoc),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(flex: 1, child: Container()),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Strings.diesel, style: TxtStyle.inter(fs: 12)),

                Text(
                  Strings.currency + " " + dieselRate,
                  style: TxtStyle.inter(fs: 12, w: 700, color: c.primary),
                ),
                Gap(itemGap),

                Text(Strings.fuel, style: TxtStyle.inter(fs: 12)),

                Text(
                  Strings.currency + " " + fuelRate,
                  style: TxtStyle.inter(fs: 12, w: 700, color: c.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    ).mB(12);
  }
}
