import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import '../../../app/helper_widgets_export.dart';
import '../controller/meeting_controller.dart';

class RemoteVideoView extends StatelessWidget {
  final MeetingController mc;
  const RemoteVideoView({
    super.key,
    required this.mc,
  }); // no super.key — GlobalKey is applied by the caller

  @override
  Widget build(BuildContext context) {
    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: mc.agoraEngine!,
        canvas: VideoCanvas(uid: mc.hostUid.value!),
        connection: RtcConnection(channelId: mc.channelName.value),
      ),
    );
  }
}
