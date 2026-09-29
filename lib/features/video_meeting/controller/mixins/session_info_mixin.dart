import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:we_mama/features/video_meeting/model/live_session_info_model.dart';
import 'package:we_mama/features/video_meeting/services/meeting_service.dart';

import '../../../../app/controller_export.dart';
import '../meeting_controller.dart';

mixin SessionInfoMixin on GetxController {
  MeetingController get _self => this as MeetingController;

  /// -------------------- Session Info -------------------- ///

  RxBool isSessionInfoLoading = false.obs;

  /// Backend response model
  final sessionInfo = LiveSessionInfoModel().obs;

  /// 🔹 Fetch token + channel + uid from backend
  // Future<void> getSessionsInfo() async {
  //   print('🔴 ===== GETSESSIONSINFO CALLED ====='); // First line
  //   print('🔴 ===== print GETSESSIONSINFO CALLED ====='); // First line
  //   if (isSessionInfoLoading.value) return;

  //   isSessionInfoLoading.value = true;

  //   try {
  //     final data = await MeetingService().fetchSessionsInfo(
  //       channelName: _self.agrModel.channelname,
  //     );

  //     if (data != null) {
  //       sessionInfo.value = data;

  //       /// Debug logs (VERY useful for Agora debugging)
  //       print('📦 Parsed model rtmToken: ${data.rtmToken}');
  //       print('📦 Parsed model rtcToken: ${data.rtcToken}');
  //       print('📦 Parsed model channel: ${data.channelName}');
  //       print('📦 Parsed model uid: ${data.uid}');
  //     }

  //     /// Small delay for smoother UX
  //     await Future.delayed(const Duration(milliseconds: 600));
  //   } catch (e) {
  //     print('getSessionsInfo error: $e');
  //   } finally {
  //     isSessionInfoLoading.value = false;
  //   }

  //   print('🔴 ===== GETSESSIONSINFO COMPLETED ====='); // last line
  //   print('🔴 ===== print GETSESSIONSINFO COMPLETED ====='); // last line
  // }

  Future<void> getSessionsInfo() async {
    print('🔴 ===== print GETSESSIONSINFO CALLED ====='); // First line
    print('🔴 ===== GETSESSIONSINFO CALLED =====');

    // ADD THIS:
    print('🔵 Checking network connectivity...');
    final List<ConnectivityResult> connectivityResults = await Connectivity()
        .checkConnectivity();

    print('🔵 Network status: $connectivityResults');

    final isConnected =
        connectivityResults.isNotEmpty &&
        !connectivityResults.contains(ConnectivityResult.none);

    if (!isConnected) {
      print('❌ NO NETWORK CONNECTION');

      isSessionInfoLoading.value = false;
      Snack.showError('No internet connection');
      return;
    }

    if (isSessionInfoLoading.value) return;

    isSessionInfoLoading.value = true;

    try {
      print('🔵 About to call fetchSessionsInfo()');
      final startTime = DateTime.now();
      print('🔵 API call start time: $startTime');

      final data = await MeetingService().fetchSessionsInfo(
        channelName: _self.agrModel.channelname,
      );

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      print('🟢 API call completed in ${duration.inSeconds}s');

      if (data != null) {
        sessionInfo.value = data;
        print('📦 Parsed model rtmToken: ${data.rtmToken}');
        print('📦 Parsed model rtcToken: ${data.rtcToken}');
        print('📦 Parsed model channel: ${data.channelName}');
        print('📦 Parsed model uid: ${data.uid}');
      } else {
        print('⚠️ fetchSessionsInfo returned null');
      }

      await Future.delayed(const Duration(milliseconds: 600));
    } catch (e) {
      print('❌ getSessionsInfo error: $e');
      print('❌ Error type: ${e.runtimeType}');
    } finally {
      isSessionInfoLoading.value = false;
    }

    print('🔴 ===== GETSESSIONSINFO COMPLETED =====');
    print('🔴 ===== print GETSESSIONSINFO COMPLETED ====='); // last line
  }
}
