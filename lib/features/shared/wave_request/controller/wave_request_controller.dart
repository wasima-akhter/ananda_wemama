import 'package:mama_app/core/common_widgets/popups.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/common_widgets/common_components/user_detaIl_component/user_detail_controller/user_detail_controller.dart';

class WaveRequestController extends GetxController {
  var fakeNewWavesList = [
    FakeNewWavesModel(id: "1", name: "Alice", time: "2h ago", imageUrl: Strings.fakeImageUrl),
    FakeNewWavesModel(id: "2", name: "Bob", time: "4min ago", imageUrl: Strings.fakeImageUrl),
    FakeNewWavesModel(id: "3", name: "Charlie", time: "yesterday", imageUrl: Strings.fakeImageUrl),
    FakeNewWavesModel(id: "4", name: "Diana", time: "22 Jan 2026", imageUrl: Strings.fakeImageUrl),
    FakeNewWavesModel(id: "5", name: "Eve", time: "1 Jan 2026", imageUrl: Strings.fakeImageUrl),
  ];

  final listOfInfo = [
    UiInfoItem(iconPath: IconsPath.locationBold, text: 'Ikeja, Lagos'),
    UiInfoItem(iconPath: IconsPath.chartFilled, text: 'TTC:  Trying to conceive'),
    UiInfoItem(
      iconPath: IconsPath.heartHalfFilled,
      text: 'Interested in: Food delivery, Grocery delivery viudf vugdfv iodfv hdfiu v',
    ),
  ];

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

  Future<void> onTapAction(bool isAccepted) async {
    Get.back();

    if (isAccepted) {
      // show popup
      showReqAcceptedDialog();
      Future.delayed(Duration(seconds: 3), () {
        Get.back();

        showBothConnectedDialog();
      });
    }
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
