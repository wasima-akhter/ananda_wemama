import '../../../../app/helper_widgets_export.dart';

class AuthScaffold extends StatelessWidget {
  final Widget child;
  final Widget? bottomWidget;
  final PreferredSizeWidget? appBar;
  final bool resizeToAvoidBottomInset;
  final Color? backgroundColor;

  const AuthScaffold({
    super.key,
    required this.child,
    this.bottomWidget,
    this.appBar,
    this.resizeToAvoidBottomInset = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: backgroundColor ?? bgClrNew,
        extendBodyBehindAppBar: false,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        appBar: appBar ?? getOnboardAppBar(),

        bottomNavigationBar: bottomWidget == null
            ? null
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: S.bottomInset + 20),
                    child: bottomWidget?.getcm,
                  ),
                ],
              ),

        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: child,
              ),
            );
          },
        ),
      ),
    );
  }
}

AppBar getOnboardAppBar({bool? hasBack}) {
  return AppBar(
    toolbarHeight: 18.h,
    backgroundColor: bgClrNew,
    leading: Container(),
    surfaceTintColor: bgClrNew,
  );
}
