import '../../../../app/helper_widgets_export.dart';
import '../controller/chat_inbox_controller.dart';

class ChatBubbleCont extends StatelessWidget {
  final FakeMsgItemData message;

  const ChatBubbleCont({super.key, required this.message});

  bool get _isMe => message.isSentByMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
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

  Widget _bubble() {
    return UnconstrainedBox(
      alignment: _isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: _isMe ? S.w * 0.7 : double.infinity),
        child: ContainerBordered(
          rad: 12,
          vp: 10,
          hp: 12,
          contClr: _isMe ? c.secondary : ctransp,
          alignment: _isMe ? null : Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min, // 👈
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                // 👈 not Expanded
                child: Text(
                  message.msg,
                  textAlign: TextAlign.left,
                  style: TxtStyle.outfit(w: _isMe ? 500 : 400, color: _isMe ? white : c.secondary),
                ),
              ),
              if (!_isMe) _timeWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _timeWidget() {
    return Container(
      padding: 8.ph,
      child: Text(message.time, style: TxtStyle.outfitSemiB(fs: 11, w: 500, color: c.secondary)),
    );
  }
}
