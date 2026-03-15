import '../../../app/helper_widgets_export.dart';

/*
class MeetingScreenTemplate extends StatelessWidget {
  final Widget commentList;
  final Widget topContent;
  final Widget inputRow;
  final Widget? bottomActions;
  final Color? backgroundColor;

  const MeetingScreenTemplate({
    super.key,
    required this.commentList,
    required this.topContent,
    required this.inputRow,
    this.bottomActions,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: backgroundColor ?? c.cardPrimary,
        resizeToAvoidBottomInset: true, // 👈 shrinks body when keyboard opens
        body: Column(
          children: [
            // top content — fixed, doesn't shrink
            topContent,

            // comment list — expands/shrinks as keyboard opens
            Expanded(
              child: Container(color: bgClr, child: commentList),
            ),

            Container(
              color: keyboardOpen ? ctransp : c.cardPrimary,
              child: Column(
                children: [
                  // input row — always just above keyboard
                  inputRow,

                  // bottom actions — hidden when keyboard open
                  if (!keyboardOpen && bottomActions != null) bottomActions!,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
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

class _MeetingScreenTemplateState extends State<MeetingScreenTemplate> with WidgetsBindingObserver {
  bool _keyboardOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // 👈 observe keyboard changes
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    // 👈 fires reliably whenever keyboard opens or closes
    final keyboardOpen = WidgetsBinding.instance.window.viewInsets.bottom > 0;
    if (_keyboardOpen != keyboardOpen) {
      setState(() => _keyboardOpen = keyboardOpen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Container(color: widget.backgroundColor ?? c.cardPrimary, child: widget.topContent),
            Expanded(
              child: Stack(
                children: [
                  // comment list takes full space
                  Positioned.fill(
                    child: Container(color: bgClr, child: widget.commentList),
                  ),

                  // input + bottom actions float at bottom
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  //
}
