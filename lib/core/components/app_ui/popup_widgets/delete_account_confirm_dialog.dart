import 'package:we_mama/app/helper_widgets_export.dart';
import 'package:we_mama/core/components/ui/inputs/cus_pass_type_text_form_field.dart';
import 'package:we_mama/core/themes/color/colors.dart';
import 'package:we_mama/features/main_tabs/home/sub_feature/profile/controller/profile_controller.dart';

import '../../../utils/validator/validators.dart';
import '../../ui/helpers/visibility_suffix.dart';

class DeleteAccountConfirmDialog extends StatelessWidget {
  final RxBool isLoading;
  final Future<void> Function(String password) onConfirm;

  const DeleteAccountConfirmDialog({
    super.key,
    required this.isLoading,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final profileController = ProfileController.to;

    return Container(
      padding: 24.pa,
      decoration: BoxDeco.decRadiusAll(28, clr: bgClr),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 72,
            width: 72,
            decoration: BoxDecoration(
              color: AppPalette.snackError.withValues(alpha: .12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.delete_forever_rounded,
              color: AppPalette.snackError,
              size: 38,
            ),
          ),

          20.toHeight,

          Text(
            "Delete Account?",
            style: TxtStyle.inter(fs: 20, w: 700, color: AppPalette.snackError),
          ),

          10.toHeight,

          Text(
            "This action permanently removes your account and all associated data. Please enter your password to continue.",
            textAlign: TextAlign.center,
            style: TxtStyle.inter(fs: 12, color: c.textSecondary),
          ),

          8.toHeight,

          Container(
            padding: 12.pa,
            decoration: BoxDecoration(
              color: c.primary.withValues(alpha: .08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 18, color: c.primary),
                8.toWidth,
                Expanded(
                  child: Text(
                    "You won't be able to recover your account later.",
                    style: TxtStyle.inter(fs: 12, color: c.primary, w: 500),
                  ),
                ),
              ],
            ),
          ),

          20.toHeight,

          Obx(
            () => CusPassTypeTextFormField(
              controller: profileController.passwordCtrl,
              obscureText: profileController.isPasswordHidden,
              hintText: "Enter your password",
              validator: validatePassword,

              prefix: SvgIcon(
                iconPath: IconsPath.lock,
                height: 22,
              ).mOnly(left: 15, right: 6),

              prefixSize: 34,

              suffix: VisibilitySuffix(
                onTap: profileController.togglePassword,
                icon: profileController.passwordIcon,
              ),

              hintW: 500,
            ),
          ),

          24.toHeight,

          Row(
            children: [
              Expanded(
                child: CustomBtnWTxt(
                  outlined: true,
                  txtClr: c.textPrimary,
                  btnTxt: "Cancel",
                  isLoading: false,
                  rad: 14,
                  onTap: Get.back,
                ),
              ),

              12.toWidth,

              Expanded(
                child: Obx(
                  () => CustomBtnWTxt(
                    btnColor: AppPalette.snackError,
                    borderClr: AppPalette.snackError,
                    txtClr: white,
                    btnTxt: "Delete Account",
                    isLoading: isLoading.value,
                    rad: 14,
                    onTap: () async {
                      final password = profileController.passwordCtrl.text
                          .trim();

                      if (password.isEmpty) return;

                      await onConfirm(password);
                    },
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
