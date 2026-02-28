import 'package:lottie/lottie.dart';

import '../../app/helper_widgets_export.dart';

class Loading extends StatelessWidget {
  final double? size;
  const Loading({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        ImagesPath.loadingJson,

        width: size ?? 21,
        height: size ?? 21,
        repeat: true,
        animate: true,
      ),
    );
  }
}

class DoneAnimation extends StatelessWidget {
  final double? size;
  const DoneAnimation({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        ImagesPath.doneJson,

        width: size ?? 1.sw * 0.5,
        height: size ?? 1.sw * 0.5,
        repeat: true,
        animate: true,
      ),
    );
  }
}
