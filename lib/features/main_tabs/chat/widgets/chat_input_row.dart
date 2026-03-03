import 'package:image_picker/image_picker.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/common_widgets/cus_des_type_text_form_field.dart';
import '../controller/chat_inbox_controller.dart';

class ChatInputRow extends StatelessWidget {
  final ChatInboxController cic;
  const ChatInputRow({super.key, required this.cic});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      // contClr: Colors.amber,
      vp: 0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: CusDesTypeTextFormField(
              controller: cic.msgInputController,
              focusNode: cic.msgInputFocus,
              hintText: Strings.typeSomething,
              minLines: 1,
              minHeight: 40,
              suffix: CusCircleIconButton(
                radius: 15,
                onTap: () async {
                  // open picker for image or file

                  await showPickAnyFileBottomSheet(
                    onTapGallery: () async {
                      await cic.pickSingleImageOrFile(source: ImageSource.gallery);
                      // place the selected image in the photo
                    },
                    onTapCamera: () async {
                      await cic.pickSingleImageOrFile(source: ImageSource.camera);
                    },

                    onTapFile: () async {
                      await cic.pickSingleImageOrFile();
                    },
                  );
                },
                child: SvgIcon(iconPath: IconsPath.addPlusCircle, height: 26),
              ),
            ),
          ),

          Gap(itemGap),

          CusGestureDetector(
            onTap: cic.onTapSendMsg,
            child: ContainerBordered(
              rad: 30,
              hp: 22,
              vp: 12,
              contClr: c.secondary,
              child: SvgIcon(iconPath: IconsPath.sendSmallWhite, height: 20),
            ),
          ),
        ],
      ),
    );
  }
}
