import 'dart:math';

import 'package:we_mama/app/helper_widgets_export.dart';
import 'package:we_mama/features/video_meeting/model/chat_message_live_model.dart';

class HeartAnimationWidget extends StatefulWidget {
  final String emoji;
  const HeartAnimationWidget({super.key, required this.emoji});

  @override
  State<HeartAnimationWidget> createState() => _HeartAnimationWidgetState();
}

class _HeartAnimationWidgetState extends State<HeartAnimationWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _y;
  late final Animation<double> _opacity;
  late final Animation<double> _wave;
  late final Animation<double> _scale;
  late final Animation<double> _rotation;

  final _random = Random();

  late final double _startX;
  late final double _waveAmp;
  late final double _endY;
  late final int _durationMs;
  late final double _waveCycles;
  late final Curve _curve;

  @override
  void initState() {
    super.initState();

    /// 🎯 RANDOMIZE EVERYTHING IMPORTANT
    _startX = _random.nextDouble() * 60 - 30; // wider spread
    _waveAmp = 12 + _random.nextDouble() * 28; // 12–40
    _endY = -220 - _random.nextDouble() * 120; // different heights
    _durationMs = 1800 + _random.nextInt(1200); // 1.8s – 3s
    _waveCycles = 1.5 + _random.nextDouble() * 2.5; // wave variation

    _curve = [
      Curves.easeOut,
      Curves.easeOutQuad,
      Curves.easeOutCubic,
      Curves.easeOutQuart,
    ][_random.nextInt(4)];

    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _durationMs),
    )..forward();

    _y = Tween<double>(
      begin: 0,
      end: _endY,
    ).animate(CurvedAnimation(parent: _ctrl, curve: _curve));

    _opacity = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 10),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 30),
    ]).animate(_ctrl);

    _wave = Tween<double>(begin: 0, end: 2 * pi * _waveCycles).animate(_ctrl);

    _scale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.4, end: 1.3), weight: 15),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 10),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 75),
    ]).animate(_ctrl);

    /// 🔥 subtle rotation (makes it feel alive)
    _rotation = Tween<double>(
      begin: -0.2,
      end: 0.2,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
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
      builder: (_, _) {
        final dx = _startX + sin(_wave.value) * _waveAmp;

        return Transform.translate(
          offset: Offset(dx, _y.value),
          child: Opacity(
            opacity: _opacity.value.clamp(0.0, 1.0),
            child: Transform.rotate(
              angle: _rotation.value,
              child: Transform.scale(
                scale: _scale.value,
                child: Image.asset(
                  reactionList
                      .firstWhere(
                        (e) => e.$2.toLowerCase() == widget.emoji.toLowerCase(),
                      )
                      .$1,
                  height: 22.h,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
