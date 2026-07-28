import 'package:image_picker/image_picker.dart';
import 'package:we_mama/gen/assets.gen.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/network/helpers/network_helpers.dart';
import '../../../auth/core/auth_button_templates.dart';
import '../../../auth/core/auth_scaffold.dart';
import '../../../entry/onboard/modules/core/onboard_logo_header_row.dart';
import '../../../main_tabs/home/sub_feature/edit_profile/widgets/user_photo_widget.dart';
import '../controller/photo_and_bio_controller.dart';

class AddPhotoScreen extends StatelessWidget {
  const AddPhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pbc = Get.find<PhotoAndBioController>();

    final photoAndBioFormKey = GlobalKey<FormState>();

    return AuthScaffold(
      bottomWidget: Obx(
        () => AuthButton(
          isLoading: pbc.isLoading,
          onTap: () => pbc.onTapContinuePhoto(photoAndBioFormKey),
        ),
      ),
      child: Column(
        children: [
          BrandedHeaderSection(
            titleText: Strings.addAProfilePhoto,
            subtitleText: Strings.addingPhotohelps,
          ),

          Gap(itemGap * 4),
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
                Gap(itemGap * 2),

                // camera tap text
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ContainerBordered(
                      hp: 12,
                      rad: 12,
                      vp: 3,
                      contClr: inputBgClr,
                      child: Row(
                        children: [
                          SvgIconColored(
                            iconPath: Assets.icons.cameraNew,
                            iconColor: Color(0xFFB2654C),
                            height: 20,
                          ),
                          Gap(6),
                          Text(
                            "Tap to upload photo",
                            style: TxtStyle.poppinsSemiB(
                              fs: 10,
                              w: 600,
                              ls: 0.4,
                              color: Color(0xFF856656),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
