import 'package:we_mama/core/components/ui/dialogs/popups.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/feedback/ui_state/ui_state_card.dart';
import '../../../../../core/components/ui/loaders/empty_widget.dart';
import '../../../../../gen/assets.gen.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshCurrentTab();
    // cc.refreshCurrentTab();

    // ✅ Wire existing scroll controllers to pagination
    cc.myCommunityScrlCtrl.addListener(_onMyCommunityScroll);
    cc.manageCommunityScrlCtrl.addListener(_onManagedCommunityScroll);
  }

  @override
  void dispose() {
    cc.myCommunityScrlCtrl.removeListener(_onMyCommunityScroll);
    cc.manageCommunityScrlCtrl.removeListener(_onManagedCommunityScroll);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onMyCommunityScroll() {
    final ctrl = cc.myCommunityScrlCtrl;
    if (!cc.joinedPaginator.hasMore.value)
      return; // ✅ skip listener work entirely
    if (ctrl.position.pixels >= ctrl.position.maxScrollExtent - 200) {
      cc.loadMoreMyCommunity();
    }
  }

  void _onManagedCommunityScroll() {
    final ctrl = cc.manageCommunityScrlCtrl;
    if (!cc.managedPaginator.hasMore.value)
      return; // ✅ skip listener work entirely
    if (ctrl.position.pixels >= ctrl.position.maxScrollExtent - 200) {
      cc.loadMoreManagedCommunity();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('🔍 [Lifecycle] state changed → $state');
    if (state == AppLifecycleState.resumed && mounted) {
      _refreshCurrentTab();

      // cc.refreshCurrentTab();
    }
  }

  Future<void> _refreshCurrentTab() async {
    final isMyTab = cc.selTab.value == CommunityTab.myCommunities;

    if (isMyTab) {
      await cc.getMyCommunityList();
    }
    await cc.getManagedCommunityList();
  }

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
        onRefresh: () => cc.joinedPaginator.refresh(),
        state: getUIStateList(
          isLoading: cc.joinedPaginator.isLoading.value,
          list: cc.joinedPaginator.items,
        ),
        loading: () => const CommunityShimmerList(),
        empty: () => EmptyNoSearchWidgetScrollable(
          title: "No Communities yet",
          assetPath: Assets.images.noCommunitiesIcon.path,
          subTitle:
              "Discover communities that match\n"
              "your interests and connect with\n"
              "fellow mums.",
        ).getcm,
        data: () => Column(
          children: [
            Expanded(
              child: CommunityListViewSimple(
                key: const ValueKey(CommunityTab.myCommunities),
                scrollController: cc.myCommunityScrlCtrl, // ✅ wire scroll
                itemCount: cc.joinedPaginator.items.length,
                itemBuilder: (i) => _buildJoinedItem(i),
              ),
            ),
            // ✅ trailing loader for load-more
            if (cc.joinedPaginator.isLoadingMore.value)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
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
        onRefresh: () => cc.managedPaginator.refresh(),
        state: getUIStateList(
          isLoading: cc.managedPaginator.isLoading.value,
          list: cc.managedPaginator.items,
        ),
        loading: () => const CommunityShimmerList(),
        empty: () => EmptyNoSearchWidgetScrollable(
          title: "No communities created yet",
          assetPath: Assets.images.noCommunitiesIcon.path,
          subTitle:
              "Start your own community and create\n"
              "a safe space for mums to connect\n"
              "and support each other.",
        ).getcm,
        data: () => Column(
          children: [
            Expanded(
              child: CommunityListViewSimple(
                key: const ValueKey(CommunityTab.manage),
                scrollController: cc.manageCommunityScrlCtrl, // ✅ wire scroll
                itemCount: cc.managedPaginator.items.length,
                itemBuilder: (i) => _buildManagedItem(i),
              ),
            ),
            if (cc.managedPaginator.isLoadingMore.value)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
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
