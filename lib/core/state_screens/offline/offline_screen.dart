import '../../../../app/helper_widgets_export.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,

      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(30),
          color: bgClr,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(ImagesPath.noNet, height: 1.sh * 0.2),

                Gap(itemGap * 6),
                Text(Strings.waitingForConnection, style: TxtStyle.inter(fs: 13, w: 600)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
