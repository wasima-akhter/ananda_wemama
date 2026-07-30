import 'package:image_picker/image_picker.dart';

import '../../../../../../app/helper_widgets_export.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../profile/controller/profile_controller.dart';
import '../controller/edit_profile_controller.dart';
import '../widgets/description_images_grid.dart';
import '../widgets/edit_profile_form.dart';
import '../widgets/user_photo_widget.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final epc = Get.find<EditProfileController>();
    final formKey = GlobalKey<FormState>();

    return AppScreenTemplate(
      appBar: CommonAppBarContent(title: Strings.editProfile),
      bottomWidget: Obx(
        () => CustomBtnWTxt(
          padding: EdgeInsets.symmetric(vertical: 12.w),
          rad: 12,
          btnTxt: Strings.update,
          isLoading: epc.isLoading,
          onTap: () => epc.updateProfileDetails(formkey: formKey),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() {
            final profileData = Get.isRegistered<ProfileController>()
                ? Get.find<ProfileController>().userProfileData.value
                : null;

            final imageUrl = profileData?.profileImage ?? '';

            return UserPhotoWidget(
              imageUrl: imageUrl,
              selImage: epc.fileImage.value,
            );
          }),

          Gap(itemGap),
          CusGestureDetector(
            onTap: () => showPickImageBottomSheet(
              isScrollControlled: true,
              onTapGallery: () => epc.pickSingleImage(ImageSource.gallery),
              onTapCamera: () => epc.pickSingleImage(ImageSource.camera),
            ),
            child: Row(
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
          ),

          // CustomBtnWTxt(
          //   isSmall: true,
          //   outlined: true,
          //   txtClr: c.textPrimary,
          //   style: TxtStyle.interSemiB(fs: 9, w: 700),
          //   padding: const EdgeInsets.all(2),
          //   w: 100,
          //   btnTxt: Strings.editPhoto,
          // ),
          Gap(itemGap),

          //
          // Existing server images (read-only display)
          // Obx(() {
          //   if (epc.existingImageUrls.isEmpty) return const SizedBox.shrink();
          //   return Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(Strings.currentPhotos, style: TxtStyle.outfitxSmNorSec), // "Current Photos"
          //       Gap(8),
          //       Wrap(
          //         spacing: 8.w,
          //         runSpacing: 8.w,
          //         children: epc.existingImageUrls.map((url) {
          //           final double imageSize = (S.w - S.w * 0.05 * 2 - 8.w * 4) / 4;
          //           return Stack(
          //             children: [
          //               SizedBox(
          //                 width: imageSize,
          //                 height: imageSize,
          //                 child: ClipRRect(
          //                   borderRadius: BorderRadius.circular(8.r),

          //                   child: NetworkImageWidget(
          //                     imageUrl: url,
          //                     radius: 8,
          //                     opacity: const AlwaysStoppedAnimation(0.75),
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           );
          //         }).toList(),
          //       ),
          //       Gap(itemGap),
          //     ],
          //   );
          // }),

          // Extracted:
          Obx(
            () => DescriptionImagesGrid(
              images: epc.desImageFiles.value ?? [],
              onAdd: epc.pickMultipleImage,
              onRemove: epc.removeImage,
            ),
          ),

          // Extracted:
          EditProfileForm(epc: epc, formKey: formKey),

          Gap(itemGap),
        ],
      ).getcm,
    );
  }
}
