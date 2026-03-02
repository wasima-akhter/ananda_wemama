import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/common_widgets/html_viewer_auto_height.dart';
import '../../../../../core/helpers/string_helper.dart';
import '../controller/privacy_policy_controller.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double itemGap = 1.sh * 0.01;

    final epc = Get.find<PrivacyPolicyController>();
    final refreshKey = GlobalKey<RefreshIndicatorState>();

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: bgClr,
        appBar: CommonAppBarContent(title: Strings.privacyPolicy),
        body: Obx(() {
          /// 🔄 LOADING
          if (epc.isLoading.value) {
            return Center(child: Loading());
          }

          /// ❌ ERROR
          if (epc.errorMessage.value != null) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      epc.errorMessage.value!,
                      textAlign: TextAlign.center,
                      style: TxtStyle.inter(),
                    ),
                    Gap(itemGap * 2),
                    ElevatedButton(onPressed: () => epc.fetchPrivacyPolicy(), child: Text("Retry")),
                  ],
                ),
              ),
            );
          }

          final data = epc.termsData.value;

          /// 📭 EMPTY
          if (data == null) {
            return Center(child: Text("No terms available"));
          }

          /// ✅ DATA
          return CusRefreshIndicator(
            refreshKey: refreshKey,
            onRefresh: () => epc.fetchPrivacyPolicy(isRefresh: true),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 📜 TERMS CONTENT
                  PassageComponent(
                    title: Strings.privacyPolicy,
                    content: SafeAutoHeightWebView(description: data.description ?? ''),
                  ),

                  Gap(itemGap * 4),

                  /// 🗓 LAST UPDATED
                  PassageComponent(
                    title: Strings.lastUpdated,
                    content: Text(
                      data.updatedAt?.toString() ?? "N/A",
                      style: TxtStyle.inter(fs: 11),
                    ),
                  ),

                  Gap(40),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class PassageComponent extends StatelessWidget {
  final String title;
  final Widget? content;
  const PassageComponent({Key? key, required this.title, this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double itemGap = 1.sh * 0.01;
    return Column(
      children: [
        Text(title, style: title_600_mClr_Outfit),
        Gap(itemGap * 2),

        if (content != null) content!,
      ],
    );
  }
}
