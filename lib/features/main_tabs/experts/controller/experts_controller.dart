import 'package:mama_app/features/main_tabs/experts/services/experts_service.dart';

import '../../../../app/controller_export.dart';
import '../../../../core/enums/ui_enums.dart';
import '../../../shared/mood/mood_check_in/mood_row_model.dart';
import '../model/expert_session_list_model.dart';

class ExpertsController extends GetxController {
  var moodDataList = [
    MoodRowModel(name: Strings.calm, moodType: MoodType.calm),
    MoodRowModel(name: Strings.tired, moodType: MoodType.tired),
    MoodRowModel(name: Strings.anxious, moodType: MoodType.anxious, hp: 8),
    MoodRowModel(name: Strings.stressed, moodType: MoodType.stressed, hp: 8),
  ];

  var pastSessionList = [
    MoodRowModel(name: Strings.calm, moodType: MoodType.calm),
    MoodRowModel(name: Strings.calm, moodType: MoodType.calm),
    MoodRowModel(name: Strings.calm, moodType: MoodType.calm),
    MoodRowModel(name: Strings.calm, moodType: MoodType.calm),
    MoodRowModel(name: Strings.calm, moodType: MoodType.calm),
    MoodRowModel(name: Strings.calm, moodType: MoodType.calm),
    MoodRowModel(name: Strings.calm, moodType: MoodType.calm),
    MoodRowModel(name: Strings.calm, moodType: MoodType.calm),
    MoodRowModel(name: Strings.calm, moodType: MoodType.calm),
  ];

  final writeQuesCtrl = TextEditingController();

  final writeQuesFocusNode = FocusNode();

  final searchOngoingCtrl = TextEditingController();

  final searchOngoingFocusNode = FocusNode();
  final searchUpcomingCtrl = TextEditingController();

  final searchUpcomingFocusNode = FocusNode();

  @override
  void onInit() {
    getOngoingSessions();
    getUpcomingSessions();
    _setupPagination();
    super.onInit();
  }

  void _setupPagination() {
    ongoingScrollController.addListener(() {
      if (ongoingScrollController.position.pixels >=
          ongoingScrollController.position.maxScrollExtent - 100) {
        /// 🔥 load next page
        getOngoingSessions(fetchNext: true);
      }
    });
  }

  @override
  void onClose() {
    writeQuesCtrl.dispose();
    writeQuesFocusNode.dispose();

    searchOngoingCtrl.dispose();
    searchOngoingFocusNode.dispose();

    searchUpcomingCtrl.dispose();
    searchUpcomingFocusNode.dispose();

    super.onClose();
  }

  Future<void> onTapQues({required String expertId, required String sessionId}) async {
    debugPrint('expertId: $expertId ');
    debugPrint('sessionId: $sessionId ');

    // upload to the backend

    await uploadSessionQues(expertId: expertId, sessionId: sessionId);
  }

  /////////

  void unfocusAll() {
    writeQuesFocusNode.unfocus();
    searchOngoingFocusNode.unfocus();
    searchUpcomingFocusNode.unfocus();

    FocusManager.instance.primaryFocus?.unfocus();
  }

  ////

  RxList<Session> ongoingList = <Session>[].obs;
  RxList<Session> upcomingList = <Session>[].obs;

  RxBool isOngoingLoading = false.obs;
  RxBool isUpcomingLoading = false.obs;

  RxInt ongoingPage = 1.obs;
  RxInt upcomingPage = 1.obs;

  final sessionListData = ExpertSessionsListModel().obs;

  ///----------------------- Actions ----------------------------///

  Future<void> _fetchSessions({
    required SessionStatus status,
    required RxList<Session> targetList,
    required RxBool loading,
    required RxInt page,
    bool fetchNext = false,
  }) async {
    if (loading.value) return;

    loading.value = true;

    if (fetchNext) {
      page.value++;
    } else {
      page.value = 1;
    }

    try {
      final data = await ExpertsService().fetchExpertSessionList(
        sessionStatus: status.name.cap,
        page: page.value.toString(),
      );

      if (data != null) {
        if (fetchNext) {
          targetList.addAll(data.sessions ?? []);
        } else {
          targetList.value = data.sessions ?? [];
        }
      }
    } catch (e) {
      debugPrint('fetchSessions error: $e');
    } finally {
      loading.value = false;
    }
  }

  //
  Future<void> getOngoingSessions({bool fetchNext = false}) async {
    await _fetchSessions(
      status: SessionStatus.ongoing,
      targetList: ongoingList,
      loading: isOngoingLoading,
      page: ongoingPage,
      fetchNext: fetchNext,
    );
  }

  Future<void> getUpcomingSessions({bool fetchNext = false}) async {
    await _fetchSessions(
      status: SessionStatus.upcoming,
      targetList: upcomingList,
      loading: isUpcomingLoading,
      page: upcomingPage,
      fetchNext: fetchNext,
    );
  }

  //////////////////////

  RxBool isuploadQuesLoading = false.obs;
  Future<void> uploadSessionQues({required String expertId, required String sessionId}) async {
    if (isuploadQuesLoading.value) return;

    isuploadQuesLoading.value = true;

    try {
      final response = await ExpertsService().uploadUpcomingSessionQues(
        expertId: expertId,
        question: writeQuesCtrl.text,
        sessionId: sessionId,
      );
      if (response == true) {
        debugPrint('quest sent successfully!');
        Get.back();
      } else {
        debugPrint('quest sent failed!');
      }
    } catch (e) {
      debugPrint('upload ques of Session error: $e');
    } finally {
      isuploadQuesLoading.value = false;
      writeQuesCtrl.text = '';
    }
  }

  ////////////---------------------------->

  List<Session> limitList(List<Session> list) {
    return list.length > 5 ? list.sublist(0, 5) : list;
  }

  void onTapViewAll(bool isOngoing) {
    if (isOngoing) {
      Get.toNamed(RoutePaths.ongoingSessions);
    } else {
      Get.toNamed(RoutePaths.upcomingSessions);
    }
  }

  //////////////-----Individual
  final ongoingScrollController = ScrollController();
  final upcomingScrollController = ScrollController();

  final PageController upcomingPageController = PageController();
}
