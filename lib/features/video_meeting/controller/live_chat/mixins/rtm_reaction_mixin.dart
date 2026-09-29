import 'dart:convert';

import 'package:agora_rtm/agora_rtm.dart';

import '../../../../../app/controller_export.dart';
import '../../live_chat_controller.dart';

mixin RtmReactionMixin on GetxController {
  LiveChatController get _self => this as LiveChatController;

  RxInt reactionCount = 0.obs;
  final hearts =
      <({int id, String emoji})>[].obs; // each int is a unique animation id

  Future<void> sendReaction(String emoji) async {
    Get.back();
    print('sent emoji : $emoji');
    if (!_self.isRtmReady.value || _self.rtmClient == null) return;

    final payload = jsonEncode({
      "type": "LIKE",
      "emoji": emoji,
      "sender": _self.mc.uid.value.toString(),
      "senderName": _self.mc.sessionInfo.value.userName ?? '',
    });

    final (status, _) = await _self.rtmClient!.publish(
      _self.mc.channelName.value,
      payload,
      channelType: RtmChannelType.message,
    );

    if (status.error) {
      print('❌ [RTM] Reaction failed: ${status.errorCode}');
      return;
    }

    reactionCount.value++;
    triggerHeartAnimation(emoji);
  }

  void triggerHeartAnimation(String emoji) {
    final id = DateTime.now().millisecondsSinceEpoch;
    hearts.add((id: id, emoji: emoji));
    Future.delayed(const Duration(seconds: 2), () {
      hearts.removeWhere((h) => h.id == id);
    });
  }
}
