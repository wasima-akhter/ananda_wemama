import 'package:flexible_dropdown/flexible_dropdown.dart';

import '../../../../../app/helper_widgets_export.dart';

class CusFlexibleDropdown extends StatefulWidget {
  final Widget child;
  final List<CusDropdownItem> items;
  final double? width;
  final Widget? customOverlay;
  final Offset? offset;
  final ValueNotifier<bool>? closeNotifier;

  const CusFlexibleDropdown({
    super.key,
    required this.child,
    required this.items,
    this.width,
    this.customOverlay,
    this.offset,
    this.closeNotifier,
  });

  @override
  State<CusFlexibleDropdown> createState() => _CusFlexibleDropdownState();
}

class _CusFlexibleDropdownState extends State<CusFlexibleDropdown> {
  // Store the navigator that pushed the overlay route so we can pop it
  NavigatorState? _dropdownNavigator;

  @override
  void initState() {
    super.initState();
    widget.closeNotifier?.addListener(_onCloseRequested);
  }

  @override
  void didUpdateWidget(CusFlexibleDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.closeNotifier != widget.closeNotifier) {
      oldWidget.closeNotifier?.removeListener(_onCloseRequested);
      widget.closeNotifier?.addListener(_onCloseRequested);
    }
  }

  @override
  void dispose() {
    widget.closeNotifier?.removeListener(_onCloseRequested);
    super.dispose();
  }

  void _onCloseRequested() {
    _dropdownNavigator?.maybePop();
    _dropdownNavigator = null;
  }

  @override
  Widget build(BuildContext context) {
    return FlexibleDropdown(
      overlayChild:
          widget.customOverlay ??
          UnconstrainedBox(
            child: Container(
              padding: 6.pa,
              decoration: BoxDecoration(
                color: c.scaffoldBackground,
                borderRadius: 10.brdrRad,
                boxShadow: boxShadowAllSides,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.items.map((item) {
                  return InkWell(
                    onTap: () {
                      _onCloseRequested(); // ← use pop, not Get.back()
                      item.onTap?.call();
                    },
                    borderRadius: 6.brdrRad,
                    child: ContainerBordered(
                      vp: 5,
                      hp: 6,
                      rad: 8,
                      contClr: ctransp,
                      child: Row(
                        children: [
                          if (item.icon != null) ...[item.icon!, Gap(10.w)],
                          Text(
                            item.title,
                            style:
                                item.textStyle ??
                                TxtStyle.outfit(fs: 13, w: 500),
                            overflow: TextOverflow.clip,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
      barrierColor: black.withOpacity(0.15),
      barrierShape: BarrierShape.normal,
      offset: widget.offset ?? const Offset(0, 8),
      duration: const Duration(milliseconds: 200),

      // Capture the navigator when overlay opens
      onOpened: () {
        _dropdownNavigator = Navigator.of(context, rootNavigator: true);
      },
      // Clear reference when it closes naturally (barrier tap, etc.)
      onClosed: () {
        _dropdownNavigator = null;
      },
      borderRadius: 30.brdrRad,
      child: widget.child,
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
