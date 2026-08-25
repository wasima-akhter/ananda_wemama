import '../../../app/helper_widgets_export.dart';
import '../controller/live_chat_controller.dart';
import '../widgets/heart_animation_widget.dart';

class MeetHeartWidget extends StatelessWidget {
  const MeetHeartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cc = LiveChatController.to;
    return Obx(() {
      return Stack(
        clipBehavior: Clip.none,
        children: cc.hearts.map((heart) {
          return HeartAnimationWidget(
            key: ValueKey(heart.id),
            emoji: heart.emoji,
          );
        }).toList(),
      );
    });
  }
}
