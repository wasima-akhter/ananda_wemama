import '../../../../app/helper_widgets_export.dart';
import '../../ui/dialogs/small_popup_dialog.dart';

class BlockUserConfirmDialog extends StatelessWidget {
  final RxBool isLoading;
  final Future<void> Function() onConfirm;

  const BlockUserConfirmDialog({
    super.key,
    required this.isLoading,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return SmallPopupDialog(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.block, color: Colors.redAccent, size: 24.h),
                Gap(itemGap),
                Text(
                  "Block User?",
                  style: TxtStyle.inter(fs: 18, w: 600, color: c.primary),
                ),
              ],
            ),

            6.toHeight,

            Text(
              "They will no longer be able to message you.",
              textAlign: TextAlign.center,
              style: TxtStyle.inter(),
            ),

            24.toHeight,

            Row(
              children: [
                Expanded(
                  child: CustomBtnWTxt(
                    outlined: true,
                    txtClr: c.textPrimary,
                    btnTxt: Strings.cancel,
                    isLoading: false,
                    rad: 30,
                    onTap: () {
                      GNav.pop(false);
                    },
                  ),
                ),

                Gap(8),

                Expanded(
                  child: Obx(
                    () => CustomBtnWTxt(
                      btnColor: Colors.redAccent,
                      borderClr: Colors.redAccent,
                      isSmall: true,
                      txtClr: white,
                      btnTxt: "Block",
                      isLoading: isLoading.value,
                      rad: 30,
                      onTap: onConfirm,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
