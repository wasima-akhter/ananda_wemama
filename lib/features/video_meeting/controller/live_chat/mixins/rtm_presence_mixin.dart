import 'package:agora_rtm/agora_rtm.dart';

import '../../../../../app/controller_export.dart';
import '../../../model/chat_message_live_model.dart';
import '../../live_chat_controller.dart';

mixin RtmPresenceMixin on GetxController {
  LiveChatController get _self => this as LiveChatController;

  RxInt viewCount = 0.obs;
  RxList<ParticipantModel> participants = <ParticipantModel>[].obs;

  void onPresence(PresenceEvent event) {
    print('👤 [RTM] Presence: ${event.type} — ${event.publisher}');

    switch (event.type) {
      case RtmPresenceEventType.snapshot:
        // Initial state when you first join — full member list
        final members = event.snapshot?.userStateList ?? [];

        participants.assignAll(
          members.map((m) {
            final stateMap = {
              for (StateItem s in (m.states ?? [])) s.key: s.value,
            };

            return ParticipantModel(
              uid: m.userId,
              name: stateMap['name'] ?? m.userId,
              avatar: stateMap['avatar'] ?? '',
              isMuted: stateMap['isMuted'] == 'true',
            );
          }),
        );
        participants.removeWhere(
          (element) => element.uid == _self.mc.uid.value.toString(),
        );

        viewCount.value = participants
            .where((p) => p.uid != _self.mc.uid.value.toString())
            .length;
        return;

      case RtmPresenceEventType.remoteJoinChannel:
        // Someone joined
        final uid = event.publisher ?? '';

        if (!participants.any((j) => j.uid == uid)) {
          final stateMap = {
            for (var s in (event.stateItems ?? [])) s.key: s.value,
          };

          participants.add(
            ParticipantModel(
              uid: uid,
              name: stateMap['name'] ?? uid,
              avatar: stateMap['avatar'] ?? '',
              isMuted: stateMap['isMuted'] == 'true',
            ),
          );
        }
        participants.removeWhere(
          (element) => element.uid == _self.mc.uid.value.toString(),
        );

        viewCount.value = participants
            .where((p) => p.uid != _self.mc.uid.value.toString())
            .length;
        print('✅ [RTM] Joiner added: $uid, total: ${viewCount.value}');
        return;

      case RtmPresenceEventType.remoteLeaveChannel:
      case RtmPresenceEventType.remoteTimeout:
        // Someone left
        participants.removeWhere((j) => j.uid == event.publisher);
        participants.removeWhere(
          (element) => element.uid == _self.mc.uid.value.toString(),
        );
        viewCount.value = participants
            .where((p) => p.uid != _self.mc.uid.value.toString())
            .length;
        print('✅ [RTM] Joiner removed: ${event.publisher}');
        return;

      case RtmPresenceEventType.remoteStateChanged:
        // Someone updated their state (e.g. muted/unmuted)
        final uid = event.publisher ?? '';

        final stateMap = {
          for (StateItem s in (event.stateItems ?? [])) s.key: s.value,
        };

        final index = participants.indexWhere((p) => p.uid == uid);

        if (index != -1 && stateMap.containsKey('isMuted')) {
          participants[index] = participants[index].copyWith(
            isMuted: stateMap['isMuted'] == 'true',
          );

          print('✅ [RTM] State changed for $uid: $stateMap');
        }

        return;

      default:
        // Optional: handle unknown events
        print('⚠️ [RTM] Unhandled presence event: ${event.type}');
        return;
    }
  }
}

//
