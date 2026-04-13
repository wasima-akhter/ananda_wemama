import 'package:mama_app/core/components/ui/inputs/cus_des_type_text_form_field.dart';
import 'package:mama_app/features/main_tabs/community/controller/post_in_community_controller.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/inputs/custom_toggle_btn.dart';

class PostInCommunityScreen extends StatelessWidget {
  const PostInCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pcc = Get.find<PostInCommunityController>();
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
            CustomBtnWTxt(
              rad: 30,
              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
              isSmall: true,
              btnTxt: Strings.post.cap,
              isLoading: false,
            ),
          ],
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Lagos Mom's Community".capEachWord(), style: TxtStyle.outfitLarTitle),
          Gap(itemGap),
          ContainerBordered(
            vp: 8,
            hp: 18,
            rad: 12,
            contClr: c.inputBackground,
            boxShadow: boxShadowBottomRight(color: c.secondary.withOpacity(0.8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Post Anonymously",
                  style: TxtStyle.outfitSemiB(fs: 14, w: 500, color: c.secondary),
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
          // UserShortDetailWidget(),

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
