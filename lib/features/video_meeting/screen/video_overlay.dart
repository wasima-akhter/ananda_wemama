// features/meeting/view/fullscreen_video_page.dart

import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import '../../../app/helper_widgets_export.dart';
import '../controller/fullscreen_video_controller.dart';
import '../controller/meeting_controller.dart';

class FullscreenVideoPage extends StatefulWidget {
  final MeetingController mc;

  const FullscreenVideoPage({super.key, required this.mc});

  @override
  State<FullscreenVideoPage> createState() => _FullscreenVideoPageState();
}

class _FullscreenVideoPageState extends State<FullscreenVideoPage> {
  final fsc = Get.put(FullscreenVideoController());

  // FullscreenVideoPage
  @override
  void initState() {
    super.initState();
    fsc.enterFullscreen();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.mc.isFullscreen.value = true;
      widget.mc.videoViewGeneration.value++; // 👈 force a genuinely new key
    });
  }

  @override
  void dispose() {
    fsc.exitFullscreen();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.mc.isFullscreen.value = false;
      widget.mc.videoViewGeneration.value++; // 👈 bump again on exit
    });
    Get.delete<FullscreenVideoController>();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    await fsc.exitFullscreen();
    await Future.delayed(const Duration(milliseconds: 150));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final mc = widget.mc;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => _onWillPop(),

      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ── Video fills entire screen ─────────────────────────
              Obx(() {
                if (!mc.isEngineReady.value ||
                    mc.agoraEngine == null ||
                    mc.remoteUids.isEmpty) {
                  return const Center(child: LoadingPrimary());
                }
                if (!mc.isHostVideoOn.value) {
                  return const Center(
                    child: Text(
                      "Camera off",
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                return AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine: mc.agoraEngine!,
                    canvas: VideoCanvas(uid: mc.hostUid.value!),
                    connection: RtcConnection(channelId: mc.channelName.value),
                  ),
                );
              }),

              // ── Exit button (top-left, safe tap target) ───────────
              Positioned(
                top: 12,
                left: 12,
                child: SafeArea(
                  child: GestureDetector(
                    onTap: () async {
                      await fsc.exitFullscreen();
                      await Future.delayed(
                        const Duration(milliseconds: 150),
                      ); // 👈 let Agora detach cleanly

                      Get.back();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(
                        Icons.fullscreen_exit,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*

This is a common issue with `AgoraVideoView` on Flutter. The video renderer sometimes doesn't relayout correctly when the widget moves between fullscreen and embedded mode, especially after route transitions.

From your code, I don't think the problem is the `AspectRatio`. It's more likely that the `AgoraVideoView` is keeping its previous surface size.

## Solution 1 (Most likely to fix it)

Force Flutter to recreate the `AgoraVideoView` after returning from fullscreen.

Instead of:

```dart
AgoraVideoView(
  controller: VideoViewController.remote(
    rtcEngine: mc.agoraEngine!,
    canvas: VideoCanvas(uid: mc.hostUid.value!),
    connection: RtcConnection(channelId: mc.channelName.value),
  ),
)
```

use

```dart
AgoraVideoView(
  key: ValueKey(
    '${mc.hostUid.value}_${mc.isFullscreen.value}',
  ),
  controller: VideoViewController.remote(
    rtcEngine: mc.agoraEngine!,
    canvas: VideoCanvas(uid: mc.hostUid.value!),
    connection: RtcConnection(
      channelId: mc.channelName.value,
    ),
  ),
)
```

or even

```dart
key: UniqueKey(),
```

when exiting fullscreen.

---

## Solution 2

When returning:

```dart
await Get.to(() => FullscreenVideoPage(mc: mc));
```

do

```dart
await Get.to(() => FullscreenVideoPage(mc: mc));

WidgetsBinding.instance.addPostFrameCallback((_) {
  mc.update();
});
```

or

```dart
setState(() {});
```

to force a rebuild.

---

## Solution 3

Your fullscreen page also uses

```dart
AgoraVideoView(
  controller: VideoViewController.remote(...)
)
```

This means **two different AgoraVideoViews are rendering the same remote stream**.

Sometimes Agora doesn't like switching between two renderers quickly.

Instead of pushing another page with another renderer, keep **one** renderer and animate it to fullscreen using a `Hero` or `AnimatedContainer`.

---

## Solution 4

If you want to keep two pages, dispose the fullscreen renderer before popping.

```dart
onTap: () async {
  await fsc.exitFullscreen();

  await Future.delayed(const Duration(milliseconds: 100));

  Get.back();
}
```

The small delay allows Agora to detach the renderer.

---

## Solution 5 (Check render mode)

What render mode are you using?

If you never set one, try

```dart
VideoCanvas(
  uid: mc.hostUid.value!,
  renderMode: RenderModeType.renderModeFit,
)
```

or

```dart
renderMode: RenderModeType.renderModeHidden,
```

depending on whether you want the entire video visible or filled.

---

## I suspect this is actually the issue

The symptom:

> after shrinking fullscreen, the video cuts off slightly

is very typical of the underlying native view not recalculating its size after a route transition.

Can you tell me:

1. Which version of `agora_rtc_engine` are you using?
2. Does the video look **zoomed/cropped**, or does it stay at the **fullscreen size** and get clipped inside the smaller container?

Those details will help determine whether it's a renderer reuse issue or a layout issue.
*/
