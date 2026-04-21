import 'dart:math';

import 'package:mama_app/app/helper_widgets_export.dart';
import 'package:mama_app/features/video_meeting/model/chat_message_live_model.dart';

class HeartAnimationWidget extends StatefulWidget {
  final String emoji;
  const HeartAnimationWidget({super.key, required this.emoji});

  @override
  State<HeartAnimationWidget> createState() => _HeartAnimationWidgetState();
}

class _HeartAnimationWidgetState extends State<HeartAnimationWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _y; // rise
  late final Animation<double> _opacity; // fade out near top
  late final Animation<double> _wave; // side waver
  late final Animation<double> _scale; // pop-in at start

  final _random = Random();
  late final double _startX; // random horizontal start near react button
  late final double _waveAmp; // how wide it sways

  @override
  void initState() {
    super.initState();

    _startX = _random.nextDouble() * 40 - 20; // -20..+20 px from center
    _waveAmp = 18 + _random.nextDouble() * 14; // 18..32 px sway width

    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200))
      ..forward();

    _y = Tween<double>(
      begin: 0,
      end: -280,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    _opacity = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 10), // fade in
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 60), // hold
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 30), // fade out
    ]).animate(_ctrl);

    _wave = Tween<double>(
      begin: 0,
      end: 2 * pi * 2.5,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.linear));

    _scale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.4, end: 1.3), weight: 15), // pop
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 10), // settle
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 75), // hold
    ]).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final dx = _startX + sin(_wave.value) * _waveAmp;
        return Transform.translate(
          offset: Offset(dx, _y.value),
          child: Opacity(
            opacity: _opacity.value.clamp(0.0, 1.0),
            child: Transform.scale(
              scale: _scale.value,
              child: Image.asset(
                reactionList
                    .firstWhere((element) => element.$2.toLowerCase() == widget.emoji.toLowerCase())
                    .$1,
                fit: BoxFit.cover,
                height: 22.h,
              ),
            ),
          ),
        );
      },
    );
  }
}
