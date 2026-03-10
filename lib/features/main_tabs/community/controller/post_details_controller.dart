import 'package:image_picker/image_picker.dart';

import '../../../../app/controller_export.dart';
import '../../../../core/models/ui/fake_comment_item_model.dart';

class PostDetailsController extends GetxController {
  var postAnonymously = false.obs; // 👈 toggle state

  final commentCtrl = TextEditingController();
  final commentFocus = FocusNode();

  final scrollController = ScrollController(); // ← add

  List<FakeCommentModel> comments = [
    FakeCommentModel(
      userName: "Darrell Steward",
      time: "2h",
      comment:
          "However rare side effects observed among children can be metabolic acidosis, coma, respiratory depre",
      childrenComment:
          "Simultaneously we had a problem with prisoner drunkenness that we couldn't figure out. I mean , the ",
    ),
    FakeCommentModel(
      userName: "Darrell Steward",
      time: "2h",
      comment:
          "However rare side effects observed among children can be metabolic acidosis, coma, respiratory depre",
      childrenComment:
          "Simultaneously we had a problem with prisoner drunkenness that we couldn't figure out. I mean , the ",
    ),
    FakeCommentModel(
      userName: "Darrell Steward",
      time: "2h",
      comment:
          "However rare side effects observed among children can be metabolic acidosis, coma, respiratory depre",
      childrenComment:
          "Simultaneously we had a problem with prisoner drunkenness that we couldn't figure out. I mean , the ",
    ),
    FakeCommentModel(
      userName: "Darrell Steward",
      time: "2h",
      comment:
          "However rare side effects observed among children can be metabolic acidosis, coma, respiratory depre",
      childrenComment:
          "Simultaneously we had a problem with prisoner drunkenness that we couldn't figure out. I mean , the ",
    ),
    FakeCommentModel(
      userName: "Darrell Steward",
      time: "2h",
      comment:
          "However rare side effects observed among children can be metabolic acidosis, coma, respiratory depre",
      childrenComment:
          "Simultaneously we had a problem with prisoner drunkenness that we couldn't figure out. I mean , the ",
    ),
  ];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    commentCtrl.dispose();
    commentFocus.dispose();
    scrollController.dispose(); // ← dispose
    super.onClose();
  }

  void clearAll() {
    commentCtrl.clear();
  }

  void unFocusAll() {
    commentFocus.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // API loading state
  var isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  final showChildren = false.obs;

  /// Fetch the latest  data from API
  Future<void> getCommentsList() async {
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

  void onTapReply() {}

  void toggleAnonymous(bool value) {
    postAnonymously.value = value;
  }

  var fileImage = Rxn<XFile>();

  Future<void> pickSingleImage(ImageSource source) async {
    final picker = ImagePicker();

    final XFile? selectedImage = await picker.pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.front,
    );

    if (selectedImage != null) {
      fileImage.value = selectedImage;

      print("file.name: ${selectedImage.name}");
      print("file.path: ${selectedImage.path}");
    }
  }
}
