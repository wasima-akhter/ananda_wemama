import 'package:mama_app/app/helper_widgets_export.dart';

class DeleteAccountConfirmDialog extends StatelessWidget {
  final RxBool isLoading;
  final Future<void> Function(String password) onConfirm;

  DeleteAccountConfirmDialog({
    super.key,
    required this.isLoading,
    required this.onConfirm,
  });

  final TextEditingController passwordController = TextEditingController();
  final RxBool obscure = true.obs;

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
            Strings.confirmDeleteAccount,
            textAlign: TextAlign.center,
            style: TxtStyle.inter(),
          ),

          20.toHeight,

          Obx(
            () => TextField(
              controller: passwordController,
              obscureText: obscure.value,
              decoration: InputDecoration(
                hintText: "Enter your password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscure.value ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () => obscure.toggle(),
                ),
              ),
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
                  onTap: GNav.pop,
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
                      final password = passwordController.text.trim();

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
