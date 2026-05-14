import 'package:agora_rtm/agora_rtm.dart';

import '../../../../../app/controller_export.dart';
import '../../live_chat_controller.dart';

mixin RtmConnectionMixin on GetxController {
  LiveChatController get _self => this as LiveChatController;

  RxBool isRtmReady = false.obs;
  RxBool isRtmLoading = false.obs;

  void _onLinkState(LinkStateEvent event) {
    log('🔵 [RTM] LinkState: ${event.currentState}, reason: ${event.reason}');

    if (event.currentState == RtmLinkState.connected) {
      isRtmReady.value = true;
    } else if (event.currentState == RtmLinkState.disconnected ||
        event.currentState == RtmLinkState.failed) {
      isRtmReady.value = false;
    }
  }

  void _onToken(TokenEvent event) {
    log('⚠️ [RTM] Token event: ${event.channelName}');
    // TODO: refresh rtmToken from backend here
  }

  Future<void> initRtm() async {
    if (isRtmLoading.value) {
      log('⚠️ [RTM] Already loading — skipping');
      return;
    }

    if (_self.mc.appId.value.isEmpty) {
      log('❌ [RTM] appId is empty');
      return;
    }

    if (_self.mc.rtmToken.value.isEmpty) {
      log('❌ [RTM] rtmToken is empty');
      return;
    }

    if (_self.mc.channelName.value.isEmpty) {
      log('❌ [RTM] channelName is empty');
      return;
    }

    isRtmLoading.value = true;

    try {
      // Step 1: Create client — real factory is RTM()
      // uid must be a STRING, not int
      log('🔵 [RTM-1] Calling RTM() factory...');
      log('   appId: ${_self.mc.appId.value}');
      log('   userId: ${_self.mc.uid.value.toString()}');

      final (createStatus, client) = await RTM(
        _self.mc.appId.value,
        _self.mc.uid.value.toString(), // ← userId is a String in RTM v2
      );

      if (createStatus.error) {
        log(
          '❌ [RTM-1] RTM() failed — code: ${createStatus.errorCode}, reason: ${createStatus.reason}',
        );
        return;
      }

      _self.rtmClient = client;
      log('✅ [RTM-1] RtmClient created');

      // Step 2: Attach listeners BEFORE login
      _self.rtmClient!.addListener(
        linkState: _onLinkState,
        message: _self.onMessage,
        presence: _self.onPresence,
        token: _onToken,
      );
      log('✅ [RTM-2] Listeners attached');

      // Step 3: Login with token
      log('🔵 [RTM-3] Logging in...');
      final (loginStatus, loginResult) = await _self.rtmClient!.login(_self.mc.rtmToken.value);

      if (loginStatus.error) {
        log(
          '❌ [RTM-3] Login failed — code: ${loginStatus.errorCode}, reason: ${loginStatus.reason}',
        );
        return;
      }

      log('✅ [RTM-3] Login success: $loginResult');

      // Step 4: Subscribe
      log('🔵 [RTM-4] Subscribing to: ${_self.mc.channelName.value}');
      final (subStatus, subResult) = await _self.rtmClient!.subscribe(
        _self.mc.channelName.value,
        withMessage: true,
        withPresence: true,
      );

      if (subStatus.error) {
        log(
          '❌ [RTM-4] Subscribe failed — code: ${subStatus.errorCode}, reason: ${subStatus.reason}',
        );
        return;
      }

      // After subscribe succeeds — set your presence state
      await _self.rtmClient!.getPresence().setState(
        _self.mc.channelName.value,
        RtmChannelType.message,
        {
          'name': _self.mc.sessionInfo.value.userName ?? '',
          'avatar': _self.mc.sessionInfo.value.userAvatar ?? '',
          'isMuted': 'false',
        },
      );

      log('✅ [RTM] Presence state set');
      log('✅ [RTM-4] Subscribed: $subResult');
      isRtmReady.value = true;
      log('✅ [RTM] FULLY READY');
    } catch (e, stack) {
      log('❌ [RTM] initRtm FAILED: $e');
      log('   $stack');
      isRtmReady.value = false;
    } finally {
      isRtmLoading.value = false;
    }
  }

  Future<void> disposeRtm() async {
    log('🔵 [RTM] Disposing...');

    // Remove named listeners cleanly
    try {
      _self.rtmClient?.removeListener(
        linkState: _onLinkState,
        message: _self.onMessage,
        presence: _self.onPresence,
        token: _onToken,
      );
      log('✅ [RTM] Listeners removed');
    } catch (e) {
      log('⚠️ [RTM] removeListener error: $e');
    }

    try {
      await _self.rtmClient?.unsubscribe(_self.mc.channelName.value);
      log('✅ [RTM] Unsubscribed');
    } catch (e) {
      log('⚠️ [RTM] unsubscribe error: $e');
    }

    try {
      if (_self.rtmClient != null) {
        final (status, _) = await _self.rtmClient!.logout();
        log(
          status.error
              ? '⚠️ [RTM] logout error: ${status.errorCode}'
              : '✅ [RTM] Logged out',
        );
      }
    } catch (e) {
      log('⚠️ [RTM] logout error: $e');
    }

    try {
      await _self.rtmClient?.release();
      log('✅ [RTM] Released');
    } catch (e) {
      log('⚠️ [RTM] release error: $e');
    }

    _self.rtmClient = null;
    isRtmReady.value = false;
    log('✅ [RTM] Disposed cleanly');
  }
}