import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/inputs/cus_search_bar.dart';
import '../controller/community_search_controller.dart';
import '../modules/community_search_result_section.dart';
import '../modules/suggested_community_section.dart';

class CommunitySearchScreen extends StatefulWidget {
  const CommunitySearchScreen({super.key});

  @override
  State<CommunitySearchScreen> createState() => _CommunitySearchScreenState();
}

class _CommunitySearchScreenState extends State<CommunitySearchScreen>
    with WidgetsBindingObserver {
  final CommunitySearchController csc = Get.find<CommunitySearchController>();

  final ScrollController _suggestedScrollCtrl = ScrollController();
  final ScrollController _searchedScrollCtrl = ScrollController();

  // ───────────────────────── LIFECYCLE ─────────────────────────

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _suggestedScrollCtrl.addListener(_onSuggestedScroll);
    _searchedScrollCtrl.addListener(_onSearchedScroll);

    _refreshData();
  }

  void _onSuggestedScroll() {
    final ctrl = _suggestedScrollCtrl;

    if (!csc.suggestedPaginator.hasMore.value) return;

    if (ctrl.position.pixels >= ctrl.position.maxScrollExtent - 200) {
      csc.loadMoreSuggested();
    }
  }

  void _onSearchedScroll() {
    final ctrl = _searchedScrollCtrl;

    if (!csc.searchedPaginator.hasMore.value) return;

    if (ctrl.position.pixels >= ctrl.position.maxScrollExtent - 200) {
      csc.loadMoreSearched();
    }
  }

  @override
  void dispose() {
    _suggestedScrollCtrl.removeListener(_onSuggestedScroll);
    _searchedScrollCtrl.removeListener(_onSearchedScroll);

    _suggestedScrollCtrl.dispose();
    _searchedScrollCtrl.dispose();

    WidgetsBinding.instance.removeObserver(this);
    csc.resetSearchState();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('🔍 [Lifecycle] state changed → $state');
    if (state == AppLifecycleState.resumed && mounted) {
      _refreshData();
    }
  }

  Future<void> _refreshData() async {
    final isSearch = csc.showSearchedTag.value;

    if (isSearch) {
      await csc.getSearchedCommunityList();
    } else {
      await csc.getSuggestedCommunityList();
    }
  }

  // ───────────────────────── UI ─────────────────────────

  @override
  Widget build(BuildContext context) {
    return AppScreenTemplate(
      isScrollable: false,
      appBar: _buildAppBar(),
      child: Obx(() {
        return csc.showSearchedTag.value
            ? CommunitySearchResultSection()
            : SuggestedCommunitySection();
      }),
    );
  }

  // ───────────────────────── APP BAR ─────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return CommonAppBarContent(
      title: '',
      expandTitle: true,
      titleWidget: CusSearchBar(
        fillColor: ctransp,
        controller: csc.searchController,
        focusNode: csc.searchFocus,
        onEditingComplete: () async {
          csc.showSearchedTag.value = true;
          csc.searchedTxt.value = csc.searchController.text;

          await csc.getSearchedCommunityList();
          csc.clearAll();
          csc.unFocusAll();
        },
      ),
    );
  }
}
