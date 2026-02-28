import '../../../app/helper_widgets_export.dart';
import '../cus_des_type_text_form_field.dart';

class DeliveryFeedbackDialog extends StatelessWidget {
  final RxBool isLoading;
  final RxInt selRatingNum;
  final String feedback;
  final Future<void> Function(int rating, String feedback) onSubmit;
  final void Function(int newRating) onRatingChanged;
  final void Function(String newFeedback) onFeedbackChanged;

  final TextEditingController descriptionCtrl;
  final FocusNode descriptionFocusNode;

  const DeliveryFeedbackDialog({
    super.key,
    required this.isLoading,

    required this.feedback,
    required this.onSubmit,
    required this.onRatingChanged,
    required this.onFeedbackChanged,
    required this.descriptionCtrl,
    required this.descriptionFocusNode,
    required this.selRatingNum,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          // constraints: BoxConstraints(
          //   maxWidth: 480,
          //   maxHeight: MediaQuery.of(context).size.height * 0.5, // max 80% of screen height
          // ),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: bgClr, borderRadius: (20).brdrRad),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    Strings.howWasYourDelivery,
                    style: TxtStyle.interSemiB(w: 600, fs: 18),
                  ),
                ),
                Gap(itemGap * 4),

                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final starIndex = index + 1;

                      final selectedRating = selRatingNum.value;
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onRatingChanged(starIndex),

                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: SvgIcon(
                            iconPath: starIndex <= selectedRating
                                ? IconsPath.heartHalfFilled
                                : IconsPath.heartOutlined,
                            height: starIndex <= selectedRating ? 26 : 24,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Gap(itemGap * 4),

                /// 📝 Feedback Field
                CusDesTypeTextFormField(
                  controller: descriptionCtrl,
                  focusNode: descriptionFocusNode,
                  onChanged: onFeedbackChanged,
                  hintText: Strings.writeYourFeedback,
                  hintStyle: TxtStyle.inter(fs: 11, w: 600),
                ),
                Gap(itemGap * 4),

                /// 🚀 Submit Button
                ///
                Obx(
                  () => filledBtnWTxt(
                    btnTxt: Strings.submit,
                    isLoading: isLoading.value,

                    onTap: selRatingNum.value == 0 || isLoading.value
                        ? null
                        : () async {
                            await onSubmit(selRatingNum.value, descriptionCtrl.text.trim());
                          },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
