import 'package:mama_app/core/components/ui/scroll/cus_scrollbar_widget.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/inputs/cus_search_bar.dart';
import '../controller/community_controller.dart';
import '../widgets/community_item.dart';

class CommunitySearchScreen extends StatelessWidget {
  const CommunitySearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cc = Get.find<CommunityController>();
    return AppScreenTemplate(
      isScrollable: false,
      appBar: _buildAppBar(cc),

      child: Obx(() {
        final showTag = cc.showSearchedTag.value;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: showTag
              ?
                // Column(children: [Text("data")])
                _buildSearchResult(cc)
              : SuggestedCommunitySection(cc: cc),
          // _buildDefaultContentSliver(cc),
        );
      }),
    );
  }

  Widget _buildSearchResult(CommunityController cc) {
    return Column(
      key: const ValueKey("search"),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ContainerBordered(
              vp: 6,
              hp: 12,
              rad: 30,
              contClr: c.secondary.withOpacity(0.3),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFit(
                    cc.searchedTxt.value,
                    style: TxtStyle.urbanistSemiB(fs: 14, w: 600, color: c.primary),
                  ),
                  Gap(8),
                  CusGestureDetector(
                    onTap: () {
                      cc.showSearchedTag.value = false;
                      cc.clearAll();
                    },
                    child: SvgIconColored(iconPath: IconsPath.closeCircle, iconColor: white),

                    // Icon(Icons.close, size: 16, color: white),
                  ),
                ],
              ),
            ).getcm,
          ],
        ),
        Gap(itemGap),
        Expanded(
          child: buildCommunityList(
            shrinkWrap: true,
            scrollController: cc.searchedCommCtrl,
            itemCount: 15,
            itemBuilder: (index) => CommunityItem(
              btnTxt: Strings.join,
              isLoading: false,
              onTapItem: () {},
              onTapItemBtn: () {},
            ),
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar(CommunityController cc) {
    return CommonAppBarContent(
      title: '',
      titleWidget: Expanded(
        child: CusSearchBar(
          fillColor: ctransp,
          controller: cc.searchController,
          focusNode: cc.searchFocus,
          onEditingComplete: () {
            cc.showSearchedTag.value = true;
            cc.searchedTxt.value = cc.searchController.text;
            cc.clearAll();
            cc.unFocusAll();
          },
        ).getcm.mHV(0, 6),
      ),
    );
  }
}

Widget buildCommunityList({
  required ScrollController scrollController,
  required int itemCount,
  required CommunityItem Function(int index) itemBuilder,
  final bool? shrinkWrap,
}) {
  return CusScrollbarWidget(
    controller: scrollController,
    child: ListView.builder(
      shrinkWrap: shrinkWrap ?? false,
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return itemBuilder(index).getcm.mB(itemGap * 0.6);
      },
    ),
  );
}

// ── Suggested communities section ──────────────────────────────────────────────
class SuggestedCommunitySection extends StatelessWidget {
  final CommunityController cc;
  const SuggestedCommunitySection({super.key, required this.cc});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ContainerBordered(
              rad: 8,
              hp: 10,
              vp: 4,
              child: TextFit(
                "You may like",
                style: TxtStyle.outfitSemiB(fs: 13, w: 500, color: c.secondary),
              ),
            ),
          ],
        ).getcm,
        Gap(itemGap * 0.5),
        Expanded(
          child: buildCommunityList(
            scrollController: cc.suggCommunityScrlCtrl,
            itemCount: 10,
            itemBuilder: (_) => CommunityItem(
              bgClr: c.inputBackground,
              btnTxt: Strings.join,
              isLoading: false,
              onTapItem: () => cc.onTapItem(MyCommunityBtnState.join),
              onTapItemBtn: () => cc.onTapItemBtn(MyCommunityBtnState.join),
            ),
          ),
        ),
      ],
    );
  }
}
