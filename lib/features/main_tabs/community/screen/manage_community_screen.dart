import 'package:image_picker/image_picker.dart';
import 'package:mama_app/core/common_widgets/common_components/add_photo_widget.dart';
import 'package:mama_app/features/main_tabs/community/controller/manage_community_controller.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../home/modules/profile_tile.dart';

class ManageCommunityScreen extends StatelessWidget {
  const ManageCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ccc = Get.find<ManageCommunityController>();
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
          isLoading: ccc.isLoading,
          onTap: () async {
            // Get.toNamed(RoutePaths.photoAndBio);
          },

          //  await epc.onTapSignup(setupProfileFormKey),
        ),
      ),
      child: Column(
        children: [
          Obx(() {
            return AddPhotoWidget(
              onTapAddPhoto: () async => await ccc.pickSingleImage(ImageSource.gallery),

              selImage: ccc.fileImage.value,
            );
          }),

          Gap(itemGap * 3),

          CusNameTypeTextFormField(
            controller: ccc.nameCtrl,
            focusNode: ccc.nameFocus,

            rad: 8,
            brdrW: 0.6,
            fillColor: ctransp,

            hintText: Strings.communityName,
          ),

          Gap(itemGap * 3),

          ProfileTile(
            title: Strings.memberManagement,
            iconPath: IconsPath.userGroup,

            tileClr: c.secondary.withOpacity(0.3),
            onTap: () => Get.toNamed(RoutePaths.memberManagement),
          ),
          Gap(itemGap),
        ],
      ).getcm,
    );
  }
}
