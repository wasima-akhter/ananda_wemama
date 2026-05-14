import 'dart:convert';

import 'package:agora_rtm/agora_rtm.dart';

import '../../../../../app/controller_export.dart';
import '../../../model/chat_message_live_model.dart';
import '../../live_chat_controller.dart';

mixin RtmRaiseHandMixin on GetxController {
  LiveChatController get _self => this as LiveChatController;

  RxList<RaiseHandModel> raisedHands = <RaiseHandModel>[].obs;

  Future<void> toggleRaiseHand() async {
    if (!_self.isRtmReady.value || _self.rtmClient == null) return;

    final isRaised = raisedHands.any((h) => h.uid == _self.mc.uid.value.toString());

    final payload = jsonEncode({
      "type": isRaised ? "HAND_LOWER" : "RAISE_HAND",
      "sender": _self.mc.uid.value.toString(),
      "senderName": _self.mc.sessionInfo.value.userName ?? '',
      "senderAvatar": _self.mc.sessionInfo.value.userAvatar ?? '',
    });

    await _self.rtmClient!.publish(
      _self.mc.channelName.value,
      payload,
      channelType: RtmChannelType.message,
    );

    if (isRaised) {
      raisedHands.removeWhere((h) => h.uid == _self.mc.uid.value.toString());
    } else {
      raisedHands.add(
        RaiseHandModel(
          uid: _self.mc.uid.value.toString(),
          name: _self.mc.sessionInfo.value.userName ?? '',
          avatar: _self.mc.sessionInfo.value.userAvatar ?? '',
        ),
      );
    }
  }

  // Computed bool for UI button state
  bool get isHandRaised => raisedHands.any((h) => h.uid == _self.mc.uid.value.toString());
}