import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/webview/hybrid_webview_widget.dart';
import '../controller/terms_and_conditions_controller.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  @override
  Widget build(BuildContext context) {
    final tc = Get.find<TermsAndConditionsController>();

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: bgClrNew,
        appBar: CommonAppBarContent(title: Strings.termsCondition),
        body: Padding(
          padding: EdgeInsets.only(bottom: 40.w),
          child: CusRefreshIndicator(
            onRefresh: () => tc.fetchTerms(isRefresh: true),
            child: Obx(() {
              /// 🔄 LOADING
              if (tc.isLoading.value) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: 0.8.sh,
                    child: Center(child: LoadingPrimary()),
                  ),
                );
              }

              /// ❌ ERROR
              /// ❌ ERROR
              if (tc.errorMessage.value != null) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: 0.8.sh,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              size: 70,
                              color: c.primary,
                            ),

                            Gap(itemGap * 2),

                            Text(
                              "Unable to Load Terms & Conditions",
                              textAlign: TextAlign.center,
                              style: TxtStyle.outfit(fs: 18, w: 600),
                            ),

                            Gap(itemGap),

                            Text(
                              "Please pull down to refresh or try again later.",
                              textAlign: TextAlign.center,
                              style: TxtStyle.inter(
                                fs: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),

                            Gap(itemGap * 3),

                            SmallNavBtn(
                              onTap: () => tc.fetchTerms(isRefresh: true),
                              text: Strings.retry,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }

              final data = tc.termsData.value;

              /// 📭 EMPTY
              if (data == null || (data.description.trim().isEmpty ?? true)) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),

                  child: SizedBox(
                    height: 0.8.sh,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.description_outlined,
                              size: 70,
                              color: Colors.grey.shade400,
                            ),

                            Gap(itemGap * 2),

                            Text(
                              "No Terms & Conditions Available",
                              textAlign: TextAlign.center,
                              style: TxtStyle.outfit(
                                fs: 18,
                                w: 600,
                                color: Colors.grey.shade700,
                              ),
                            ),

                            Gap(itemGap),

                            Text(
                              "There is currently no Terms & Conditions information available. Please check again later.",
                              textAlign: TextAlign.center,
                              style: TxtStyle.inter(
                                fs: 13,
                                color: Colors.grey.shade500,
                              ),
                            ),

                            Gap(itemGap * 3),

                            SmallNavBtn(
                              onTap: () => tc.fetchTerms(isRefresh: true),
                              text: Strings.retry,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }

              return HybridWebViewWidget(
                htmlContent: normalizeHtml(data.description ?? ''),
                // maxHeight: S.h * 0.6,
                textColor: c.foregroundSecondary,
              ).getcm;
            }),
          ),
        ),
      ),
    );
  }

  String normalizeHtml(String html) {
    return html.replaceAll('&nbsp;', ' ').replaceAll('\u00A0', ' ');
  }
}
