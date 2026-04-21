import '../../../app/helper_widgets_export.dart';
import '../../../core/components/ui/inputs/cus_des_type_text_form_field.dart';

class MsgInputRow extends StatelessWidget {
  final TextEditingController inputMsgCtrl;
  final FocusNode inputMsgFocus;
  final void Function()? onSend;
  const MsgInputRow({
    super.key,
    required this.inputMsgCtrl,
    required this.inputMsgFocus,
    this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return CusDesTypeTextFormField(
      controller: inputMsgCtrl,
      focusNode: inputMsgFocus,
      hintText: Strings.typeSomething,
      minLines: 1,
      minHeight: 20,
      maxHeight: 60,
      bgClr: c.textOnPrimary,
      isPaddingLess: true,
      suffix: CusCircleIconButton(
        radius: 15,
        backgroundColor: c.primary,
        onTap: onSend,
        child: SvgIcon(iconPath: IconsPath.sendLargeWhite, height: 20),
      ).mAll(4),
    ).mHV(10, 0);
  }
}
