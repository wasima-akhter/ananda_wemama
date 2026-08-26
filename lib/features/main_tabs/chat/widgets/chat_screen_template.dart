import '../../../../app/helper_widgets_export.dart';

class ChatScreenTemplate extends StatelessWidget {
  final Widget child; // message list
  final Widget inputRow; // chat input
  final PreferredSizeWidget? appBar;
  final Color? backgroundColor;

  const ChatScreenTemplate({
    super.key,
    required this.child,
    required this.inputRow,
    this.appBar,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: backgroundColor ?? bgClrNew,
        resizeToAvoidBottomInset:
            true, // 👈 scaffold shrinks body when keyboard opens
        appBar: appBar,
        body: Column(
          children: [
            Expanded(
              child: child, // 👈 message list shrinks as keyboard grows
            ),
            inputRow, // 👈 always at bottom, pushed up by keyboard
          ],
        ),
      ),
    );
  }
}
