import '../../../app/helper_widgets_export.dart';
import '../../../core/components/ui/dropdowns/cus_flexible_dropdown.dart';
import '../model/chat_message_live_model.dart';
import 'meet_bottom_action.dart';

class ReactButton extends StatefulWidget {
  final int count;
  final Future<void> Function(String emoji) sendReaction;
  const ReactButton({super.key, required this.count, required this.sendReaction});

  @override
  State<ReactButton> createState() => _ReactButtonState();
}

class _ReactButtonState extends State<ReactButton> {
  // A notifier the dropdown listens to for programmatic close
  final _closeNotifier = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _closeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final overlayHeight = 18.sp + (8.h * 2) + 80.h;

    return CusFlexibleDropdown(
      items: const [],
      offset: Offset(0, -overlayHeight),
      closeNotifier: _closeNotifier, // ← pass close signal to dropdown
      customOverlay: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: c.scaffoldBackground,
          borderRadius: 30.brdrRad,
          boxShadow: boxShadowAllSides,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: reactionList
              .map(
                (item) => GestureDetector(
                  onTap: () {
                    _closeNotifier.value = !_closeNotifier.value; // ← close overlay
                    widget.sendReaction(item.$2); // ← then send
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: Image.asset(item.$1, height: 22.h),
                  ),
                ),
              )
              .toList(),
        ),
      ),
      child: BottomAction(iconPath: IconsPath.likeHeartFilled, text: "React"),
    );
  }
}
