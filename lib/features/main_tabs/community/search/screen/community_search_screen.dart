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

  // ───────────────────────── LIFECYCLE ─────────────────────────

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    csc.resetSearchState();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
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
            ? CommunitySearchResultSection(csc: csc)
            : SuggestedCommunitySection(csc: csc);
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
      ).mHV(0, 4),
    );
  }
}
