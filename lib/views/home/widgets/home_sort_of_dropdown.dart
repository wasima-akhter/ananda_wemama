import 'package:flexible_dropdown/flexible_dropdown.dart';

import '../../../app/helper_widgets_export.dart';
import '../../../core/common_widgets/gesture_detector_cus.dart';
import '../../../core/enums/app_enums.dart';

class HomeSortOfDropdown extends StatelessWidget {
  final Rx<FuelType> selFuelType;
  final RxString? selCriteria;
  final void Function(FuelType)? onFuelChanged;
  final void Function(String criteria)? onSortChanged;

  const HomeSortOfDropdown({
    super.key,

    required this.selFuelType,
    this.selCriteria,
    this.onFuelChanged,
    this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      // contClr: greyLoc,
      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          FlexibleDropdown(
            // The button you tap to open the dropdown
            overlayChild: Obx(
              () => Container(
                width: S.w * 0.5,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Fuel radio row
                    Row(
                      children: [
                        CusGestureDetector(
                          onTap: () {
                            selFuelType.value = FuelType.fuel;
                            onFuelChanged?.call(FuelType.fuel);
                          },
                          child: Row(
                            children: [
                              Radio<FuelType>(
                                value: FuelType.fuel,
                                groupValue: selFuelType.value,
                                onChanged: (value) {
                                  selFuelType.value = FuelType.fuel;
                                  onFuelChanged?.call(FuelType.fuel);
                                },
                                activeColor: c.primary,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                              ),
                              _buildSectionTitle(FuelType.fuel.name.cap),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        CusGestureDetector(
                          onTap: () {
                            selFuelType.value = FuelType.diesel;
                            onFuelChanged?.call(FuelType.diesel);
                          },
                          child: Row(
                            children: [
                              Radio<FuelType>(
                                value: FuelType.diesel,
                                groupValue: selFuelType.value,
                                onChanged: (value) {
                                  selFuelType.value = FuelType.diesel;
                                  onFuelChanged?.call(FuelType.diesel);
                                },
                                activeColor: c.primary,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                              ),
                              _buildSectionTitle(FuelType.diesel.name.cap),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const Divider(),

                    // Sort options
                    _buildOption(Strings.highToLow, Strings.highToLow),
                    _buildOption(Strings.lowToHigh, Strings.lowToHigh),
                  ],
                ),
              ),
            ),

            // Optional styling
            barrierColor: ctransp,
            barrierShape: BarrierShape.headerTrans,

            offset: const Offset(0, 8),
            duration: const Duration(milliseconds: 200),

            // The button you tap to open the dropdown
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(Strings.sortOf, style: TxtStyle.interSemiB()),
                SvgIcon(iconPath: IconsPath.arrowForwardSmall, height: 22),
              ],
            ),
          ),

          ////
          ///
          ///
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(title, style: TxtStyle.inter(fs: 12, w: 600, color: c.primary)),
    );
  }

  Widget _buildOption(String text, String criteriaValue) {
    final isSelected = selCriteria == criteriaValue;

    return InkWell(
      onTap: () {
        Get.back();
        onSortChanged?.call(criteriaValue);
      },
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? c.primary.withOpacity(0.1) : null,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TxtStyle.inter(
                fs: 13,
                color: isSelected ? c.primary : null,
                w: isSelected ? 600 : 400,
              ),
            ),
            if (isSelected) Icon(Icons.check, size: 16, color: c.primary),
          ],
        ),
      ),
    );
  }
}
