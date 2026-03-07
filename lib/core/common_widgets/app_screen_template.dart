import '../../app/helper_widgets_export.dart';

class AppScreenTemplate extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final bool resizeToAvoidBottomInset;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final Widget? bottomWidget;
  final bool? extendBodyBehindAppBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? drawer;
  final Widget? endDrawer;
  final bool safeAreaTop;
  final bool safeAreaBottom;
  final bool? extendBody;
  final bool? isScrollable;
  final Future<void> Function()? onRefresh;
  final GlobalKey<RefreshIndicatorState>? refreshKey;
  final bool? getcmLess;

  const AppScreenTemplate({
    super.key,
    required this.child,
    this.appBar,
    this.resizeToAvoidBottomInset = true,
    this.backgroundColor,
    this.padding,
    this.bottomWidget,
    this.extendBodyBehindAppBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
    this.endDrawer,
    this.safeAreaTop = false,
    this.safeAreaBottom = true,
    this.extendBody,
    this.isScrollable,
    this.onRefresh,
    this.refreshKey,
    this.getcmLess,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: safeAreaTop,
      child: Scaffold(
        backgroundColor: backgroundColor ?? bgClr,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        appBar: appBar,
        extendBodyBehindAppBar: extendBodyBehindAppBar ?? false,
        extendBody: extendBody ?? false,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation:
            floatingActionButtonLocation ?? FloatingActionButtonLocation.centerDocked,
        drawer: drawer,
        endDrawer: endDrawer,
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (isScrollable == false) {
              return Column(
                children: [
                  Expanded(child: child),
                  if (bottomWidget != null) ...[bottomWidget!.getcm, Gap(itemGap * 3)],
                ],
              );
            }
            return CusRefreshIndicator(
              refreshKey: refreshKey,
              onRefresh: () async {
                if (onRefresh != null) {
                  await onRefresh?.call();
                }
              },
              child: BounceSingleChildScrollView(
                padding: padding ?? EdgeInsets.zero,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    // ← makes Column respect minHeight
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        child,
                        if (bottomWidget != null) ...[
                          const Spacer(), // ← now safe because height is bounded by IntrinsicHeight
                          if (getcmLess == true) bottomWidget!.get10cm else bottomWidget!.getcm,
                        ] else
                          const SizedBox.shrink(),
                        Gap(itemGap * 3),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
