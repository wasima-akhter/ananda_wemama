import '../../../../../app/helper_widgets_export.dart';
import '../../controller/match_controller.dart';
import '../../modules/searching_cancel_btn.dart';

class MatchSearchingState extends StatelessWidget {
  const MatchSearchingState({super.key, required this.mc});

  final MatchController mc;

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      contClr: white,
      hp: 12,
      vp: 22,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(Strings.searching, textAlign: TextAlign.center, style: TxtStyle.outfitSmNor500),

          Gap(itemGap),

          GestureDetector(onTap: mc.cancelSearch, child: SearchingCancelButton()),
        ],
      ),
    );
  }
}
