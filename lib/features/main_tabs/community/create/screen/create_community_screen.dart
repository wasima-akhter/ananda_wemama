import 'package:image_picker/image_picker.dart';
import 'package:we_mama/core/components/app_ui/cards/add_photo_widget.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../controller/create_community_controller.dart';

class CreateCommunityScreen extends StatelessWidget {
  const CreateCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ccc = Get.find<CreateCommunityController>();
    final refreshKey = GlobalKey<RefreshIndicatorState>();

    return AppScreenTemplate(
      refreshKey: refreshKey,
      onRefresh: () async {
        print("communities refreshed");
      },
      appBar: CommonAppBarContent(title: Strings.createCommunity),

      bottomWidget: Obx(
        () => filledBtnWTxt(
          btnTxt: Strings.create,
          isLoading: ccc.isLoading_.value,
          onTap: () async => await ccc.onTapCreate(),
        ),
      ),
      child: Column(
        children: [
          Obx(() {
            return AddPhotoWidget(
              onTapAddPhoto: () async =>
                  await ccc.pickSingleImage(ImageSource.gallery),

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
        ],
      ).getcm.mT(10),
    );
  }
}
