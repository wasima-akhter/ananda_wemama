import 'package:image_picker/image_picker.dart';
import 'package:we_mama/core/components/app_ui/cards/add_photo_widget.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../controller/manage_community_controller.dart';

class ManageCommunityScreen extends StatelessWidget {
  const ManageCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mcc = Get.find<ManageCommunityController>();
    final refreshKey = GlobalKey<RefreshIndicatorState>();

    return AppScreenTemplate(
      refreshKey: refreshKey,
      onRefresh: () async {
        print("communities refreshed");
      },
      appBar: CommonAppBarContent(title: Strings.manageCommunity),

      bottomWidget: Obx(
        () => filledBtnWTxt(
          btnTxt: Strings.update,
          isLoading: mcc.isLoading,
          onTap: () async {
            mcc.onTapEdit();
          },

          //  await epc.onTapSignup(setupProfileFormKey),
        ),
      ),
      child: Column(
        children: [
          Obx(() {
            return AddPhotoWidget(
              onTapAddPhoto: () async =>
                  await mcc.pickSingleImage(ImageSource.gallery),
              selImage: mcc.fileImage.value,
              imageUrl: mcc.existingImageUrl.value, // ← pass URL as fallback
            );
          }),

          Gap(itemGap * 3),

          CusNameTypeTextFormField(
            controller: mcc.nameCtrl,
            focusNode: mcc.nameFocus,

            rad: 8,
            brdrW: 0.6,
            fillColor: ctransp,

            hintText: Strings.communityName,
          ),

          Gap(itemGap * 3),

          // ProfileTile(
          //   title: Strings.memberManagement,
          //   iconPath: IconsPath.userGroup,

          //   tileClr: c.secondary.withOpacity(0.3),
          //   onTap: () => Get.toNamed(RoutePaths.memberManagement),
          // ),
          // Gap(itemGap),
        ],
      ).getcm,
    );
  }
}
