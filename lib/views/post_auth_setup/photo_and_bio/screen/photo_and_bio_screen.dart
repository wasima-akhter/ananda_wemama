import 'package:image_picker/image_picker.dart';
import 'package:mama_app/core/common_widgets/cus_des_type_text_form_field.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/network/helpers/network_helpers.dart';
import '../../../../core/utils/validator/validators.dart';
import '../../../account_overview/edit_profile/widgets/user_photo_widget.dart';
import '../controller/photo_and_bio_controller.dart';

class PhotoAndBioScreen extends StatelessWidget {
  const PhotoAndBioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pbc = Get.find<PhotoAndBioController>();

    final photoAndBioFormKey = GlobalKey<FormState>();

    return SafeArea(
      top: false,

      child: Scaffold(
        backgroundColor: bgClr,
        resizeToAvoidBottomInset: true,
        appBar: CommonAppBarContent(title: Strings.photoAndBio.capEachWord()),

        body: LayoutBuilder(
          builder: (context, constraints) {
            return BounceSingleChildScrollView(
              padding: EdgeInsets.zero,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: photoAndBioFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Gap(itemGap * 3),
                        Text(
                          Strings.addPhotoAndBio.capEachWord(),
                          textAlign: TextAlign.center,
                          style: 13.titleMclrCusFSOutfit,
                        ),

                        Gap(itemGap * 3),

                        Obx(() {
                          final selImage = pbc.fileImage.value;
                          return UserPhotoWidget(
                            // imageUrl: "http://10.10.20.57:8001/${storage.getUserInfo.imageUrl}",
                            imageUrl: makeImageUrl(imageUrl: storage.getUserInfo.imageUrl ?? ''),
                            selImage: selImage,
                          );
                        }),
                        Gap(itemGap),
                        CustomBtnWTxt(
                          isSmall: true,

                          btnColor: c.secondary,
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
                          controller: pbc.nameCtrl,
                          hintText: Strings.writeBioHere,
                          hintStyle: TxtStyle.outfitSemiB(fs: 14, color: c.primary),
                          style: TxtStyle.outfitSemiB(fs: 14, color: c.primary),

                          focusNode: pbc.nameFocus,
                          validator: (value) => validateName(value),
                        ),

                        Gap(itemGap * 2.5),

                        Obx(
                          () => filledBtnWTxt(
                            btnTxt: Strings.continueTxt,
                            isLoading: pbc.isLoading,
                            onTap: () async {
                              Get.toNamed(RoutePaths.lifeStyleAndInterests);
                            },

                            //  await pbc.onTapSignup(photoAndBioFormKey),
                          ),
                        ),

                        // 👇 THIS PUSHES BOTTOM SECTION DOWN
                        const Spacer(),

                        // ===== BOTTOM SECTION =====
                        Column(
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

                                          Text(
                                            Strings.photoGuidlines,
                                            style: TxtStyle.inter(w: 600, fs: 13),
                                          ),
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
                                                style: TxtStyle.inter(
                                                  w: 400,

                                                  color: c.secondary,
                                                  fs: 11,
                                                ),
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

                        Gap(itemGap * 3),
                      ],
                    ).getcm,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
