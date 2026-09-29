// session_video_dialog.dart
import 'dart:io';
import 'dart:ui';

import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import '../../../../app/helper_widgets_export.dart';
import '../model/expert_session_list_model.dart';

enum _VideoState { loading, ready, error, empty }

class SessionVideoDialog extends StatefulWidget {
  final Session session;

  const SessionVideoDialog({super.key, required this.session});

  /// Opens the video popup for a session.
  static Future<void> show(Session session) {
    return Get.dialog(
      SessionVideoDialog(session: session),
      barrierColor: Colors.black,
      barrierDismissible: false,
      useSafeArea: false,
    );
  }

  @override
  State<SessionVideoDialog> createState() => _SessionVideoDialogState();
}

class _SessionVideoDialogState extends State<SessionVideoDialog> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  _VideoState _state = _VideoState.loading;
  String? _activeUrl;
  bool _triedFallback = false;

  bool _isDownloading = false;
  double _downloadProgress = 0;
  String? _downloadedPath;

  @override
  void initState() {
    super.initState();
    _start();
  }

  // mp4 first (direct, scrubbable), hls as fallback for streaming
  String? get _mp4Url => widget.session.recordingMp4Url.isNotEmpty
      ? widget.session.recordingMp4Url
      : null;

  String? get _hlsUrl => widget.session.recordingHlsUrl.isNotEmpty
      ? widget.session.recordingHlsUrl
      : null;

  Future<void> _start() async {
    final url = _mp4Url ?? _hlsUrl;
    print('url is : $url');
    print('_mp4Url is : $_mp4Url');
    print('_hlsUrl is : $_hlsUrl');
    if (url == null) {
      setState(() => _state = _VideoState.empty);
      return;
    }
    await _initPlayer(url);
  }

  Future<void> _initPlayer(String url) async {
    setState(() {
      _state = _VideoState.loading;
      _activeUrl = url;
    });

    _disposeControllers();

    try {
      final controller = VideoPlayerController.networkUrl(Uri.parse(url));
      await controller.initialize();

      final chewie = ChewieController(
        videoPlayerController: controller,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        allowPlaybackSpeedChanging: true,
        showControlsOnInitialize: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: c.primary,
          handleColor: c.primary,
          bufferedColor: Colors.white38,
          backgroundColor: Colors.white24,
        ),
        errorBuilder: (context, errorMessage) =>
            _ErrorState(message: errorMessage, onRetry: () => _initPlayer(url)),
      );

      if (!mounted) return;
      setState(() {
        _videoController = controller;
        _chewieController = chewie;
        _state = _VideoState.ready;
      });
    } catch (e, st) {
      print("❌ [SessionVideoDialog] failed to load $url: $e");
      print("$st");

      // one-time fallback: mp4 failed → try hls
      if (!_triedFallback && url == _mp4Url && _hlsUrl != null) {
        _triedFallback = true;
        return _initPlayer(_hlsUrl!);
      }

      if (!mounted) return;
      setState(() => _state = _VideoState.error);
    }
  }

  void _disposeControllers() {
    _chewieController?.dispose();
    _videoController?.dispose();
    _chewieController = null;
    _videoController = null;
  }

  Future<void> _download() async {
    final url = _activeUrl;
    if (url == null || _isDownloading) return;

    if (_downloadedPath != null && File(_downloadedPath!).existsSync()) {
      OpenFile.open(_downloadedPath!);
      return;
    }

    setState(() {
      _isDownloading = true;
      _downloadProgress = 0;
    });

    try {
      // App-sandboxed dir → no runtime storage permission needed on
      // Android 13+/iOS. Swap for a public Downloads dir if you need it
      // visible outside the app (needs permission_handler + storage perm).
      final dir = await getApplicationDocumentsDirectory();
      final ext = url.toLowerCase().endsWith(".m3u8") ? "m3u8" : "mp4";
      final savePath = "${dir.path}/session_${widget.session.id}.$ext";

      await Dio().download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total <= 0 || !mounted) return;
          setState(() => _downloadProgress = received / total);
        },
      );

      if (!mounted) return;
      setState(() {
        _isDownloading = false;
        _downloadedPath = savePath;
      });

      Get.snackbar(
        "Downloaded",
        "Video saved to your device",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, st) {
      print("❌ [SessionVideoDialog] download failed: $e");
      print("$st");
      if (!mounted) return;
      setState(() => _isDownloading = false);
      Get.snackbar(
        "Download failed",
        "Check your connection and try again",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.black,
        clipBehavior: Clip.antiAlias,
        child: SafeArea(
          child: SizedBox(
            // Anchor to the actual available screen size instead of
            // letting the Column size itself off its children.
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                _Header(
                  title: widget.session.title.capEachWord(),
                  onClose: () => Get.back(),
                ),

                // Expanded + Center+AspectRatio: the video box keeps a
                // 16:9 shape but is capped by whatever height/width is
                // actually left, in either orientation.
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: _buildBody(),
                    ),
                  ),
                ),

                if (_state == _VideoState.ready) _buildActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case _VideoState.loading:
        return _LoadingState(thumbnailUrl: widget.session.expert?.image);

      case _VideoState.empty:
        return const _EmptyState();

      case _VideoState.error:
        return _ErrorState(
          message: "This video couldn't be loaded",
          onRetry: () {
            _triedFallback = false;
            _start();
          },
        );

      case _VideoState.ready:
        return _chewieController != null
            ? Chewie(controller: _chewieController!)
            : const _LoadingState();
    }
  }

  Widget _buildActions() {
    return Container(
      width: double.infinity,
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.session.expert?.name.capEachWord() ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TxtStyle.outfit(fs: 13, color: Colors.white70),
            ),
          ),
          const Gap(8),
          _DownloadButton(
            isDownloading: _isDownloading,
            progress: _downloadProgress,
            isDownloaded: _downloadedPath != null,
            onTap: _download,
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final String title;
  final VoidCallback onClose;

  const _Header({required this.title, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close, color: Colors.white),
          ),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TxtStyle.outfitSemiB(fs: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  final String? thumbnailUrl;

  const _LoadingState({this.thumbnailUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if ((thumbnailUrl ?? "").isNotEmpty)
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: NetworkImageWidget(imageUrl: thumbnailUrl!),
          )
        else
          Container(color: Colors.grey.shade900),

        Container(color: Colors.black.withValues(alpha: 0.35)),

        const Center(child: CircularProgressIndicator(color: Colors.white)),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade900,
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.videocam_off_rounded, color: Colors.white54, size: 40),
            Gap(10),
            Text(
              "No recording available for this session",
              style: TextStyle(color: Colors.white70, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade900,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.white54,
              size: 40,
            ),
            const Gap(10),
            Text(
              message,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const Gap(14),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              label: const Text("Retry", style: TextStyle(color: Colors.white)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white38),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DownloadButton extends StatelessWidget {
  final bool isDownloading;
  final bool isDownloaded;
  final double progress;
  final VoidCallback onTap;

  const _DownloadButton({
    required this.isDownloading,
    required this.isDownloaded,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isDownloading ? null : onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isDownloading)
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                  value: progress > 0 ? progress : null,
                ),
              )
            else
              Icon(
                isDownloaded
                    ? Icons.check_circle_outline_rounded
                    : Icons.download_rounded,
                size: 16,
                color: Colors.white,
              ),
            const Gap(6),
            Text(
              isDownloading
                  ? "${(progress * 100).toStringAsFixed(0)}%"
                  : isDownloaded
                  ? "Open"
                  : "Download",
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
