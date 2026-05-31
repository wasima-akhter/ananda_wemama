import '../../../../../app/helper_widgets_export.dart';
import '../../controller/match_controller.dart';

class MatchNoMatchState extends StatelessWidget {
  const MatchNoMatchState({super.key, required this.mc});

  final MatchController mc;

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      contClr: white,
      hp: 12,
      vp: 22,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            Strings.noWeMamasNearby,
            textAlign: TextAlign.center,
            style: TxtStyle.outfitSmTitleSec,
          ),

          Text(
            Strings.checkBackLater,
            textAlign: TextAlign.center,
            style: TxtStyle.outfitSmSecNor,
          ),

          Gap(itemGap * 3),

          CustomBtnWTxt(
            btnTxt: Strings.tryAgain.capEachWord(),
            onTap: mc.startSearching,
            isLoading: false,
          ),

          Gap(itemGap * 2),
        ],
      ),
    );
  }
}
