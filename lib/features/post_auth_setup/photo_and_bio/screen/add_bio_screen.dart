import 'package:mama_app/core/components/ui/inputs/cus_des_type_text_form_field.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/utils/validator/validators.dart';
import '../../../auth/core/auth_button_templates.dart';
import '../../../auth/core/auth_scaffold.dart';
import '../../../entry/onboard/modules/core/onboard_logo_header_row.dart';
import '../controller/photo_and_bio_controller.dart';

class AddBioScreen extends StatelessWidget {
  const AddBioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pbc = Get.find<PhotoAndBioController>();

    final photoAndBioFormKey = GlobalKey<FormState>();

    return AuthScaffold(
      bottomWidget: Obx(
        () => AuthButton(
          isLoading: pbc.isLoading,
          onTap: () => pbc.onTapContinueBio(photoAndBioFormKey),
        ),
      ),
      child: Column(
        children: [
          BrandedHeaderSection(
            titleText: Strings.addAProfilePhoto,
            subtitleText: Strings.addingPhotohelps,
          ),

          Gap(10.h),
          Form(
            key: photoAndBioFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ===== Your Form Fields =====
                CusDesTypeTextFormField(
                  controller: pbc.bioDesCtrl,
                  hintText: Strings.writeBioHere,
                  hintStyle: TxtStyle.outfitSemiB(fs: 14, color: c.primary),
                  style: TxtStyle.outfitSemiB(fs: 14, color: c.primary),
                  rad: 12,

                  focusNode: pbc.bioDesFocus,
                  validator: (value) => validateDescription(value),
                ),

                Gap(itemGap * 2.5),

                // 👇 THIS PUSHES BOTTOM SECTION DOWN
                Gap(itemGap * 3),
              ],
            ),
          ),
        ],
      ).getcm,
    );
  }
}
