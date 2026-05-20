import '../../../../app/controller_export.dart';
import '../../../../core/enums/ui_enums.dart';
import '../../../shared/mood/mood_check_in/mood_row_model.dart';
import '../model/expert_session_list_model.dart';
import 'session_action_controller.dart';
import 'session_controller.dart';

class ExpertsController extends GetxController {
  late final SessionController _sessionCtrl;
  late final SessionActionController _actionCtrl;

  // ── Mood data ─────────────────────────────────────────────────────────────

  final moodDataList = [
    MoodRowModel(name: Strings.calm, moodType: MoodType.calm),
    MoodRowModel(name: Strings.tired, moodType: MoodType.tired),
    MoodRowModel(name: Strings.anxious, moodType: MoodType.anxious, hp: 8),
    MoodRowModel(name: Strings.stressed, moodType: MoodType.stressed, hp: 8),
  ];

  final pastSessionList = [
    ...List.generate(
      9,
      (_) => MoodRowModel(name: Strings.calm, moodType: MoodType.calm),
    ),
  ];

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

  TextEditingController get writeQuesCtrl => _actionCtrl.writeQuesCtrl;
  FocusNode get writeQuesFocusNode => _actionCtrl.writeQuesFocusNode;
  RxBool get isUploadQuesLoading => _actionCtrl.isSendQuesLoading;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _sessionCtrl = Get.find<SessionController>();
    _actionCtrl = Get.find<SessionActionController>();
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
  }) async {
    await _actionCtrl.uploadSessionQues(
      expertId: expertId,
      sessionId: sessionId,
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
  }

  List<Session> limitList(List<Session> list) =>
      list.length > 5 ? list.sublist(0, 5) : list;

  void onTapViewAll(bool isOngoing) {
    Get.toNamed(
      isOngoing ? RoutePaths.ongoingSessions : RoutePaths.upcomingSessions,
    );
  }
}
