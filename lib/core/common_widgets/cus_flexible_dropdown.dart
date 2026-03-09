import 'package:flexible_dropdown/flexible_dropdown.dart';

import '../../../app/helper_widgets_export.dart';

class CusFlexibleDropdown extends StatelessWidget {
  /// Widget that opens the dropdown
  final Widget child;

  /// List of menu items
  final List<CusDropdownItem> items;

  /// Optional width override
  final double? width;

  const CusFlexibleDropdown({super.key, required this.child, required this.items, this.width});

  @override
  Widget build(BuildContext context) {
    return FlexibleDropdown(
      overlayChild: IntrinsicWidth(
        child: Container(
          width: width,
          padding: 6.pa,
          decoration: BoxDecoration(
            color: c.scaffoldBackground,
            borderRadius: 10.brdrRad,
            boxShadow: boxShadowAllSides,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: items.map((item) {
              return InkWell(
                onTap: () {
                  Get.back(); // close dropdown
                  item.onTap?.call();
                },
                borderRadius: 6.brdrRad,
                child: ContainerBordered(
                  vp: 5,
                  hp: 14,
                  rad: 8,
                  mv: 2,
                  contClr: ctransp,
                  child: Row(
                    children: [
                      if (item.icon != null) ...[item.icon!, Gap(10.w)],
                      Expanded(
                        child: Text(
                          item.title,
                          style: item.textStyle ?? TxtStyle.outfit(fs: 13, w: 500),
                        ),
                      ),
                    ],
                  ),
                ).mR(22),
              );
            }).toList(),
          ),
        ),
      ),

      barrierColor: black.withOpacity(0.15), // ← light shaded dismissable overlay

      barrierShape: BarrierShape.normal,
      offset: const Offset(0, 8),
      duration: const Duration(milliseconds: 200),

      child: child, // 👈 Fully customizable trigger
    );
  }
}

class CusDropdownItem {
  final String title;
  final VoidCallback? onTap;
  final Widget? icon;
  final TextStyle? textStyle;

  CusDropdownItem({required this.title, this.onTap, this.icon, this.textStyle});
}
