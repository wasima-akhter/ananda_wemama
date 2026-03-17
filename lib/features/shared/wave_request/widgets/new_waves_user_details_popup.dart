import 'package:mama_app/core/common_widgets/common_components/user_detaIl_component/ui/user_detail_component.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/common_widgets/common_components/user_detaIl_component/controller/user_detail_controller.dart';
import '../../../../core/common_widgets/small_popup_dialog.dart';

class NewWavesUserDetailsPopup extends StatelessWidget {
  final FakeUserDetailsModel? user;
  final RxBool isLoading;
  final VoidCallback onTapSeeMore;
  final Future<void> Function(bool isAccepted) onTapAction;
  final RxBool isSeeMore;

  const NewWavesUserDetailsPopup({
    super.key,
    required this.user,
    required this.isLoading,
    required this.isSeeMore,
    required this.onTapSeeMore,
    required this.onTapAction,
  });

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return SizedBox.shrink();
    }

    return LargePopupDialog(
      child: BounceSingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: itemGap,
          children: [
            UserDetailComponent(
              user: user,
              isLoading: isLoading,
              onTapSeeMore: onTapSeeMore,
              onTapAction: onTapAction,
              isSeeMore: isSeeMore,
            ),
            // decline and accept buttons
            _getDeclineAcceptBtnRow(),
          ],
        ),
      ),
    );
  }

  Widget _getDeclineAcceptBtnRow() {
    return Row(
      spacing: itemGap * 2,
      children: [
        Expanded(
          child: CustomBtnWTxt(
            isSmall: true,
            btnColor: ctransp,
            borderClr: c.primary,
            txtClr: c.textSecondary,
            rad: 12,
            btnTxt: Strings.decline,
            isLoading: isLoading.value,

            onTap: () => onTapAction(false),
          ),
        ),
        Expanded(
          child: CustomBtnWTxt(
            isSmall: true,
            btnColor: c.primary,
            borderClr: c.primary,
            txtClr: white,
            btnTxt: Strings.accept,
            rad: 12,
            isLoading: isLoading.value,

            onTap: () => onTapAction(true),
          ),
        ),
      ],
    );
  }
}

class _InfoRow {
  final String iconPath;
  final String text;

  _InfoRow({required this.iconPath, required this.text});
}
