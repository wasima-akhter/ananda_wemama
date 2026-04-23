import '../../../../app/helper_widgets_export.dart';
import '../controller/chat_inbox_controller.dart';

class ChatBubbleCont extends StatelessWidget {
  final FakeMsgItemData message;

  const ChatBubbleCont({super.key, required this.message});

  bool get _isMe => message.isSentByMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: 4.pv,
      child: Row(
        mainAxisAlignment: _isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_isMe) _timeWidget(),

          Flexible(child: _bubble()),
        ],
      ),
    );
  }

  // Widget _bubble() {
  //   return UnconstrainedBox(
  //     alignment: _isMe ? Alignment.centerRight : Alignment.centerLeft,
  //     child: ConstrainedBox(
  //       constraints: BoxConstraints(maxWidth: S.w * 0.7),
  //       child: ContainerBordered(
  //         rad: 12,
  //         vp: 10,
  //         hp: 12,
  //         contClr: _isMe ? c.bottomSheetBackground : c.cardPrimary,
  //         alignment: _isMe ? null : Alignment.centerLeft,
  //         child: Row(
  //           mainAxisSize: MainAxisSize.min, // 👈
  //           crossAxisAlignment: CrossAxisAlignment.end,
  //           children: [
  //             Flexible(
  //               // 👈 not Expanded
  //               child: Text(
  //                 message.msg,

  //                 textAlign: TextAlign.start,
  //                 style: TxtStyle.outfit(w: _isMe ? 500 : 400, color: c.secondary),
  //               ),
  //             ),
  //             Gap(itemGap),
  //             if (!_isMe) _timeWidget(),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  Widget _bubble() {
    return Align(
      alignment: _isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: Get.width * 0.7),
        child: ContainerBordered(
          rad: 12,
          vp: 10,
          hp: 12,
          contClr: _isMe ? c.bottomSheetBackground : c.cardPrimary,
          alignment: null, // ← stop ContainerBordered from forcing full width
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  message.msg,
                  textAlign: TextAlign.start,
                  style: TxtStyle.outfit(w: _isMe ? 500 : 400, color: c.secondary),
                ),
              ),
              Gap(itemGap),
              if (!_isMe) _timeWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _timeWidget() {
    return Container(
      // color: Colors.amber,
      padding: 2.ph,
      child: Text(
        maxLines: 2,
        softWrap: true,
        overflow: TextOverflow.visible,
        message.time,
        style: TxtStyle.outfitSemiB(fs: 11, w: 500, color: c.secondary),
      ),
    );
  }
}
