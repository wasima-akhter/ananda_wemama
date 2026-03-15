import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:mama_app/core/common_widgets/cus_des_type_text_form_field.dart';

import '../../../../../../app/helper_widgets_export.dart';
import '../../../../../../app/service_export.dart';
import '../../../../../../core/common_widgets/common_components/add_photos_card.dart';
import '../../../../../../core/common_widgets/popup_input_tile.dart';
import '../../../../../../core/helpers/date_helper.dart';
import '../../../../../../core/utils/validator/validators.dart';
import '../controller/edit_profile_controller.dart';
import '../widgets/user_photo_widget.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double itemGap = 1.sh * 0.01;

    final epc = Get.find<EditProfileController>();
    final refreshKey = GlobalKey<RefreshIndicatorState>();
    final formkey = GlobalKey<FormState>();

    return AppScreenTemplate(
      appBar: CommonAppBarContent(title: Strings.editProfile),

      bottomWidget: Obx(
        () => filledBtnWTxt(
          btnTxt: Strings.update,
          isLoading: epc.isLoading,
          onTap: () async {
            // Get.toNamed(RoutePaths.photoAndBio);
          },

          //  await epc.onTapSignup(setupProfileFormKey),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() {
            final selImage = epc.fileImage.value;
            return UserPhotoWidget(
              // imageUrl: "http://10.10.20.57:8001/${storage.getUserInfo.imageUrl}",
              imageUrl: makeImageUrl(imageUrl: storage.getUserInfo.imageUrl ?? ''),
              selImage: selImage,
            );
          }),
          Gap(itemGap),
          CustomBtnWTxt(
            // style: TxtStyle.interSemiB(fs: 11, w: 700),
            isSmall: true,
            outlined: true,
            txtClr: c.textPrimary,
            style: TxtStyle.interSemiB(fs: 11, w: 700),
            padding: const EdgeInsets.all(5),
            onTap: () async {
              showPickImageBottomSheet(
                isScrollControlled: true,
                onTapGallery: () async {
                  await epc.pickSingleImage(ImageSource.gallery);
                  // place the selected image in the photo
                },
                onTapCamera: () async {
                  await epc.pickSingleImage(ImageSource.camera);
                },
              );

              // open gallery
            },
            w: 100,

            btnTxt: Strings.editPhoto,
            isLoading: false,
          ),

          Gap(itemGap),

          Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _getRowOfImages(
                  fileImages: epc.fileImages,
                  pickMultipleImage: epc.pickMultipleImage,
                  removeImage: epc.removeImage,
                ),
                Text(Strings.maximum4Photos, style: TxtStyle.outfitxSmNorSec),
              ],
            );
          }),

          Form(
            key: formkey,
            child: Column(
              children: [
                Gap(itemGap * 2),

                // ===== Your Form Fields =====
                CusNameTypeTextFormField(
                  controller: epc.nameCtrl,
                  hintText: Strings.name,
                  hintStyle: TxtStyle.outfitSemiB(fs: 14, color: c.primary),
                  style: TxtStyle.outfitSemiB(fs: 14, color: c.primary),
                  brdrClr: c.inputBorder,
                  fillColor: c.cardPrimary,

                  focusNode: epc.nameFocus,
                  validator: (value) => validateName(value),
                ),
                Gap(itemGap),

                Obx(() {
                  return PopupInputTile(
                    hintText: Strings.dateOfBirth.cap,
                    value: epc.selectedDob.value,
                    brdrClr: c.inputBorder,
                    brdrW: 0.6,
                    onTap: () {
                      // your date picker method

                      pickDateWithOptions(
                        selectedDate: epc.selectedDob,
                        keepPrivate: epc.keepDobPrivate,
                        unfocusAll: epc.unfocusAll,
                      );
                    },
                  );
                }),
                Gap(itemGap),
                Obx(() {
                  return PopupInputTile(
                    hintText: Strings.state.cap,
                    value: epc.selectedState.value,
                    brdrClr: c.inputBorder,
                    brdrW: 0.6,
                    onTap: () {
                      epc.openStateBottomSheet();
                    },
                  );
                }),
                Gap(itemGap),
                Obx(() {
                  return PopupInputTile(
                    hintText: Strings.city.cap,
                    value: epc.selectedCity.value,
                    brdrClr: c.inputBorder,
                    brdrW: 0.6,
                    onTap: () {
                      epc.openCityBottomSheet();
                    },
                  );
                }),
                Gap(itemGap),

                PopupInputTile(
                  hintText: Strings.children.cap,
                  value: Strings.children.cap,
                  brdrClr: c.inputBorder,
                  brdrW: 0.6,
                  onTap: () {
                    epc.openChildrenBottomSheet();
                  },
                ),

                Gap(itemGap),
                CusDesTypeTextFormField(
                  controller: epc.bioCtrl,
                  hintText: Strings.writeBioHere,
                  hintStyle: TxtStyle.outfitSemiB(fs: 14, color: c.primary),
                  style: TxtStyle.outfitSemiB(fs: 14, color: c.primary),
                  rad: 12,
                  focusNode: epc.bioFocus,
                  bgClr: c.cardPrimary,
                  validator: (value) => validateDescription(value),
                ),
                Gap(itemGap * 2.5),
              ],
            ),
          ),

          Gap(itemGap),
        ],
      ).getcm,
    );
  }

  Widget _getRowOfImages({
    required Rxn<List<XFile>> fileImages,
    required Future<void> Function() pickMultipleImage,
    required void Function(int index) removeImage,
  }) {
    final images = fileImages.value ?? [];
    final showAddBtn = images.length < 4;
    final totalItems = images.length + (showAddBtn ? 1 : 0);

    // Calculate size: screen width minus screen horizontal margins from getcm, divided by 4 max slots
    final double hPadding = S.w * 0.05 * 2; // getcm padding both sides
    final double totalSpacing = 8.w * 4; // spacing between 4 items
    final double imageSize = (S.w - hPadding - totalSpacing) / 4;

    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 8.w,
        runSpacing: 8.w,
        children: [
          // Images
          ...List.generate(images.length, (index) {
            final imagePath = images[index].path;
            return Stack(
              children: [
                SizedBox(
                  width: imageSize,
                  height: imageSize,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                      opacity: AlwaysStoppedAnimation(0.75),
                    ),
                  ),
                ),
                Positioned(
                  top: 2,
                  right: 2,
                  child: CusGestureDetector(
                    onTap: () => removeImage(index), // ← pass epc or use callback
                    child: CircleAvatar(
                      radius: 8.r,
                      backgroundColor: black.withOpacity(0.6),
                      child: SvgIconColored(
                        iconPath: IconsPath.closeCircle,
                        iconColor: white,
                        height: 20,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),

          // Add button
          if (showAddBtn)
            SizedBox(
              width: imageSize,
              height: imageSize,
              child: AddPhotosCard(onTap: pickMultipleImage),
            ),
        ],
      ),
    );
  }
}
