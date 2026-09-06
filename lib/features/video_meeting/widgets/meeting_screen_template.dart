import '../../../app/helper_widgets_export.dart';
import '../controller/meeting_controller.dart';

class MeetingScreenTemplate extends StatefulWidget {
  final Widget commentList;
  final Widget topContent;
  final Widget inputRow;
  final Widget? bottomActions;
  final Color? backgroundColor;
  final FocusNode inputFocus;

  const MeetingScreenTemplate({
    super.key,
    required this.commentList,
    required this.topContent,
    required this.inputRow,
    required this.inputFocus,
    this.bottomActions,
    this.backgroundColor,
  });

  @override
  State<MeetingScreenTemplate> createState() => _MeetingScreenTemplateState();
}

class _MeetingScreenTemplateState extends State<MeetingScreenTemplate>
    with WidgetsBindingObserver {
  bool _keyboardOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final keyboardOpen = View.of(context).viewInsets.bottom > 0;
    if (_keyboardOpen != keyboardOpen) {
      setState(() => _keyboardOpen = keyboardOpen);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mc = MeetingController.to;

    return SafeArea(
      top: false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Obx(() {
          // 🔴 During fullscreen, hide topContent to prevent overflow
          // FullscreenVideoPage (on top of navigation stack) shows the fullscreen video
          if (mc.isFullscreen.value) {
            return SizedBox.expand(child: Container(color: bgClr));
          }

          // ✅ Normal embedded layout
          return Column(
            children: [
              // ── Top content (fixed: header + video + participants) ──────────────
              Container(
                color: widget.backgroundColor ?? c.cardPrimary,
                child: widget.topContent,
              ),

              // ── Comment list (fills remaining space) ─────────────────────────────
              Expanded(
                child: Container(color: bgClr, child: widget.commentList),
              ),

              // ── Input + bottom actions (natural height, never hidden) ────────────
              Container(
                color: widget.backgroundColor ?? c.cardPrimary,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    widget.inputRow,
                    if (!_keyboardOpen && widget.bottomActions != null)
                      widget.bottomActions!.mT(5.h),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
