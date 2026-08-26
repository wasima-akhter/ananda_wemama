import '../../../../app/helper_widgets_export.dart';

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
  final ScrollController? scrollController;
  final bool? fabSpacerOnFixed;
  final Widget? bottomNavigationBar;
  final bool enableRefresh;

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
    this.scrollController,
    this.fabSpacerOnFixed,
    this.bottomNavigationBar,
    this.enableRefresh = true,
  });

  @override
  Widget build(BuildContext context) {
    final fabHeight = ValueNotifier<double>(0);
    return SafeArea(
      top: safeAreaTop,
      child: Scaffold(
        backgroundColor: backgroundColor ?? bgClrNew,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        appBar: appBar,
        extendBodyBehindAppBar: extendBodyBehindAppBar ?? false,
        extendBody: extendBody ?? false,

        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton == null
            ? null
            : MeasuredWidget(
                onMeasured: (size) => fabHeight.value = size.height,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [floatingActionButton!.mB(0)],
                ),
              ),
        floatingActionButtonLocation:
            floatingActionButtonLocation ??
            FloatingActionButtonLocation.centerDocked,

        drawer: drawer,
        endDrawer: endDrawer,
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (isScrollable == false) {
              return ValueListenableBuilder<double>(
                valueListenable: fabHeight,
                builder: (_, height, _) {
                  return Column(
                    children: [
                      Expanded(
                        child: child,
                      ), // 👈 bounded height — Expanded/PageView works here
                      if (bottomWidget != null) ...[
                        if (getcmLess == true)
                          bottomWidget!.get10cm
                        else
                          bottomWidget!.getcm,
                        Gap(itemGap * 3),
                      ],
                      if (floatingActionButton != null) Gap(height),
                    ],
                  ).mT(10);
                },
              );
            }
            final scrollView = CustomScrollView(
              controller: scrollController,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverPadding(
                  padding: padding ?? EdgeInsets.zero,
                  sliver: SliverToBoxAdapter(child: child.mT(10)),
                ),
                if (bottomWidget != null)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (getcmLess == true)
                          bottomWidget!.get10cm
                        else
                          bottomWidget!.getcm,
                        Builder(
                          builder: (context) {
                            final kb = MediaQuery.of(context).viewInsets.bottom;
                            return Gap(kb > 0 ? 0 : itemGap * 3);
                          },
                        ),
                        if (floatingActionButton != null)
                          ValueListenableBuilder<double>(
                            valueListenable: fabHeight,
                            builder: (_, height, _) {
                              final kb = MediaQuery.of(
                                context,
                              ).viewPadding.bottom;
                              final totalGap = kb > 0
                                  ? height + kb
                                  : height + 30.h;
                              return Gap(totalGap);
                            },
                          ),
                      ],
                    ),
                  )
                else
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Gap(itemGap * 3),
                        if (floatingActionButton != null)
                          ValueListenableBuilder<double>(
                            valueListenable: fabHeight,
                            builder: (_, height, _) {
                              final kb = MediaQuery.of(
                                context,
                              ).viewInsets.bottom;
                              final totalGap = kb > 0
                                  ? height + kb
                                  : height + 30.h;
                              return Gap(totalGap);
                            },
                          ),
                      ],
                    ),
                  ),
              ],
            );

            if (!enableRefresh) {
              return scrollView;
            }

            return CusRefreshIndicator(
              refreshKey: refreshKey,
              onRefresh: () async {
                if (onRefresh != null) {
                  await onRefresh!();
                }
              },
              child: scrollView,
            );
          },
        ),
      ),
    );
  }
}

class MeasuredWidget extends StatefulWidget {
  final Widget child;
  final void Function(Size) onMeasured;
  const MeasuredWidget({
    super.key,
    required this.child,
    required this.onMeasured,
  });

  @override
  State<MeasuredWidget> createState() => _MeasuredWidgetState();
}

class _MeasuredWidgetState extends State<MeasuredWidget> {
  final _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final box = _key.currentContext?.findRenderObject() as RenderBox?;
      if (box != null) widget.onMeasured(box.size);
    });
  }

  @override
  Widget build(BuildContext context) =>
      KeyedSubtree(key: _key, child: widget.child);
}
