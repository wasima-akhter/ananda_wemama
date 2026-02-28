import '../../app/helper_widgets_export.dart';
import 'cus_material_btn_w_txt.dart';

class Alerts {
  confirmationAlert({
    required BuildContext context,
    required String title,
    String? description,
    String? buttonText,
    required ValueNotifier<bool> loadingNotifier,

    required Future Function() onConfirm,
    Color? buttonColor,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: S.w - 80,
              decoration: BoxDecoration(color: bgClr, borderRadius: 12.brdrRad),
              constraints: const BoxConstraints(maxWidth: 480),
              child: Stack(
                children: [
                  ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(20),
                    children: [
                      Center(child: Text(title, style: TxtStyle.inter(fs: 16))),
                      4.toHeight,
                      Center(
                        child: Text(
                          description ?? '',
                          style: TxtStyle.inter(color: c.textSecondary),
                        ),
                      ),
                      12.toHeight,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              GNav.pop(false);
                            },
                            child: Text(Strings.cancel, style: TxtStyle.inter()),
                          ),

                          CusMaterialBtnWTxt(
                            isloadingwhite: true,
                            borderClr: c.textPrimary,
                            onTap: onConfirm,
                            btnColor: buttonColor ?? c.cardPrimary,
                            btnTxt: buttonText ?? "Confirm",
                            isLoading: loadingNotifier,
                            rad: 22,
                            w: 100,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
