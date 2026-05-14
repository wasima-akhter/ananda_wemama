import '../../app/helper_widgets_export.dart';
import '../components/app_ui/sheets/state_city_bottom_sheet.dart';

///////////////////////////////////////
///
///     select state
///
///////////////////////////////////////
Future<dynamic> showSelectionBottomSheet({
  required String title,
  required List<String> items,
  required RxString selectedValue,
  double? heightFactor,
}) {
  return Get.bottomSheet(
    ignoreSafeArea: false,
    isDismissible: true,
    enableDrag: true,
    isScrollControlled: true,
    backgroundColor: bgClr,

    AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.only(bottom: S.bottomInset),
      child: Container(
        // color: Colors.amber,
        height: bSheetH * 1 * (heightFactor ?? 1),
        child: SelectListBottomSheet(title: title, items: items, selectedValue: selectedValue),
      ),
    ),
  );
}
