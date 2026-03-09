import '../../../../app/helper_widgets_export.dart';
import '../../../../core/helpers/date_helper.dart';

class DatePickerWithPrivacy extends StatelessWidget {
  final DateTime? firstDate;
  final DateTime? lastDate;
  final RxString selectedDate;
  final RxBool keepPrivate;

  const DatePickerWithPrivacy({
    super.key,

    this.firstDate,
    this.lastDate,
    required this.selectedDate,
    required this.keepPrivate,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    // Parse previously selected date or fallback
    final initial = selectedDate.value.isNotEmpty
        ? DateTime.tryParse(selectedDate.value) ?? now
        : now;

    DateTime tempSelected = initial;

    return Dialog(
      backgroundColor: bgClr,
      insetPadding: EdgeInsets.symmetric(horizontal: 14.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(Strings.dateOfBirth.cap, style: TxtStyle.outfitSemiB(fs: 16, color: c.primary)),
            Gap(itemGap),

            // ── Calendar ──
            CalendarDatePicker(
              initialDate: tempSelected,
              firstDate: firstDate ?? DateTime(1900),
              lastDate: lastDate ?? now,
              onDateChanged: (date) => tempSelected = date,
            ),

            Gap(itemGap),

            // ── Keep Private toggle ──
            CusGestureDetector(
              onTap: () => keepPrivate.toggle(),
              child: Obx(
                () => Row(
                  children: [
                    CustomCheckBox(
                      value: keepPrivate.value,
                      onChanged: (_) => keepPrivate.toggle(),
                      borderColor: c.secondary,
                      checkColor: c.scaffoldBackground,
                      activeColor: c.secondary,
                      size: 18,
                    ),
                    Gap(8),
                    Text(
                      Strings.keepPrivate,
                      style: TxtStyle.outfit(fs: 13, w: 500, color: c.secondary),
                    ),
                  ],
                ),
              ),
            ),

            Gap(itemGap * 2),

            // ── Buttons ──
            Row(
              children: [
                Expanded(
                  child: CustomBtnWTxt(
                    btnTxt: Strings.cancel.cap,
                    outlined: true,
                    btnColor: ctransp,
                    rad: 30,
                    borderClr: c.secondary,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    onTap: () => Get.back(),
                    style: TxtStyle.outfit(fs: 14, w: 500, color: c.secondary),
                    isLoading: false,
                  ),
                ),
                Gap(itemGap),
                Expanded(
                  child: CustomBtnWTxt(
                    btnTxt: Strings.okay.cap,
                    rad: 30,
                    btnColor: c.secondary,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    onTap: () {
                      selectedDate.value = formatDate(tempSelected);
                      Get.back();
                    },
                    style: TxtStyle.outfit(fs: 14, w: 500, color: white),
                    isLoading: false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
