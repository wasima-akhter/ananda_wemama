import 'package:mama_app/features/video_meeting/model/live_session_info_model.dart';
import 'package:mama_app/features/video_meeting/services/meeting_service.dart';

import '../../../../app/controller_export.dart';
import '../meeting_controller.dart';

mixin SessionInfoMixin on GetxController {
  MeetingController get _self => this as MeetingController;

  /// -------------------- Session Info -------------------- ///

  RxBool isSessionInfoLoading = false.obs;

  /// Backend response model
  final sessionInfo = LiveSessionInfoModel().obs;

  /// 🔹 Fetch token + channel + uid from backend
  Future<void> getSessionsInfo() async {
    if (isSessionInfoLoading.value) return;

    isSessionInfoLoading.value = true;

    try {
      final data = await MeetingService().fetchSessionsInfo(
        channelName: _self.agrModel.channelname,
      );

      if (data != null) {
        sessionInfo.value = data;

        /// Debug logs (VERY useful for Agora debugging)
        debugPrint('📦 Parsed model rtmToken: ${data.rtmToken}');
        debugPrint('📦 Parsed model rtcToken: ${data.rtcToken}');
        debugPrint('📦 Parsed model channel: ${data.channelName}');
        debugPrint('📦 Parsed model uid: ${data.uid}');
      }

      /// Small delay for smoother UX
      await Future.delayed(const Duration(milliseconds: 600));
    } catch (e) {
      debugPrint('getSessionsInfo error: $e');
    } finally {
      isSessionInfoLoading.value = false;
    }
  }
}
