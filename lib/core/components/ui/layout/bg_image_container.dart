import '../../../../app/helper_widgets_export.dart';

class BgImageContainer extends StatelessWidget {
  final String? bgPath;
  final Widget child;
  const BgImageContainer({super.key, this.bgPath, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(bgPath ?? ImagesPath.onboardingBgImage),
          fit: BoxFit.cover,
        ),
      ),

      child: child,
    );
  }
}
