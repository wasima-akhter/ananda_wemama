import 'package:flutter/foundation.dart';
import 'package:we_mama/core/components/app_ui/components/user_detaIl_component/ui/user_detail_component.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/dialogs/small_popup_dialog.dart';
import '../../../../core/helpers/widgets_helper.dart';
import '../../../main_tabs/home/sub_feature/profile/model/profile_model.dart';
import '../../../main_tabs/home/sub_feature/profile/widgets/profile_shimmer.dart';

class ChatUserDetailsPopup extends StatelessWidget {
  final Rxn<ProfileDataModel> user;
  final RxBool isLoading;
  final VoidCallback onTapSeeMore;
  final RxBool isSeeMore;

  const ChatUserDetailsPopup({
    super.key,
    required this.user,
    required this.isLoading,
    required this.isSeeMore,
    required this.onTapSeeMore,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final userValue = user.value;

      if (isLoading.value) {
        return LargePopupDialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [const ProfileShimmer()],
          ),
        );
      }

      if (userValue == null) {
        return LargePopupDialog(
          child: SizedBox(
            height: 200,
            child: Center(
              child: Text("Failed to load user", style: TxtStyle.outfitSmNor),
            ),
          ),
        );
      }

      final userData = mapToUserModel(userValue);

      return LargePopupDialog(
        child: BounceSingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (kDebugMode) Text(user.value?.email ?? ''),
              UserDetailComponent(
                user: userData,
                isLoading: isLoading,
                onTapSeeMore: onTapSeeMore,

                isSeeMore: isSeeMore,
              ),
            ],
          ),
        ),
      );
    });
  }
}
