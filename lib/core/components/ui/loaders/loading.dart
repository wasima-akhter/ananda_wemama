import 'package:lottie/lottie.dart';

import '../../../../app/helper_widgets_export.dart';

class LoadingWhite extends StatelessWidget {
  final double? size;
  const LoadingWhite({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (size ?? 15.0).h,
      width: (size ?? 15.0).w,
      child: CircularProgressIndicator(color: white, strokeWidth: 2.5),
    );
    // SizedBox(
    //   width: (size ?? 40).w,
    //   height: (size ?? 20).w, // half height to clip letterbox padding
    //   child: OverflowBox(
    //     maxWidth: (size ?? 40).w * 2,
    //     maxHeight: (size ?? 40).w,
    //     child:
    //     Lottie.asset(
    //       ImagesPath.whiteLoading,
    //       width: (size ?? 40).w * 2,
    //       height: (size ?? 40).w,
    //       fit: BoxFit.contain,
    //       repeat: true,
    //       animate: true,
    //     ),
    //   ),
    // );
  }
}

class LoadingPrimary extends StatelessWidget {
  final double? size;
  const LoadingPrimary({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (size ?? 15.0).h,
      width: (size ?? 15.0).w,
      child: CircularProgressIndicator(color: c.primary, strokeWidth: 2.5),
    );
    // SizedBox(
    //   width: (size ?? 40).w,
    //   height: (size ?? 20).w, // half height to clip letterbox padding
    //   child: OverflowBox(
    //     maxWidth: (size ?? 40).w * 2,
    //     maxHeight: (size ?? 40).w,
    //     child: Lottie.asset(
    //       ImagesPath.primaryLoading,
    //       width: (size ?? 40).w * 2,
    //       height: (size ?? 40).w,
    //       fit: BoxFit.contain,
    //       repeat: true,
    //       animate: true,
    //     ),
    //   ),
    // );
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
