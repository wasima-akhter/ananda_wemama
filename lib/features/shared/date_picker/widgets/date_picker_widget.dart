import '../../../../app/helper_widgets_export.dart';
import '../../../../core/helpers/date_helper.dart';

class DatePickerWithPrivacy extends StatelessWidget {
  final DateTime? firstDate;
  final DateTime? lastDate;
  final RxString selectedDate;
  final Rx<DateTime> tempSelected;
  final RxBool keepPrivate;

  final bool showKeepPrivate; // 👈 added

  const DatePickerWithPrivacy({
    super.key,
    this.firstDate,
    this.lastDate,
    required this.selectedDate,
    required this.tempSelected,
    required this.keepPrivate,
    this.showKeepPrivate = true, // 👈 default
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Dialog(
      backgroundColor: bgClr,
      insetPadding: EdgeInsets.symmetric(horizontal: 14.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                Strings.dateOfBirth.cap,
                style: TxtStyle.outfitSemiB(fs: 16),
              ),

              Gap(itemGap),

              Obx(
                () => ContainerBordered(
                  contClr: AppColors.cardBg,
                  vp: 0,

                  child: CalendarDatePicker(
                    key: ValueKey(tempSelected.value),
                    initialDate: tempSelected.value,
                    firstDate: firstDate ?? DateTime(1900),
                    lastDate: lastDate ?? now,
                    onDateChanged: (date) => tempSelected.value = date,
                  ),
                ),
              ),

              // 👇 only show when enabled
              if (showKeepPrivate) ...[
                Gap(itemGap),

                CusGestureDetector(
                  onTap: () => keepPrivate.toggle(),
                  child: Obx(
                    () => Row(
                      children: [
                        AppCheckbox(
                          value: keepPrivate.value,
                          onChanged: (_) => keepPrivate.toggle(),
                          borderColor: c.foregroundPrimary,
                          checkColor: c.foregroundPrimary,
                          activeColor: c.foregroundPrimary,
                          size: 18,
                        ),
                        Gap(8),
                        Text(
                          Strings.keepPrivate,
                          style: TxtStyle.outfit(fs: 13, w: 500),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              Gap(itemGap * 2),

              Row(
                children: [
                  Expanded(
                    child: CustomBtnWTxt(
                      btnTxt: Strings.cancel.cap,
                      outlined: true,
                      btnColor: ctransp,
                      rad: 30,
                      borderClr: c.strokePrimary,
                      padding: EdgeInsets.symmetric(vertical: 9.h),
                      onTap: () => Get.back(),
                      style: TxtStyle.outfit(
                        fs: 14,
                        w: 500,
                        color: c.secondary,
                      ),
                      isLoading: false,
                    ),
                  ),
                  Gap(itemGap),
                  Expanded(
                    child: CustomBtnWTxt(
                      btnTxt: Strings.okay.cap,
                      rad: 30,
                      btnColor: c.strokePrimary,
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      onTap: () {
                        selectedDate.value = formatDate(tempSelected.value);
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
      ),
    );
  }
}
