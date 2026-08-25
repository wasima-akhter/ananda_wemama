import '../../../../../app/helper_widgets_export.dart';
import '../controller/community_search_controller.dart';

class CommunitySearchChip extends StatelessWidget {
  final CommunitySearchController csc;

  const CommunitySearchChip({super.key, required this.csc});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ContainerBordered(
          vp: 0,
          hp: 12,
          rad: 30,
          contClr: c.secondary.withOpacity(0.3),
          child: _CommunitySearchChipContent(csc: csc),
        ).getcm,
      ],
    );
  }
}

class _CommunitySearchChipContent extends StatelessWidget {
  final CommunitySearchController csc;

  const _CommunitySearchChipContent({required this.csc});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFit(
          csc.searchedTxt.value,
          style: TxtStyle.urbanistSemiB(fs: 14, w: 600, color: c.primary),
        ),
        Gap(8),
        CusGestureDetector(
          onTap: () {
            csc.showSearchedTag.value = false;
            csc.clearAll();
          },
          child: Container(
            padding: 9.pv,
            child: SvgIconColored(
              iconPath: IconsPath.closeCircle,
              iconColor: c.primary,
            ),
          ),
        ),
      ],
    );
  }
}
