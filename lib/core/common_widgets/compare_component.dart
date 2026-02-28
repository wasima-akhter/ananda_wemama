import 'package:mama_app/core/common_widgets/gesture_detector_cus.dart';

import '../../app/helper_widgets_export.dart';

/// Fuel / Diesel toggle with optional comparison content
class FuelDieselCompareComp extends StatelessWidget {
  final RxBool isLeftSelected; // true = Fuel, false = Diesel
  final VoidCallback changeToOtherTab; // switches tab
  final bool? hasContent; // null = show stats, true = compact mode

  final LowestHighestBarModel? lowestData;
  final LowestHighestBarModel? highestData;

  const FuelDieselCompareComp({
    super.key,
    required this.isLeftSelected,
    required this.changeToOtherTab,
    this.hasContent,
    this.lowestData,
    this.highestData,
  });

  @override
  Widget build(BuildContext context) {
    final noContent = hasContent != null;

    return Obx(() {
      final isFuelSelected = isLeftSelected.value;

      return ContainerBordered(
        contClr: noContent ? null : c.primary,
        vp: noContent ? 0 : 15,
        hp: noContent ? 0 : 15,
        boxShadow: noContent ? null : boxShadow(),
        hasBrdr: noContent ? true : null,
        rad: 8,
        child: Column(
          children: [
            /// Top toggle (Fuel | Diesel)
            ContainerBordered(
              contClr: bgClr,
              rad: 8,
              vp: 3,
              hp: 3,
              child: Row(
                children: [
                  _tabButton(
                    title: Strings.fuel,
                    isSelected: isFuelSelected,
                    noContent: noContent,
                    onTap: isFuelSelected ? null : changeToOtherTab,
                  ),
                  _tabButton(
                    title: Strings.diesel,
                    isSelected: !isFuelSelected,
                    noContent: noContent,
                    onTap: !isFuelSelected ? null : changeToOtherTab,
                  ),
                ],
              ),
            ),

            /// Comparison bars (only when hasContent == null)
            if (!noContent) ...[
              Gap(itemGap * 2.5),
              if (lowestData != null)
                LowestHighestBar(
                  title: lowestData?.title ?? '',
                  name: lowestData?.name ?? '',
                  value: lowestData?.rate ?? '',
                ),
              Gap(itemGap * 1.5),
              if (highestData != null)
                LowestHighestBar(
                  title: highestData?.title ?? '',
                  name: highestData?.name ?? '',
                  value: highestData?.rate ?? '',
                ),
              Gap(itemGap * 1.5),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  Strings.ratPerLitter,
                  style: TxtStyle.inter(fs: 7, w: 600, color: c.textSecondary),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  /// Single tab button (Fuel/Diesel)
  Widget _tabButton({
    required String title,
    required bool isSelected,
    required bool noContent,
    required VoidCallback? onTap,
  }) {
    return Expanded(
      child: CusGestureDetector(
        onTap: onTap,
        child: ContainerBordered(
          vp: 12,
          rad: 8,
          contClr: _tabBackgroundColor(isSelected: isSelected, noContent: noContent),
          child: Text(
            title.cap,
            style: TxtStyle.inter(
              fs: 11,
              w: 600,
              color: _tabTextColor(isSelected: isSelected, noContent: noContent),
            ),
          ),
        ),
      ),
    );
  }

  /// Background color for tab
  Color _tabBackgroundColor({required bool isSelected, required bool noContent}) {
    if (noContent && isSelected) return lightGreenClr;
    if (isSelected) return c.primary;
    return bgClr;
  }

  /// Text color for tab
  Color _tabTextColor({required bool isSelected, required bool noContent}) {
    if (noContent && isSelected) return c.textPrimary;
    if (isSelected) return c.textSecondary;
    return greyLoc;
  }
}

/// Lowest / Highest price row
class LowestHighestBar extends StatelessWidget {
  final String title;
  final String name;
  final String value;

  const LowestHighestBar({super.key, required this.title, required this.name, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// Station info
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title.cap, style: TxtStyle.inter(fs: 11, color: c.textSecondary)),
              Gap(itemGap * 0.6),
              Text(name.capEachWord(), style: componentTxtStyle),
            ],
          ),
        ),
        Gap(itemGap),

        /// Price
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [Text(Strings.currency + " " + value, style: amountTxtStyle())],
          ),
        ),
      ],
    );
  }
}

/// Model for Lowest/Highest bar
class LowestHighestBarModel {
  final String title;
  final String name;
  final String rate;

  LowestHighestBarModel({required this.title, required this.name, required this.rate});
}
