import '../../../../app/controller_export.dart';

class WaveRequestController extends GetxController {
  var fakeNewWavesList = [
    FakeNewWavesModel(id: "1", name: "Alice", time: "2h ago", imageUrl: Strings.fakeImageUrl),
    FakeNewWavesModel(id: "2", name: "Bob", time: "4min ago", imageUrl: Strings.fakeImageUrl),
    FakeNewWavesModel(id: "3", name: "Charlie", time: "yesterday", imageUrl: Strings.fakeImageUrl),
    FakeNewWavesModel(id: "4", name: "Diana", time: "22 Jan 2026", imageUrl: Strings.fakeImageUrl),
    FakeNewWavesModel(id: "5", name: "Eve", time: "1 Jan 2026", imageUrl: Strings.fakeImageUrl),
  ];

  RxBool isSeeMore = false.obs;

  void toggleSeeMore() {
    isSeeMore.value = !isSeeMore.value;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void clearAll() {}

  void unFocusAll() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // API loading state
  var isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  /// Fetch the latest  data from API
  Future<void> getNewWavesList() async {
    if (isLoading_.value) return; // Prevent duplicate calls
    isLoading_.value = true;

    try {
      // final data = await ChatService().fetchChatList(

      // );

      // if (data != null) {

      // }
    } catch (e) {
      print("Error fetching profile: $e");
    } finally {
      isLoading_.value = false;

      unFocusAll();
    }
  }
}

class FakeNewWavesModel {
  final String id;
  final String name;
  final String time;
  final String imageUrl;

  FakeNewWavesModel({
    required this.name,
    required this.time,
    required this.imageUrl,
    required this.id,
  });
}
