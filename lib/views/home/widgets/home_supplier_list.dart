import '../../../app/helper_widgets_export.dart';
import '../../../core/common_widgets/empty_widget.dart';
import '../../../core/common_widgets/gesture_detector_cus.dart';
import '../../../core/enums/app_enums.dart';
import '../model/nearby_suppliers_with_price_stats_model.dart';
import 'home_sort_of_dropdown.dart';
import 'home_supplier_item.dart';

class HomeSupplierList extends StatelessWidget {
  final List<NearestSupplierDataModel?> list;
  final String leftTitle;

  final void Function(FuelType?)? onChanged;
  final Rx<FuelType> selFuelType;

  final bool showSortOfStackList;
  final void Function()? onTapRightTitle;
  final void Function(String criteria)? onTapSortOfCriteria;
  final void Function(String? supplierId)? onTapSupplierItem;
  final bool? hasShadow;
  final Color? brdrClr;
  final Color? titleTxtClr;

  final RxString? selSortOfCriteria;

  const HomeSupplierList({
    super.key,
    required this.list,
    required this.leftTitle,
    this.onTapSupplierItem,
    this.brdrClr,
    this.titleTxtClr,
    this.hasShadow,
    this.onTapRightTitle,
    this.onTapSortOfCriteria,
    this.selSortOfCriteria,
    required this.showSortOfStackList,
    this.onChanged,
    required this.selFuelType,
  });

  @override
  Widget build(BuildContext context) {
    // 🔥 Duplicate testList only for UI testing
    final testList = [...list]; // 3x items

    if (testList.isEmpty) {
      return EmptyWidget(title: Strings.noSupplierFound);
    }

    return Column(
      children: [
        // name bar with sort of button
        Container(
          // height: 300,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(leftTitle, style: TxtStyle.inter(w: 600, fs: 15))),

              HomeSortOfDropdown(
                selFuelType: selFuelType,

                selCriteria: selSortOfCriteria,

                onFuelChanged: (fuelType) {
                  print("onChanges ${fuelType.name}");
                },
                onSortChanged: onTapSortOfCriteria,
              ),
            ],
          ),
        ),
        Gap(itemGap),

        // .. testList of items
        ListView.builder(
          physics:
              //  testList.length == 1
              // ?
              const NeverScrollableScrollPhysics(),
          // : const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: testList.length,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            final name = testList[index]?.name ?? '';
            final location = testList[index]?.address ?? '';
            final fuelRate = (testList[index]?.todayFuelRate ?? 0.0).toString();
            final dieselRate = (testList[index]?.todayDieselRate ?? 0.0).toString();
            final supplierId = testList[index]?.id;
            return CusGestureDetector(
              onTap: () => onTapSupplierItem?.call(supplierId),
              child: HomeSupplierItem(
                name: name,
                location: location,
                fuelRate: fuelRate,
                dieselRate: dieselRate,
                brdrClr: brdrClr,
                hasShadow: hasShadow,
                titleTxtClr: titleTxtClr,
              ),
            );
          },
        ),
      ],
    );
  }
}

/////

//
