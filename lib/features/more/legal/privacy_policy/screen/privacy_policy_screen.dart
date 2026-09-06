import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/webview/hybrid_webview_widget.dart';
import '../../../../../core/helpers/string_helper.dart';
import '../controller/privacy_policy_controller.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final epc = Get.find<PrivacyPolicyController>();

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: bgClrNew,
        appBar: CommonAppBarContent(title: Strings.privacyPolicy),

        body: Padding(
          padding: EdgeInsets.only(bottom: 60.h),
          child: CusRefreshIndicator(
            onRefresh: () => epc.fetchPrivacyPolicy(isRefresh: true),
            child: Obx(() {
              /// 🔄 LOADING
              if (epc.isLoading.value) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: 0.8.sh,
                    child: Center(child: LoadingPrimary()),
                  ),
                );
              }

              /*

              /// ❌ ERROR
              if (epc.errorMessage.value != null) {
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
                              "Unable to Load Privacy Policy",
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
                              onTap: () =>
                                  epc.fetchPrivacyPolicy(isRefresh: true),
                              text: Strings.retry,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
*/
              final data = epc.termsData.value;

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
                              Icons.privacy_tip_outlined,
                              size: 70,
                              color: Colors.grey.shade400,
                            ),

                            Gap(itemGap * 2),

                            Text(
                              "No Privacy Policy Available",
                              textAlign: TextAlign.center,
                              style: TxtStyle.outfit(
                                fs: 18,
                                w: 600,
                                color: Colors.grey.shade700,
                              ),
                            ),

                            Gap(itemGap),

                            Text(
                              "There is currently no Privacy Policy information available. Please check again later.",
                              textAlign: TextAlign.center,
                              style: TxtStyle.inter(
                                fs: 13,
                                color: Colors.grey.shade500,
                              ),
                            ),

                            Gap(itemGap * 3),
                            SmallNavBtn(
                              onTap: () =>
                                  epc.fetchPrivacyPolicy(isRefresh: true),
                              text: Strings.retry,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }

              /*
              /// ✅ DATA
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  // vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PassageComponent(
                      title: '',
                      content: SafeAutoHeightWebView(
                        description: data.description ?? '',
                      ),
                    ),

                    Gap(itemGap * 4),

                    Builder(
                      builder: (context) {
                        final date = DateHelper()
                            .formatUTCtimestamp(data.updatedAt.toString())
                            .date;

                        final time = DateHelper()
                            .formatUTCtimestamp(data.updatedAt.toString())
                            .time;

                        return PassageComponent(
                          title: Strings.lastUpdatedAt,
                          content: Text(
                            "$date, $time",
                            style: TxtStyle.outfit(fs: 11),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
*/

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
}

String normalizeHtml(String html) {
  return html.replaceAll('&nbsp;', ' ').replaceAll('\u00A0', ' ');
}

class PassageComponent extends StatelessWidget {
  final String title;
  final Widget? content;
  const PassageComponent({super.key, required this.title, this.content});

  @override
  Widget build(BuildContext context) {
    double itemGap = 1.sh * 0.01;
    return Column(
      children: [
        Text(title, style: title_600_mClr_Outfit),
        Gap(itemGap * 2),

        ?content,
      ],
    );
  }
}
