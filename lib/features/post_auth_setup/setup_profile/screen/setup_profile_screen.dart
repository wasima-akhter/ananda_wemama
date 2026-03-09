import 'package:mama_app/core/common_widgets/popup_input_tile.dart';
import 'package:mama_app/core/helpers/date_helper.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/utils/validator/validators.dart';
import '../controller/setup_profile_controller.dart';

class SetupProfileScreen extends StatelessWidget {
  const SetupProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final spc = Get.find<SetupProfileController>();

    final setupProfileFormKey = GlobalKey<FormState>();

    return SafeArea(
      top: false,

      child: AppScreenTemplate(
        appBar: CommonAppBarContent(title: "", hasBackNavArrow: false),
        bottomWidget:
            // ===== BOTTOM SECTION =====
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ContainerBordered(
                  contClr: c.inputBackground,
                  vp: 15,
                  child: Column(
                    children: [
                      SvgIcon(iconPath: IconsPath.verifiedSafety, height: S.h * 0.06),

                      Text(Strings.verifiedSafety, style: TxtStyle.inter(w: 500)),
                      ContainerBordered(
                        contClr: c.inputBackground,
                        mh: S.w * 0.1,
                        child: Text(
                          textAlign: TextAlign.center,

                          Strings.verifiedSafetyBottomtxt,
                          style: TxtStyle.inter(fs: 11, ls: -0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

        child: Form(
          key: setupProfileFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                Strings.setupProfile.capEachWord(),
                textAlign: TextAlign.center,
                style: 17.titleMclrCusFSOutfit,
              ),
              Text(
                Strings.fillAllDetails.capEachWord(),
                textAlign: TextAlign.center,
                style: 13.norMclrCusFSoutfit,
              ),

              Gap(itemGap * 5),

              // ===== Your Form Fields =====
              CusNameTypeTextFormField(
                controller: spc.nameCtrl,
                hintText: Strings.name,
                hintStyle: TxtStyle.outfitSemiB(fs: 14, color: c.primary),
                style: TxtStyle.outfitSemiB(fs: 14, color: c.primary),

                focusNode: spc.nameFocus,
                validator: (value) => validateName(value),
              ),
              Gap(itemGap),

              Obx(() {
                return PopupInputTile(
                  hintText: Strings.dateOfBirth.cap,
                  value: spc.selectedDob.value,
                  onTap: () async {
                    await pickDateWithOptions(
                      selectedDate: spc.selectedDob,
                      keepPrivate: spc.keepDobPrivate,
                      unfocusAll: spc.unfocusAll,
                    );
                  },
                );
              }),
              Gap(itemGap),
              Obx(() {
                return PopupInputTile(
                  hintText: Strings.state.cap,
                  value: spc.selectedState.value,
                  onTap: () {
                    spc.openStateBottomSheet();
                  },
                );
              }),
              Gap(itemGap),
              Obx(() {
                return PopupInputTile(
                  hintText: Strings.city.cap,
                  value: spc.selectedCity.value,
                  onTap: () {
                    spc.openCityBottomSheet();
                  },
                );
              }),

              Gap(itemGap * 2.5),

              Obx(
                () => filledBtnWTxt(
                  btnTxt: Strings.continueTxt,
                  isLoading: spc.isLoading,
                  onTap: () async {
                    Get.toNamed(RoutePaths.photoAndBio);
                  },

                  //  await spc.onTapSignup(setupProfileFormKey),
                ),
              ),

              Gap(itemGap * 3),
            ],
          ).getcm,
        ),
      ),
    );
  }
}
