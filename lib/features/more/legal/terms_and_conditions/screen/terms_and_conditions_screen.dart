import 'package:mama_app/core/helpers/date_helper.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../../../../../core/components/ui/media/html_viewer_auto_height.dart';
import '../../../../../core/helpers/string_helper.dart';
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
        body: Padding(
          padding: EdgeInsets.only(bottom: 40.w),
          child: CusRefreshIndicator(
            refreshKey: refreshKey,
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
              if (data == null || (data.description?.trim().isEmpty ?? true)) {
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

              /// ✅ DATA
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
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

                    const Gap(40),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class PassageComponent extends StatelessWidget {
  final String title;
  final Widget? content;
  const PassageComponent({super.key, required this.title, this.content});

  @override
  Widget build(BuildContext context) {
    double itemGap = 1.sh * 0.01;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) Text(title, style: title_600_mClr_Outfit),
        Gap(itemGap * 2),

        ?content,
      ],
    );
  }
}

/*
{
    "description":  "<div><p style=\"margin-top:0pt; margin-bottom:0pt;\"> </p><p style=\"margin-top:0pt; margin-bottom:0pt; background-color:#f5f6fa;\"><span style=\"font-family:Roboto; color:#363840;\">Terms and Conditions isduidsfvi idufvb dfuvghf vodufvou doudv iu</span></p></div>"


}
*/
