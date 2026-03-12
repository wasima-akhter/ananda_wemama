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
  final ScrollController? scrollController;
  final bool? fabSpacerOnFixed;
  final Widget? bottomNavigationBar;

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
  });

  @override
  Widget build(BuildContext context) {
    final _fabHeight = ValueNotifier<double>(0);
    return SafeArea(
      top: safeAreaTop,
      child: Scaffold(
        backgroundColor: backgroundColor ?? bgClr,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        appBar: appBar,
        extendBodyBehindAppBar: extendBodyBehindAppBar ?? false,
        extendBody: extendBody ?? false,

        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton == null
            ? null
            : MeasuredWidget(
                onMeasured: (size) => _fabHeight.value = size.height,
                child: floatingActionButton!.mB(0),
              ),
        floatingActionButtonLocation:
            floatingActionButtonLocation ?? FloatingActionButtonLocation.centerDocked,

        drawer: drawer,
        endDrawer: endDrawer,
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (isScrollable == false) {
              return ValueListenableBuilder<double>(
                valueListenable: _fabHeight,
                builder: (_, height, __) {
                  return Column(
                    children: [
                      Expanded(child: child),
                      if (bottomWidget != null) ...[bottomWidget!.getcm, Gap(itemGap * 3)],
                      // ← pushes content above the FAB
                      if (floatingActionButton != null) Gap(height),
                    ],
                  );
                },
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

                scrollController: scrollController,
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

                        if (floatingActionButton != null)
                          ValueListenableBuilder<double>(
                            valueListenable: _fabHeight,
                            builder: (_, height, __) {
                              final keyboardHeight = S.bottomInset;
                              final totalGap = keyboardHeight > 0
                                  ? height // ← keyboard open: keyboard + fab
                                  : height + 30.h; // ← keyboard closed: fab + margin
                              return Gap(totalGap);
                            },
                          ),
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

class MeasuredWidget extends StatefulWidget {
  final Widget child;
  final void Function(Size) onMeasured;
  const MeasuredWidget({super.key, required this.child, required this.onMeasured});

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
  Widget build(BuildContext context) => KeyedSubtree(key: _key, child: widget.child);
}
