import 'package:share_plus/share_plus.dart';

class ShareUtil {
  Future<void> shareCommunity(String title, String url) async {
    await SharePlus.instance.share(
      ShareParams(
        text: "$title\n$url",
      ),
    );
  }
}