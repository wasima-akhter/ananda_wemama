import '../../../../app/controller_export.dart';
import '../../../../core/models/ui/fake_comment_item_model.dart';

class CommentController extends GetxController {
  final commentCtrl = TextEditingController();
  final commentFocus = FocusNode();

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

  ScrollController get myCommunityScrlCtrl => ScrollController();
  ScrollController get suggCommunityScrlCtrl => ScrollController();

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
}
