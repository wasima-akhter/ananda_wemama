import 'dart:async';

import '../../../../app/controller_export.dart';
import '../../../../app/service_export.dart';
import '../model/expert_session_list_model.dart';
import '../services/experts_service.dart';

class PastSessionsController extends GetxController {
  final _service = ExpertsService();

  final RxBool isLoading = false.obs;
  final RxBool isLoadMore = false.obs;
  final RxList<Session> sessions = <Session>[].obs;

  final searchCtrl = TextEditingController();
  final searchFocusNode = FocusNode();
  final scrollController = ScrollController();

  PaginationMeta? meta;
  int _page = 1;
  Timer? _debounce;
  int _requestId = 0; // guards against stale/out-of-order responses

  bool get hasMore => meta?.hasNextPage == true;

  @override
  void onInit() {
    super.onInit();

    getPastSessions();

    searchCtrl.addListener(_onSearchChanged);
    scrollController.addListener(_onScroll);
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      getPastSessions(search: searchCtrl.text.trim(), isRefresh: true);
    });
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    final threshold = scrollController.position.maxScrollExtent - 200;
    if (scrollController.position.pixels >= threshold) {
      loadMore();
    }
  }

  Future<void> getPastSessions({
    String search = "",
    bool isRefresh = false,
  }) async {
    if (isRefresh) _page = 1;

    // tags this call so a slower, earlier request can't clobber a
    // faster, later one when responses arrive out of order
    final requestId = ++_requestId;

    if (_page == 1) {
      isLoading.value = true;
    } else {
      isLoadMore.value = true;
    }

    final result = await _service.fetchPastLibrarySessionList(
      sessionStatus: "Completed",
      page: _page.toString(),
      searchTxt: search,
    );

    // a newer request has since started — drop this stale result
    if (requestId != _requestId) return;

    if (result.type == ApiResultType.success) {
      final newSessions = result.data?.sessions ?? [];
      meta = result.meta;

      if (_page == 1) {
        sessions.assignAll(newSessions);
      } else {
        sessions.addAll(newSessions);
      }
      // NOTE: page is no longer auto-incremented here — loadMore() owns that.
    }

    isLoading.value = false;
    isLoadMore.value = false;
  }

  Future<void> loadMore() async {
    if (isLoadMore.value || isLoading.value) return;
    if (!hasMore) return;

    _page++;
    await getPastSessions(search: searchCtrl.text.trim());
  }

  void clearSearch() {
    _debounce?.cancel();
    searchCtrl.clear(); // this re-fires the listener, scheduling a debounce
    _debounce?.cancel(); // cancel that redundant scheduled call
    getPastSessions(isRefresh: true);
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchCtrl.removeListener(_onSearchChanged);
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    searchCtrl.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }
}
