import 'package:image_picker/image_picker.dart';
import 'package:mama_app/core/components/ui/inputs/cus_des_type_text_form_field.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/network/helpers/network_helpers.dart';
import '../../../../core/utils/validator/validators.dart';
import '../../../main_tabs/home/sub_feature/edit_profile/widgets/user_photo_widget.dart';
import '../controller/photo_and_bio_controller.dart';

class PhotoAndBioScreen extends StatelessWidget {
  const PhotoAndBioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pbc = Get.find<PhotoAndBioController>();

    final photoAndBioFormKey = GlobalKey<FormState>();

    return AppScreenTemplate(
      appBar: CommonAppBarContent(title: Strings.photoAndBio.capEachWord()),
      bottomWidget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Builder(
            builder: (context) {
              final list = [
                Strings.clearFaceForward,
                Strings.noSunglasses,
                Strings.yourphotosAreOnly,
              ];
              return ContainerBordered(
                contClr: c.inputBackground,
                vp: 15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      spacing: itemGap,
                      children: [
                        SvgIcon(iconPath: IconsPath.security),

                        Text(Strings.photoGuidlines, style: TxtStyle.inter(w: 600, fs: 13)),
                      ],
                    ),
                    Gap(itemGap),
                    ...List.generate(
                      list.length,
                      (index) => Row(
                        spacing: itemGap,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgIcon(
                            iconPath: index == list.length - 1
                                ? IconsPath.lockOutlined
                                : IconsPath.smallTick,
                          ),

                          Expanded(
                            child: Text(
                              list[index].capEachWord(),
                              style: TxtStyle.inter(w: 400, color: c.secondary, fs: 11),
                            ),
                          ),
                        ],
                      ).mB(itemGap * 0.6),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),

      child: Form(
        key: photoAndBioFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gap(itemGap * 3),
            Text(
              Strings.addPhotoAndBio.cap,
              textAlign: TextAlign.center,
              style: 13.titleMclrCusFSOutfit,
            ),

            Gap(itemGap * 3),

            Obx(() {
              final selImage = pbc.fileImage.value;
              return UserPhotoWidget(
                imageUrl: storage.getUserInfo.imageUrl ?? '',
                selImage: selImage,
              );
            }),
            Gap(itemGap),

            CustomBtnWTxt(
              isSmall: true,
              outlined: true,
              borderClr: c.secondary,
              txtClr: c.primary,
              fs: 11,
              padding: const EdgeInsets.all(5),
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
              w: 100,

              btnTxt: Strings.editPhoto,
              isLoading: false,
            ),
            Gap(itemGap * 3),
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

            Obx(
              () => filledBtnWTxt(
                btnTxt: Strings.continueTxt,
                isLoading: pbc.isLoading,
                onTap: () => pbc.onTapContinuePhotoBio(photoAndBioFormKey),
              ),
            ),

            // 👇 THIS PUSHES BOTTOM SECTION DOWN
            Gap(itemGap * 3),
          ],
        ).getcm,
      ),
    );
  }
}
