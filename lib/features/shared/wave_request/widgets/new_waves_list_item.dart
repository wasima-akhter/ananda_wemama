import 'package:we_mama/core/components/ui/dialogs/popups.dart';
import 'package:we_mama/core/helpers/date_helper.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/app_ui/components/user_detaIl_component/controller/user_detail_controller.dart';
import '../../../main_tabs/chat/widgets/chat_user_image.dart';
import '../controller/wave_request_controller.dart';
import '../model/new_wave_req_list_item_model.dart';

class NewWavesListItem extends StatelessWidget {
  final WaveRequestController wrc;
  final NewWaveListItemModel model;

  const NewWavesListItem({super.key, required this.model, required this.wrc});

  @override
  Widget build(BuildContext context) {
    final myId = currentProfileId;

    // 🔥 IMPORTANT: get OTHER user (not me)
    final otherUser = model.participants?.firstWhere(
      (p) => p.id != myId(),
      orElse: () => model.participants!.first,
    );

    final name = otherUser?.name ?? "Unknown";
    final imageUrl = otherUser?.profileImage ?? "";

    final time =
        (model.createdAt != null
                ? DateHelper()
                      .formatTimeAgo(model.createdAt!.toString())
                      .date // optional helper
                : "")
            .toString();

    final udc = Get.find<UserDetailController>();

    return CusGestureDetector(
      onTap: () async {
        final otherUserId = otherUser?.id;

        if (otherUserId == null) return;

        // 🔥 open popup FIRST
        newWavesUserDetailsDialog(
          isLoading: wrc.isgetUserProfileLoading_,
          onTapAction: (isAccepted) =>
              wrc.onTapAction(isAccepted, conversationId: model.id ?? ''),
          isSeeMore: udc.isSeeMore,
          onTapSeeMoreTxt: udc.toggleSeeMore,
          user: wrc.waveUserProfileData, // ✅ Rxn
          isAcceptLoading: wrc.isAcceptLoading,
          isRejectLoading: wrc.isRejectLoading,
        );

        // 🔥 THEN fetch
        await wrc.getUserProfile(userId: otherUserId);
      },
      child: ContainerBordered(
        mv: 2,
        // contClr: c.bottomSheetBackground,
        child: Row(
          children: [
            ChatUserImage(imageUrl: imageUrl, name: name),
            Gap(itemGap),
            Expanded(
              child: Text(
                name.capEachWord(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TxtStyle.outfitSemiB(
                  fs: 16,
                  w: 500,
                  color: c.foregroundSecondary,
                ),
              ),
            ),
            Gap(itemGap),
            Text(time, style: TxtStyle.outfitSmSecNor500),
          ],
        ),
      ).get10cm.mR(0),
    );
  }
}
