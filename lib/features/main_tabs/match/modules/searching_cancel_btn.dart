import '../../../../app/helper_widgets_export.dart';
import '../controller/match_controller.dart';

class SearchingCancelButton extends StatelessWidget {
  const SearchingCancelButton({super.key});

  Widget _ring(double progress, double delay, double opacity) {
    final p = (progress + delay) % 1;

    return Transform.scale(
      scale: 1 + p * 2.4,
      child: Opacity(
        opacity: (1 - p) * opacity,
        child: Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: c.inputBackground, width: 4),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mc = MatchController.to;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(seconds: 2),
      curve: Curves.linear,
      onEnd: () {
        if (mc.matchState.value == MatchState.searching) {
          mc.update(); // trigger rebuild for loop
        }
      },
      builder: (context, value, _) {
        return SizedBox(
          width: 150,
          height: 150,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _ring(value, 0.0, .35),
              _ring(value, .2, .30),
              _ring(value, .4, .25),
              _ring(value, .6, .20),
              _ring(value, .8, .15),

              /// cancel button
              GestureDetector(
                onTap: mc.cancelSearch,
                child: CircleAvatar(
                  radius: 45.r,
                  backgroundColor: c.inputBackground,
                  child: Text(
                    Strings.cancel,
                    style: TxtStyle.outfit(fs: 13, color: c.strokePrimary),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
