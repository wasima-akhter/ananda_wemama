import 'package:agora_rtm/agora_rtm.dart';

import '../../../../../app/controller_export.dart';
import '../../live_chat_controller.dart';

mixin RtmConnectionMixin on GetxController {
  LiveChatController get _self => this as LiveChatController;

  RxBool isRtmReady = false.obs;
  RxBool isRtmLoading = false.obs;

  void _onLinkState(LinkStateEvent event) {
    print('🔵 [RTM] LinkState: ${event.currentState}, reason: ${event.reason}');

    if (event.currentState == RtmLinkState.connected) {
      isRtmReady.value = true;
    } else if (event.currentState == RtmLinkState.disconnected ||
        event.currentState == RtmLinkState.failed) {
      isRtmReady.value = false;
    }
  }

  void _onToken(TokenEvent event) {
    print('⚠️ [RTM] Token event: ${event.channelName}');
    // TODO: refresh rtmToken from backend here
  }

  Future<void> initRtm() async {
    if (isRtmLoading.value) {
      print('⚠️ [RTM] Already loading — skipping');
      return;
    }

    if (_self.mc.appId.value.isEmpty) {
      print('❌ [RTM] appId is empty');
      return;
    }

    if (_self.mc.rtmToken.value.isEmpty) {
      print('❌ [RTM] rtmToken is empty');
      return;
    }

    if (_self.mc.channelName.value.isEmpty) {
      print('❌ [RTM] channelName is empty');
      return;
    }

    isRtmLoading.value = true;

    try {
      // Step 1: Create client — real factory is RTM()
      // uid must be a STRING, not int
      print('🔵 [RTM-1] Calling RTM() factory...');
      print('   appId: ${_self.mc.appId.value}');
      print('   userId: ${_self.mc.uid.value.toString()}');

      final (createStatus, client) = await RTM(
        _self.mc.appId.value,
        _self.mc.uid.value.toString(), // ← userId is a String in RTM v2
      );

      if (createStatus.error) {
        print(
          '❌ [RTM-1] RTM() failed — code: ${createStatus.errorCode}, reason: ${createStatus.reason}',
        );
        return;
      }

      _self.rtmClient = client;
      print('✅ [RTM-1] RtmClient created');

      // Step 2: Attach listeners BEFORE login
      _self.rtmClient!.addListener(
        linkState: _onLinkState,
        message: _self.onMessage,
        presence: _self.onPresence,
        token: _onToken,
      );
      print('✅ [RTM-2] Listeners attached');

      // Step 3: Login with token
      print('🔵 [RTM-3] Logging in...');
      final (loginStatus, loginResult) = await _self.rtmClient!.login(
        _self.mc.rtmToken.value,
      );

      if (loginStatus.error) {
        print(
          '❌ [RTM-3] Login failed — code: ${loginStatus.errorCode}, reason: ${loginStatus.reason}',
        );
        return;
      }

      print('✅ [RTM-3] Login success: $loginResult');

      // Step 4: Subscribe
      print('🔵 [RTM-4] Subscribing to: ${_self.mc.channelName.value}');
      final (subStatus, subResult) = await _self.rtmClient!.subscribe(
        _self.mc.channelName.value,
        withMessage: true,
        withPresence: true,
      );

      if (subStatus.error) {
        print(
          '❌ [RTM-4] Subscribe failed — code: ${subStatus.errorCode}, reason: ${subStatus.reason}',
        );
        return;
      }

      // After subscribe succeeds — set your presence state
      await _self.rtmClient!
          .getPresence()
          .setState(_self.mc.channelName.value, RtmChannelType.message, {
            'name': _self.mc.sessionInfo.value.userName ?? '',
            'avatar': _self.mc.sessionInfo.value.userAvatar ?? '',
            'isMuted': 'false',
          });

      print('✅ [RTM] Presence state set');
      print('✅ [RTM-4] Subscribed: $subResult');
      isRtmReady.value = true;
      print('✅ [RTM] FULLY READY');
    } catch (e, stack) {
      print('❌ [RTM] initRtm FAILED: $e');
      print('   $stack');
      isRtmReady.value = false;
    } finally {
      isRtmLoading.value = false;
    }
  }

  Future<void> disposeRtm() async {
    print('🔵 [RTM] Disposing...');

    // Remove named listeners cleanly
    try {
      _self.rtmClient?.removeListener(
        linkState: _onLinkState,
        message: _self.onMessage,
        presence: _self.onPresence,
        token: _onToken,
      );
      print('✅ [RTM] Listeners removed');
    } catch (e) {
      print('⚠️ [RTM] removeListener error: $e');
    }

    try {
      await _self.rtmClient?.unsubscribe(_self.mc.channelName.value);
      print('✅ [RTM] Unsubscribed');
    } catch (e) {
      print('⚠️ [RTM] unsubscribe error: $e');
    }

    try {
      if (_self.rtmClient != null) {
        final (status, _) = await _self.rtmClient!.logout();
        print(
          status.error
              ? '⚠️ [RTM] logout error: ${status.errorCode}'
              : '✅ [RTM] Logged out',
        );
      }
    } catch (e) {
      print('⚠️ [RTM] logout error: $e');
    }

    try {
      await _self.rtmClient?.release();
      print('✅ [RTM] Released');
    } catch (e) {
      print('⚠️ [RTM] release error: $e');
    }

    _self.rtmClient = null;
    isRtmReady.value = false;
    print('✅ [RTM] Disposed cleanly');
  }
}

//
