import 'package:image_picker/image_picker.dart';
import 'package:mama_app/core/components/ui/inputs/cus_des_type_text_form_field.dart';
import 'package:mama_app/gen/assets.gen.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/network/helpers/network_helpers.dart';
import '../../../../core/utils/validator/validators.dart';
import '../../../auth/core/auth_button_templates.dart';
import '../../../auth/core/auth_scaffold.dart';
import '../../../entry/onboard/modules/core/onboard_logo_header_row.dart';
import '../../../main_tabs/home/sub_feature/edit_profile/widgets/user_photo_widget.dart';
import '../controller/photo_and_bio_controller.dart';

class PhotoAndBioScreen extends StatelessWidget {
  const PhotoAndBioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pbc = Get.find<PhotoAndBioController>();

    final photoAndBioFormKey = GlobalKey<FormState>();

    return AuthScaffold(
      bottomWidget: Obx(
        () => AuthButton(
          isLoading: pbc.isLoading,
          onTap: () => pbc.onTapContinuePhotoBio(photoAndBioFormKey),
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
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Obx(() {
                      final selImage = pbc.fileImage.value;
                      return Container(
                        padding: 5.pa,
                        decoration: BoxDecoration(
                          color: c.cardPrimary,
                          shape: BoxShape.circle,
                        ),
                        child: UserPhotoWidget(
                          imageUrl: storage.getUserInfo.imageUrl ?? '',
                          selImage: selImage,
                          isFromSetup: true,
                          hasBrdr: false,
                          size_: ScreenSize.isSmallWidth
                              ? S.w * 0.45
                              : S.w * 0.5,
                        ),
                      );
                    }),

                    // positioned camera icon
                    Positioned(
                      bottom: ScreenSize.isSmallWidth ? 6 : 6,
                      right: ScreenSize.isSmallWidth ? -12 : 0,
                      child: CusGestureDetector(
                        onTap: () async {
                          showPickImageBottomSheet(
                            isScrollControlled: true,
                            onTapGallery: () async {
                              await pbc.pickSingleImage(ImageSource.gallery);
                              // place the selected image in the photo
                            },
                            onTapCamera: () async {
                              await pbc.pickSingleImage(ImageSource.camera);
                            },
                          );

                          // open gallery
                        },
                        child: Container(
                          padding: 12.pa,

                          decoration: BoxDecoration(
                            color: white,
                            shape: BoxShape.circle,
                            boxShadow: boxShadowBottom(
                              color: Colors.grey..withValues(alpha: 0.25),
                            ),
                          ),

                          child: Center(
                            child: SvgIcon(
                              iconPath: Assets.icons.cameraNew,
                              height: ScreenSize.isSmallWidth ? 22 : 26,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(itemGap),

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
