import 'package:mama_app/app/helper_widgets_export.dart';

import '../../../gen/assets.gen.dart';
import '../../enums/app_enums.dart';
import '../../helpers/string_helper.dart';

class EditFuelDieselRatePopup extends StatelessWidget {
  final String title;
  final FuelType type;
  final RxBool isLoading;
  final bool? isLoad;

  final VoidCallback onTapUpdatePrice;

  final TextEditingController controller;
  final FocusNode focusNode;
  final GlobalKey<FormState> updatePriceFormKey;

  const EditFuelDieselRatePopup({
    super.key,
    required this.title,
    required this.type,
    required this.isLoading,
    required this.onTapUpdatePrice,
    required this.controller,
    required this.focusNode,
    required this.updatePriceFormKey,
    this.isLoad,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,

        padding: EdgeInsets.only(bottom: S.bottomInset),
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: S.h * 0.8, // max 80% of screen
                minWidth: 300,
                maxWidth: 360,
              ),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  padding: 16.pa,
                  decoration: BoxDecoration(color: bgClr, borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Header
                      Row(
                        children: [
                          Expanded(
                            child: TextFit(
                              title.capEachWord(),
                              style: title_600_mClr_Outfit,
                              maxLines: 2,
                            ),
                          ),
                          CusGestureDetector(
                            onTap: Get.back,
                            child: SvgIcon(iconPath: Assets.icons.closeRedFilled, height: 30.h),
                          ),
                        ],
                      ),

                      Gap(20.h),

                      /// Input
                      Form(
                        key: updatePriceFormKey,
                        child: CusNameTypeTextFormField(
                          prefix: isLoad == true
                              ? null
                              : Text(
                                  Strings.currency,
                                  style: TxtStyle.interSemiB(fs: 24, w: 600, color: c.primary),
                                ),
                          prefixSize: 26,

                          controller: controller,
                          focusNode: focusNode,
                          isNoBrder: true,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          hintText: "0.0",
                          contentPadding: EdgeInsets.zero,
                          style: TxtStyle.interSemiB(fs: 24, w: 600),
                          hintStyle: TxtStyle.interSemiB(fs: 24, w: 600),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a rate';
                            }
                            final parsed = double.tryParse(value);
                            if (parsed == null) {
                              return 'Please enter a valid number';
                            }
                            if (parsed < 0) {
                              return 'Rate cannot be negative';
                            }
                            return null;
                          },
                        ),
                      ),

                      Gap(24.h),

                      Obx(() {
                        return CustomBtnWTxt(
                          onTap: onTapUpdatePrice,
                          outlined: true,
                          btnTxt: isLoad == true ? Strings.updateLoad : Strings.updatePrice,
                          isLoading: isLoading.value,
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
