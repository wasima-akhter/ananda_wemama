// features/meeting/view/fullscreen_video_page.dart

import '../../../app/helper_widgets_export.dart';
import '../controller/fullscreen_video_controller.dart';
import '../controller/meeting_controller.dart';
import '../modules/video_content/shared_agora_video_view.dart';

class FullscreenVideoPage extends StatefulWidget {
  const FullscreenVideoPage({super.key});

  @override
  State<FullscreenVideoPage> createState() => _FullscreenVideoPageState();
}

class _FullscreenVideoPageState extends State<FullscreenVideoPage> {
  final mc = MeetingController.to;
  final fsc = Get.put(FullscreenVideoController());

  @override
  void initState() {
    super.initState();

    fsc.enterFullscreen();

    // ✅ Defer state change until AFTER build completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      mc.isFullscreen.value = true;
    });
  }

  @override
  void dispose() {
    fsc.exitFullscreen();

    // 🔴 DO NOT set isFullscreen.value here — it triggers rebuilds during dispose
    // Instead, defer it to after the widget is fully removed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mc.isFullscreen.value = false;
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => _onWillPop(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ✅ Single shared video renderer — handles all state internally
              // The key includes isFullscreen.value, forcing proper size recalculation
              SharedAgoraVideoView(fit: BoxFit.cover),

              // ── Exit button (top-left) ───────────────────────────────────
              Positioned(
                top: 12,
                left: 12,
                child: SafeArea(
                  child: GestureDetector(
                    onTap: () async {
                      await fsc.exitFullscreen();
                      await Future.delayed(const Duration(milliseconds: 150));
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
KEY CHANGES FROM ORIGINAL:

❌ REMOVED:
  - Large Obx(() { if (!mc.isEngineReady.value) ... }) block with duplicate AgoraVideoView
  - Duplicate video state checks (isEngineReady, agoraEngine, remoteUids, isHostVideoOn)
  - Duplicate VideoViewController.remote() setup

✅ ADDED:
  - Single line: SharedAgoraVideoView(mc: mc, fit: BoxFit.cover)
  - All video state logic now handled in one place

WHY THIS FIXES THE RESIZE BUG:

1. Before: Two separate AgoraVideoView instances (TopContent + FullscreenVideoPage)
   → Agora native renderer confused about which surface to render to
   → Native layer doesn't recalculate size on route transition
   → Video appears cut off when returning to embedded view

2. After: One SharedAgoraVideoView instance, used in both places
   → Same renderer in different layout contexts (16:9 vs fullscreen)
   → Key includes isFullscreen.value → when it changes, Flutter destroys & recreates
   → Fresh renderer instance gets correct layout constraints
   → Native layer recalculates surface size properly

The key that fixes it:
  key: ValueKey(
    'video_${mc.hostUid.value}_${mc.isFullscreen.value}_${mc.videoViewGeneration.value}',
  )

When isFullscreen.value flips from false→true (entering fullscreen):
  Key changes → Widget rebuilds → AgoraVideoView recreated → Agora gets correct constraints

When isFullscreen.value flips from true→false (exiting fullscreen):
  Key changes → Widget rebuilds → AgoraVideoView recreated → Agora resizes to 16:9 properly
*/
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
