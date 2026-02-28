import '../../../../app/helper_widgets_export.dart';
import '../../../../core/common_widgets/html_viewer_auto_height.dart';
import '../../../../core/helpers/string_helper.dart';
import '../controller/terms_and_conditions_controller.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tc = Get.find<TermsAndConditionsController>();
    final refreshKey = GlobalKey<RefreshIndicatorState>();
    double itemGap = 1.sh * 0.01;
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: bgClr,
        appBar: CommonAppBarContent(title: Strings.termsCondition),
        body: Obx(() {
          /// 🔄 LOADING
          if (tc.isLoading.value) {
            return Center(child: Loading());
          }

          /// ❌ ERROR
          if (tc.errorMessage.value != null) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      tc.errorMessage.value!,
                      textAlign: TextAlign.center,
                      style: TxtStyle.inter(),
                    ),
                    Gap(itemGap * 2),
                    ElevatedButton(onPressed: () => tc.fetchTerms(), child: Text("Retry")),
                  ],
                ),
              ),
            );
          }

          final data = tc.termsData.value;

          /// 📭 EMPTY
          if (data == null) {
            return Center(child: Text("No terms available"));
          }

          /// ✅ DATA
          return CusRefreshIndicator(
            refreshKey: refreshKey,
            onRefresh: () => tc.fetchTerms(isRefresh: true),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 📜 TERMS CONTENT
                  PassageComponent(
                    title: Strings.termsCondition,
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

/*
{
    "description":  "<div><p style=\"margin-top:0pt; margin-bottom:0pt;\"> </p><p style=\"margin-top:0pt; margin-bottom:0pt; background-color:#f5f6fa;\"><span style=\"font-family:Roboto; color:#363840;\">Terms and Conditions isduidsfvi idufvb dfuvghf vodufvou doudv iu</span></p></div>"
 

}
*/
