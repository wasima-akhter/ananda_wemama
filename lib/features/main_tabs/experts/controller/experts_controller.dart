import '../../../../app/controller_export.dart';
import '../../../../core/enums/ui_enums.dart';
import '../../../../core/network/base/dio_client.dart';
import '../../../shared/mood/mood_check_in/mood_row_model.dart';
import '../model/expert_session_list_model.dart';
import '../services/experts_service.dart';
import 'session_action_controller.dart';
import 'session_controller.dart';

class ExpertsController extends GetxController {
  static ExpertsController get to => Get.find();
  late final SessionController _sessionCtrl;
  late final SessionActionController _actionCtrl;

  // ── Mood data ─────────────────────────────────────────────────────────────

  final moodDataList = [
    MoodRowModel(name: Strings.calm, moodType: MoodType.calm),
    MoodRowModel(name: Strings.tired, moodType: MoodType.tired),
    MoodRowModel(name: Strings.anxious, moodType: MoodType.anxious, hp: 6),
    MoodRowModel(name: Strings.stressed, moodType: MoodType.stressed, hp: 6),
  ];

  //

  final TextEditingController writeQuesCtrl = TextEditingController();
  final FocusNode writeQuesFocusNode = FocusNode();

  @override
  void dispose() {
    writeQuesCtrl.dispose();
    writeQuesFocusNode.dispose();
    super.dispose();
  }

  // ── Search (expert screen only) ───────────────────────────────────────────

  final searchOngoingCtrl = TextEditingController();
  final searchOngoingFocusNode = FocusNode();

  final searchUpcomingCtrl = TextEditingController();
  final searchUpcomingFocusNode = FocusNode();

  final RxString searchedOngoingTxt = ''.obs;
  final RxString searchedUpcomingTxt = ''.obs;

  final RxBool showOngoingTag = false.obs;
  final RxBool showUpcomingTag = false.obs;

  final PageController upcomingPageController = PageController();

  // ── Proxies ───────────────────────────────────────────────────────────────

  RxList<Session> get ongoingList => _sessionCtrl.ongoingList;
  RxList<Session> get upcomingList => _sessionCtrl.upcomingList;

  RxBool get isOngoingLoading => _sessionCtrl.isOngoingLoading;
  RxBool get isUpcomingLoading => _sessionCtrl.isUpcomingLoading;

  ScrollController get ongoingScrollController =>
      _sessionCtrl.ongoingScrollController;

  RxBool get isUploadQuesLoading => _actionCtrl.isSendQuesLoading;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _sessionCtrl = Get.find<SessionController>();
    _actionCtrl = Get.find<SessionActionController>();

    getPastSessions();
  }

  @override
  void onClose() {
    searchOngoingCtrl.dispose();
    searchOngoingFocusNode.dispose();
    searchUpcomingCtrl.dispose();
    searchUpcomingFocusNode.dispose();
    upcomingPageController.dispose();
    super.onClose();
  }

  // ── Search actions ────────────────────────────────────────────────────────

  Future<void> onSubmitOngoingSearch() async {
    final txt = searchOngoingCtrl.text.trim();
    if (txt.isEmpty) return;
    searchedOngoingTxt.value = txt;
    showOngoingTag.value = true;
    searchOngoingFocusNode.unfocus();
    await _sessionCtrl.getOngoingSessions(searchTxt: txt);
  }

  Future<void> clearOngoingSearch() async {
    searchOngoingCtrl.clear();
    searchedOngoingTxt.value = '';
    showOngoingTag.value = false;
    await _sessionCtrl.getOngoingSessions();
  }

  Future<void> onSubmitUpcomingSearch() async {
    final txt = searchUpcomingCtrl.text.trim();
    if (txt.isEmpty) return;
    searchedUpcomingTxt.value = txt;
    showUpcomingTag.value = true;
    searchUpcomingFocusNode.unfocus();
    await _sessionCtrl.getUpcomingSessions(searchTxt: txt);
  }

  Future<void> clearUpcomingSearch() async {
    searchUpcomingCtrl.clear();
    searchedUpcomingTxt.value = '';
    showUpcomingTag.value = false;
    await _sessionCtrl.getUpcomingSessions();
  }

  // ── Session actions ───────────────────────────────────────────────────────

  Future<void> onTapQues({
    required String expertId,
    required String sessionId,
    required String question,
  }) async {
    await _actionCtrl.uploadSessionQues(
      expertId: expertId,
      sessionId: sessionId,
      question: question,
    );
  }

  Future<void> getOngoingSessions({bool fetchNext = false}) =>
      _sessionCtrl.getOngoingSessions(fetchNext: fetchNext);

  Future<void> getUpcomingSessions({bool fetchNext = false}) =>
      _sessionCtrl.getUpcomingSessions(fetchNext: fetchNext);

  // ── UI helpers ────────────────────────────────────────────────────────────

  void unfocusAll() {
    writeQuesFocusNode.unfocus();
    searchOngoingFocusNode.unfocus();
    searchUpcomingFocusNode.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();

    writeQuesCtrl.clear();
  }

  List<Session> limitList(List<Session> list) =>
      list.length > 5 ? list.sublist(0, 5) : list;

  void onTapViewAll(bool isOngoing) {
    Get.toNamed(
      isOngoing ? RoutePaths.ongoingSessions : RoutePaths.upcomingSessions,
    );
  }

  final _service = ExpertsService();

  final RxBool isPastSessionLoading = false.obs;

  final RxList<Session> pastSessionList = <Session>[].obs;

  Future<void> getPastSessions() async {
    isPastSessionLoading.value = true;

    final result = await _service.fetchPastLibrarySessionList(
      sessionStatus: "Completed",
      page: "1",
      searchTxt: "",
    );

    if (result.type == ApiResultType.success) {
      pastSessionList.assignAll(result.data?.sessions ?? []);
    }

    isPastSessionLoading.value = false;
  }

  List<Session> get limitedPastSessions {
    return pastSessionList.take(5).toList();
  }
}
