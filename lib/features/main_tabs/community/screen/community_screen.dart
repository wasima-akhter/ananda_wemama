import 'package:mama_app/core/common_widgets/custom_divider.dart';
import 'package:mama_app/core/common_widgets/popups.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/common_widgets/cus_scrollbar_widget.dart';
import '../../../../core/common_widgets/cus_search_bar.dart';
import '../controller/community_controller.dart';
import '../widgets/community_item.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cc = Get.find<CommunityController>();
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0; // ✅ top-level context

    return AppScreenTemplate(
      isScrollable: false,
      resizeToAvoidBottomInset: false,
      onRefresh: () async {},
      appBar: _buildAppBar(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CusSearchBar(controller: cc.searchController, focusNode: cc.searchFocus),
          Gap(itemGap),

          TextFit(Strings.myCommunity, style: TxtStyle.outfitSmTitle),
          Gap(itemGap),

          Flexible(
            child: buildCommunityList(
              scrollController: cc.myCommunityScrlCtrl,
              itemCount: 10,
              itemBuilder: (index) => CommunityItem(
                btnTxt: index < 2 ? Strings.manage : Strings.visit,
                isLoading: false,
                onTapItem: () => cc.onTapItem(
                  index < 2 ? MyCommunityBtnState.manage : MyCommunityBtnState.visit,
                ),
                onTapItemBtn: () => cc.onTapItemBtn(
                  index < 2 ? MyCommunityBtnState.manage : MyCommunityBtnState.visit,
                ),
              ),
            ),
          ),

          ...[
            Gap(itemGap * 2),
            CustomDivider(isFullWidth: true),
            Gap(itemGap),
            SuggestedCommunitySection(cc: cc),
          ],
        ],
      ).getcm,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CommonAppBarContent(
      title: Strings.community,
      hasBackNavArrow: false,
      suffix: CusGestureDetector(
        onTap: () => communityGuidlineDialog(
          isLoading: false,
          onTapAction: () async {
            Get.back();
            Get.toNamed(RoutePaths.createCommunity);
          },
        ),
        child: SvgIcon(iconPath: IconsPath.addPlus, height: 30),
      ),
    );
  }
}

Widget buildCommunityList({
  required ScrollController scrollController,
  required int itemCount,
  required CommunityItem Function(int index) itemBuilder,
}) {
  return CusScrollbarWidget(
    controller: scrollController,
    child: Column(children: List.generate(itemCount, (index) => itemBuilder(index).mB(itemGap))),
  );
}

class SuggestedCommunitySection extends StatelessWidget {
  final CommunityController cc;
  const SuggestedCommunitySection({super.key, required this.cc});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFit(Strings.suggestedCommunity, style: TxtStyle.outfitSmTitleSec),
          Gap(itemGap),
          Expanded(
            child: buildCommunityList(
              scrollController: cc.suggCommunityScrlCtrl,
              itemCount: 10,
              itemBuilder: (_) => CommunityItem(
                btnTxt: Strings.join,
                isLoading: false,
                onTapItem: () => cc.onTapItem(MyCommunityBtnState.join),
                onTapItemBtn: () => cc.onTapItemBtn(MyCommunityBtnState.join),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// Manage

//
