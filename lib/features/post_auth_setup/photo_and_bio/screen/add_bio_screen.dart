import 'package:we_mama/core/components/ui/inputs/cus_des_type_text_form_field.dart';
import 'package:we_mama/gen/assets.gen.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/feedback/error_field/error_field.dart';
import '../../../../core/components/ui/helpers/texts/rich_text_widget.dart';
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
            titleText: Strings.writeYourBio,
            subtitleText: Strings.shareLittleAboutYourself,
          ),

          Gap(10.h),
          Form(
            key: photoAndBioFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== Your Form Fields =====
                ContainerBordered(
                  hasBrdr: true,
                  contClr: inputBgClr,
                  brdrClr: c.strokePrimary.withValues(alpha: 0.1),
                  brdrW: 2,

                  rad: 12,
                  vp: 0,
                  hp: 0,

                  child: Column(
                    children: [
                      CusDesTypeTextFormField(
                        controller: pbc.bioDesCtrl,
                        hintText: Strings.shareLittleAboutYou,
                        minHeight: 120.h,
                        maxHeight: 120.h,
                        hintStyle: TxtStyle.outfitSemiB(
                          fs: 14,
                          color: Color(0xFF856656).withValues(alpha: 0.8),
                        ),
                        style: TxtStyle.outfitSemiB(
                          fs: 14,
                          color: c.foregroundPrimary.withValues(alpha: 0.8),
                        ),
                        rad: 12,
                        // isNoBrder: true,
                        bgClr: inputBgClr,
                        brdrClr: ctransp,

                        focusNode: pbc.bioDesFocus,
                        // validator: validateBioDescription,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ValueListenableBuilder<TextEditingValue>(
                          valueListenable: pbc.bioDesCtrl,
                          builder: (_, value, _) {
                            return Text(
                              "${value.text.trim().length}/250",
                              style: TxtStyle.outfitSemiB(
                                w: 500,
                                fs: 14,
                                color: const Color(0xFF856656),
                              ),
                            );
                          },
                        ),
                      ).marginOnly(bottom: 12, right: 12),
                    ],
                  ),
                ),

                Obx(() {
                  if (pbc.bioError.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return SetupFieldError(error: pbc.bioError.value);
                }),

                Gap(itemGap * 2),

                //
                ContainerBordered(
                  brdrClr: c.primary.withValues(alpha: 0.1),
                  vp: 8,
                  hasBrdr: true,
                  contClr: Color(0xFFFBEDEA),
                  child: Row(
                    children: [
                      Builder(
                        builder: (context) {
                          final size = S.w * 0.16;
                          return SizedBox(
                            width: size,
                            child: SvgIcon(
                              iconPath: Assets.icons.ideas,
                              height: size * 0.8,
                            ),
                          );
                        },
                      ),
                      //
                      AppRichText(
                        defaultStyle: TxtStyle.outfitSemiB(
                          fs: 12,
                          color: c.foregroundPrimary,
                          w: 600,
                        ),
                        parts: [
                          RichTextPart(text: 'Ideas: '),
                          RichTextPart(
                            text:
                                'your interest,\nyour motherhood journey, or anything\nyou would like to share.',
                            style: TxtStyle.outfitSemiB(
                              fs: 12,
                              color: const Color(0xFF856656),
                              w: 600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Gap(itemGap * 3),
              ],
            ),
          ),
        ],
      ).getcm,
    );
  }
}
