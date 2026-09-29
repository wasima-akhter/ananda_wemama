import '../../../../app/controller_export.dart';
import '../model/expert_session_list_model.dart';
import '../services/experts_service.dart';

class SessionController extends GetxController {
  RxList<Session> ongoingList = <Session>[].obs;
  RxList<Session> upcomingList = <Session>[].obs;

  // ---------- loading ----------
  final isOngoingLoading = false.obs;
  final isUpcomingLoading = false.obs;

  final isOngoingPaginating = false.obs;
  final isUpcomingPaginating = false.obs;

  // ---------- pagination ----------
  final ongoingPage = 1.obs;
  final upcomingPage = 1.obs;

  final hasMoreOngoing = true.obs;
  final hasMoreUpcoming = true.obs;

  final ongoingScrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    getOngoingSessions();
    getUpcomingSessions();
    _setupPagination();
  }

  void _setupPagination() {
    ongoingScrollController.addListener(() {
      if (!hasMoreOngoing.value) return;

      if (ongoingScrollController.position.pixels >=
          ongoingScrollController.position.maxScrollExtent - 100) {
        getOngoingSessions(fetchNext: true);
      }
    });
  }

  // =====================================================
  // PUBLIC APIs
  // =====================================================

  Future<void> getOngoingSessions({
    bool fetchNext = false,
    String searchTxt = '',
  }) async {
    await _fetchSessions(
      status: SessionStatus.ongoing,
      targetList: ongoingList,
      loading: isOngoingLoading,
      paginating: isOngoingPaginating,
      page: ongoingPage,
      fetchNext: fetchNext,
      searchTxt: searchTxt,
      hasMore: hasMoreOngoing,
    );
  }

  Future<void> getUpcomingSessions({
    bool fetchNext = false,
    String searchTxt = '',
  }) async {
    await _fetchSessions(
      status: SessionStatus.upcoming,
      targetList: upcomingList,
      loading: isUpcomingLoading,
      paginating: isUpcomingPaginating,
      page: upcomingPage,
      fetchNext: fetchNext,
      searchTxt: searchTxt,
      hasMore: hasMoreUpcoming,
    );
  }

  // =====================================================
  // CORE FETCH LOGIC
  // =====================================================

  Future<void> _fetchSessions({
    required SessionStatus status,
    required RxList<Session> targetList,
    required RxBool loading,
    required RxBool paginating,
    required RxInt page,
    required RxBool hasMore,
    required bool fetchNext,
    String searchTxt = '',
  }) async {
    if (loading.value || paginating.value) return;
    if (fetchNext && !hasMore.value) return;

    if (fetchNext) {
      paginating.value = true;
    } else {
      loading.value = true;
      page.value = 1;
      hasMore.value = true;
    }

    try {
      final data = await ExpertsService().fetchExpertSessionList(
        sessionStatus: status.name.cap,
        page: page.value.toString(),
        searchTxt: searchTxt,
      );

      final newItems = data?.sessions ?? [];

      print("ongoing --> ${newItems.length}");
      print("ongoing --> ${data?.sessions.length}");

      if (!fetchNext) {
        targetList.value = newItems;
      } else {
        targetList.addAll(newItems);
      }

      // ---------- pagination control ----------
      if (newItems.isEmpty) {
        hasMore.value = false;
      } else {
        page.value++;
      }
    } catch (e) {
      print("Session fetch error: $e");
    } finally {
      loading.value = false;
      paginating.value = false;
    }
  }

  // =====================================================
  // OPTIONAL HELPERS
  // =====================================================

  void resetOngoing() {
    ongoingList.clear();
    ongoingPage.value = 1;
    hasMoreOngoing.value = true;
  }

  void resetUpcoming() {
    upcomingList.clear();
    upcomingPage.value = 1;
    hasMoreUpcoming.value = true;
  }
}
