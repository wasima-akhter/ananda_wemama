import '../../../../../app/controller_export.dart';

class CommentController extends GetxController {
  final commentCtrl = TextEditingController();
  final commentFocus = FocusNode();

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

  void onTapReply() {}
}
