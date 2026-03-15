import '../../../app/helper_widgets_export.dart';
import '../../../core/common_widgets/cus_des_type_text_form_field.dart';

class MsgInputRow extends StatelessWidget {
  final TextEditingController inputMsgCtrl;
  final FocusNode inputMsgFocus;
  const MsgInputRow({super.key, required this.inputMsgCtrl, required this.inputMsgFocus});

  @override
  Widget build(BuildContext context) {
    return CusDesTypeTextFormField(
      controller: inputMsgCtrl,
      focusNode: inputMsgFocus,
      hintText: Strings.typeSomething,
      minLines: 1,
      minHeight: 40,
      bgClr: c.textOnPrimary,
      suffix: CusCircleIconButton(
        radius: 15,
        backgroundColor: c.primary,
        onTap: () async {
          // open picker for image or file
        },
        child: SvgIcon(iconPath: IconsPath.sendLargeWhite, height: 20),
      ).mAll(4),
    ).mHV(10, 0);
  }
}
