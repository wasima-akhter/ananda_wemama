import 'package:we_mama/app/helper_widgets_export.dart';
import 'package:we_mama/core/components/ui/inputs/cus_pass_type_text_form_field.dart';
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
            Strings.confirmDeleteAccount,
            textAlign: TextAlign.center,
            style: TxtStyle.inter(),
          ),

          20.toHeight,
          Obx(
            () => CusPassTypeTextFormField(
              controller: profileController.passwordCtrl,
              obscureText: profileController.isPasswordHidden,
              hintText: "Enter your password",

              validator: (value) => validatePassword(value),

              prefix: SvgIcon(
                iconPath: IconsPath.lock,
                height: 22,
              ).mOnly(left: 15, right: 6),

              prefixSize: 34,

              suffix: VisibilitySuffix(
                onTap: profileController.togglePassword,
                icon: profileController.passwordIcon,
              ),

              hintW: 600,
            ),
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
                  onTap: () => Get.back(),
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
                    onTap: () async {
                      final password = profileController.passwordCtrl.text
                          .trim();

                      if (password.isEmpty) {
                        // show your snackbar/toast
                        return;
                      }

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
