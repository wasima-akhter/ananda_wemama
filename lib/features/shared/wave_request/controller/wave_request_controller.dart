import 'package:mama_app/core/common_widgets/popups.dart';

import '../../../../app/controller_export.dart';
import '../../../../app/helper_widgets_export.dart';

class FakeUserDetailsModel {
  final String name;
  final int age;
  final String imageUrl;
  final String aboutMe;
  final List<UiInfoItem> infoList;
  final List<String> galleryImages;
  final List<String> children;

  FakeUserDetailsModel({
    required this.name,
    required this.age,
    required this.imageUrl,
    required this.aboutMe,
    required this.infoList,
    required this.galleryImages,
    required this.children,
  });
}

class UiInfoItem {
  final String iconPath;
  final String text;

  UiInfoItem({required this.iconPath, required this.text});
}

class WaveRequestController extends GetxController {
  var fakeNewWavesList = [
    FakeNewWavesModel(
      id: "1",
      name: "Alice",
      time: "2h ago",
      imageUrl: Strings.fakeImageUrl,
    ),
    FakeNewWavesModel(
      id: "2",
      name: "Bob",
      time: "4min ago",
      imageUrl: Strings.fakeImageUrl,
    ),
    FakeNewWavesModel(
      id: "3",
      name: "Charlie",
      time: "yesterday",
      imageUrl: Strings.fakeImageUrl,
    ),
    FakeNewWavesModel(
      id: "4",
      name: "Diana",
      time: "22 Jan 2026",
      imageUrl: Strings.fakeImageUrl,
    ),
    FakeNewWavesModel(
      id: "5",
      name: "Eve",
      time: "1 Jan 2026",
      imageUrl: Strings.fakeImageUrl,
    ),
  ];

  final listOfInfo = [
    UiInfoItem(iconPath: IconsPath.locationBold, text: 'Ikeja, Lagos'),
    UiInfoItem(
      iconPath: IconsPath.chartFilled,
      text: 'TTC:  Trying to conceive',
    ),
    UiInfoItem(
      iconPath: IconsPath.heartHalfFilled,
      text:
          'Interested in: Food delivery, Grocery delivery viudf vugdfv iodfv hdfiu v',
    ),
  ];

  FakeUserDetailsModel? fakeUserDetails;
  RxBool isSeeMore = false.obs;

  void toggleSeeMore() {
    isSeeMore.value = !isSeeMore.value;
  }

  void initFakeInfo() {
    fakeUserDetails = FakeUserDetailsModel(
      name: "John Doe",
      age: 24,
      imageUrl: Strings.fakeImageUrl,
      aboutMe:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec auctor, nisl eget ultricies lacinia, nunc nisl aliquam nisl, eget aliquam nunc nisl eget nunc.",
      infoList: listOfInfo,
      galleryImages: [
        Strings.fakeImageUrl,
        Strings.fakeImageUrl,
        Strings.fakeImageUrl,
        Strings.fakeImageUrl,
      ],
      children: ["👶11 Months", "👶11 Months", "👶11 Months"],
    );
  }

  @override
  void onInit() {
    initFakeInfo();
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
      Future.delayed(Duration(seconds: 1), ()  {
        
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
