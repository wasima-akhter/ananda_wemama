import 'package:we_mama/app/helper_widgets_export.dart';

class DeleteConfirmDialog extends StatelessWidget {
  final RxBool isLoading;
  final Future<void> Function() onConfirm;

  const DeleteConfirmDialog({
    super.key,
    required this.isLoading,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: 20.pa,
      decoration: BoxDeco.decRadiusAll(20, clr: bgClr),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: c.primary, size: 48),
          12.toHeight,

          Text(
            Strings.areYouSure,
            style: TxtStyle.inter(fs: 18, w: 600, color: c.primary),
          ),
          6.toHeight,

          Text(
            Strings.confirmDeletePost,
            textAlign: TextAlign.center,
            style: TxtStyle.inter(),
          ),
          24.toHeight,

          Row(
            children: [
              Expanded(
                child: CustomBtnWTxt(
                  outlined: true,
                  // borderClr: c.primary,
                  txtClr: c.textPrimary,
                  btnTxt: Strings.cancel,
                  isLoading: false,
                  rad: 30,
                  onTap: () {
                    GNav.pop();
                  },
                ),
              ),
              Gap(8),
              Expanded(
                child: Obx(
                  () => CustomBtnWTxt(
                    btnColor: c.primary,
                    borderClr: c.primary,
                    txtClr: white,
                    btnTxt: Strings.confirm,
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
    );
  }
}
