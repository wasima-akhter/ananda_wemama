import 'package:mama_app/core/components/ui/dialogs/popups.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/feedback/ui_state/ui_state_card.dart';
import '../../../../../core/components/ui/loaders/empty_widget.dart';
import '../../shared_ui/community_item.dart';
import '../controller/community_controller.dart';
import '../modules/community_list_view_simple.dart';
import '../modules/community_shimmer_list.dart';
// modules
import '../modules/community_tab_item.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with WidgetsBindingObserver {
  final CommunityController cc = Get.find<CommunityController>();

  // ───────────────────────── LIFECYCLE ─────────────────────────

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshCurrentTab();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('🔍 [Lifecycle] state changed → $state');
    if (state == AppLifecycleState.resumed && mounted) {
      _refreshCurrentTab();
    }
  }

  // ───────────────────────── DATA ─────────────────────────

  Future<void> _refreshCurrentTab() async {
    final isMyTab = cc.selTab.value == CommunityTab.myCommunities;

    await cc.getManagedCommunityList();

    if (isMyTab) {
      await cc.getMyCommunityList();
    }
  }

  // ───────────────────────── UI ─────────────────────────

  @override
  Widget build(BuildContext context) {
    return AppScreenTemplate(
      appBar: _buildAppBar(),
      isScrollable: false,
      child: Column(
        children: [
          _buildTabBar(),
          Gap(itemGap * 0.5),
          Expanded(child: _buildTabContent()),
        ],
      ),
    );
  }

  // ───────────────────────── TAB BAR ─────────────────────────

  Widget _buildTabBar() {
    return Obx(() {
      final selTab = cc.selTab.value;

      return Row(
        children: [
          CommunityTabItem(
            title: Strings.myCommunity,
            isSelected: selTab == CommunityTab.myCommunities,
            onTap: () => cc.changeTab(CommunityTab.myCommunities),
          ),
          Gap(itemGap),
          CommunityTabItem(
            title: Strings.manage,
            isSelected: selTab == CommunityTab.manage,
            onTap: () => cc.changeTab(CommunityTab.manage),
          ),
        ],
      ).getcm;
    });
  }

  // ───────────────────────── TAB CONTENT ─────────────────────────

  Widget _buildTabContent() {
    return Obx(() {
      return IndexedStack(
        index: _selectedIndex(),
        children: [_myCommunities(), _managedCommunities()],
      );
    });
  }

  int _selectedIndex() {
    return cc.selTab.value == CommunityTab.myCommunities ? 0 : 1;
  }

  // ───────────────────────── MY COMMUNITIES ─────────────────────────

  Widget _myCommunities() {
    return Obx(() {
      return UIStateHandler(
        onRefresh: () => cc.getMyCommunityList(),
        state: getUIStateList(
          isLoading: cc.isJoinedCommunityLoading_.value,
          list: cc.joinedCommunityList,
        ),
        loading: () => const CommunityShimmerList(),
        empty: () => const EmptyNoSearchWidgetScrollable(
          title: "No Communities yet",
        ).getcm,
        data: () => CommunityListViewSimple(
          key: const ValueKey(CommunityTab.myCommunities),
          itemCount: cc.joinedCommunityList.length,
          itemBuilder: (i) => _buildJoinedItem(i),
        ),
      );
    });
  }

  CommunityItem _buildJoinedItem(int i) {
    final item = cc.joinedCommunityList[i];

    return CommunityItem(
      item: item,
      btnTxt: Strings.visit,
      isLoading: false,
      onTapItem: () => cc.onTapItem(
        btnState: MyCommunityBtnState.visit,
        communityItemId: item.id ?? '',
      ),
      onTapItemBtn: () => cc.onTapItemBtn(
        btnState: MyCommunityBtnState.visit,
        communityItemId: item.id ?? '',
      ),
    );
  }

  // ───────────────────────── MANAGE COMMUNITIES ─────────────────────────

  Widget _managedCommunities() {
    return Obx(() {
      return UIStateHandler(
        onRefresh: () => cc.getManagedCommunityList(),
        state: getUIStateList(
          isLoading: cc.isManagedCommunityLoading_.value,
          list: cc.managedCommunityList,
        ),
        loading: () => const CommunityShimmerList(),
        empty: () => const EmptyNoSearchWidgetScrollable(
          title: "No Communities yet",
        ).getcm,
        data: () => CommunityListViewSimple(
          key: const ValueKey(CommunityTab.manage),
          itemCount: cc.managedCommunityList.length,
          itemBuilder: (i) => _buildManagedItem(i),
        ),
      );
    });
  }

  CommunityItem _buildManagedItem(int i) {
    final item = cc.managedCommunityList[i];

    return CommunityItem(
      item: item,
      btnTxt: Strings.manage,
      isLoading: false,
      onTapItem: () => cc.onTapItem(
        btnState: MyCommunityBtnState.manage,
        communityItemId: item.id ?? '',
      ),
      onTapItemBtn: () => cc.onTapItemBtn(
        btnState: MyCommunityBtnState.manage,
        communityItemId: item.id ?? '',
      ),
    );
  }

  // ───────────────────────── APP BAR ─────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return CommonAppBarContent(
      title: Strings.community,
      hasBackNavArrow: false,
      suffix: Row(
        children: [
          CusGestureDetector(
            onTap: () => Get.toNamed(RoutePaths.communitySearch),
            child: SvgIcon(iconPath: IconsPath.search, height: 25),
          ),
          Gap(itemGap * 1.5),
          CusGestureDetector(
            onTap: () => communityGuidlineDialog(
              isLoading: false,
              onTapAction: () async {
                Get.back();
                Get.toNamed(RoutePaths.createCommunity);
              },
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ContainerBordered(
                  rad: 8,
                  vp: 2,
                  hp: 2,
                  contClr: c.primary,
                  child: SvgIconColored(
                    iconPath: IconsPath.addPlus,
                    iconColor: white,
                    height: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//
