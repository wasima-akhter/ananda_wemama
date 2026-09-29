import 'package:we_mama/app/controller_export.dart';
import 'package:we_mama/core/components/ui/inputs/cus_des_type_text_form_field.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/inputs/custom_toggle_btn.dart';
import '../../core/models/community_item_detail_model.dart';
import '../controller/create_post_controller.dart';
import '../widgets/user_short_detail_widget.dart';

class PostInCommunityScreen extends StatelessWidget {
  const PostInCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pcc = Get.find<CreatePostController>();
    final refreshKey = GlobalKey<RefreshIndicatorState>();

    return AppScreenTemplate(
      refreshKey: refreshKey,
      onRefresh: () async {
        print("communities refreshed");
      },
      appBar: CommonAppBarContent(
        title: "",
        suffix: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () => CustomBtnWTxt(
                rad: 30,
                onTap: () async {
                  await pcc.createNewPost();
                },
                padding: EdgeInsets.symmetric(
                  horizontal: 22.w,
                  vertical: ScreenSizeX.isTablet ? 2 : 8.h,
                ),
                isSmall: true,
                btnTxt: Strings.post.cap,
                isLoading: pcc.isCreatePostLoading.value,
              ),
            ),
          ],
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text("--".capEachWord(), style: TxtStyle.outfitLarTitle),
          Gap(itemGap),
          ContainerBordered(
            vp: 8,
            hp: 18,
            rad: 12,
            contClr: c.inputBackground,
            boxShadow: boxShadowBottomRight(
              color: c.secondary.withOpacity(0.8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Post Anonymously",
                  style: TxtStyle.outfitSemiB(fs: 14, w: 500, color: c.primary),
                ),

                Obx(
                  () => CustomToggleButton(
                    value: pcc.postAnonymously.value,
                    inactiveColor: c.scaffoldBackground,
                    activeColor: c.scaffoldBackground,
                    onChanged: pcc.toggleAnonymous,
                  ),
                ),
              ],
            ),
          ),

          Gap(itemGap * 2),
          Obx(() {
            return UserShortDetailWidget(
              postItem: AllPost(
                isAnonymous: pcc.postAnonymously.value,
                creator: Creator(
                  name: storage.getUsername,
                  city: storage.getUserAddressData.city,
                  profileImage: storage.getUserImageUrl,
                ),
              ),
            );
          }),

          // Obx(() {
          //   return AddPhotoWidget(
          //     onTapAddPhoto: () async => await pcc.pickSingleImage(ImageSource.gallery),

          //     selImage: pcc.fileImage.value,
          //   );
          // }),
          Gap(itemGap * 3),

          CusDesTypeTextFormField(
            controller: pcc.contentCtrl,
            focusNode: pcc.contentFocus,

            rad: 8,
            brdrClr: c.inputBorder.withOpacity(0.6),
            minLines: 5,

            hintText: Strings.writeSomething,
          ),
        ],
      ).getcm,
    );
  }
}
