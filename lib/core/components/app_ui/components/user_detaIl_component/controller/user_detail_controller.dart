import '../../../../../../app/controller_export.dart';
import '../../../../../constants/icon_and_image_paths.dart';

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

class UserDetailController extends GetxController {
  final listOfInfo = [
    UiInfoItem(iconPath: IconsPath.locationBold, text: 'Ikeja, Lagos'),
    UiInfoItem(iconPath: IconsPath.chartFilled, text: 'Trying to conceive'),
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
          "Lorem ipsum dolor sit amet, consectetur sauydcg sdiysdiuc iysdc siudcg isydgc isdgc adipiscing elit. Donec auctor, nisl eget ultricies lacinia, nunc nisl aliquam nisl, eget aliquam nunc nisl eget nunc.",
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
      Future.delayed(Duration(seconds: 1), () {
        Get.back();
      });
    }
  }

  // API loading state
  var isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  /// Fetch the latest  data from API
  Future<void> getUserDetailInfo() async {
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
