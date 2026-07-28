import 'package:we_mama/features/main_tabs/experts/controller/experts_controller.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/loaders/shimmer_widget.dart';
import '../screen/experts_screen.dart';

class CardHorizontalList extends StatefulWidget {
  const CardHorizontalList({
    super.key,
    required this.title,
    required this.itemBuilder,
    required this.itemCount,
    required this.onViewAll,
    this.aspectRatio,
    required this.exc,
    required this.height,
  });

  final String title;
  final Widget Function(int index) itemBuilder;
  final int itemCount;
  final void Function() onViewAll;
  final double? aspectRatio;
  final double height;
  final ExpertsController exc;

  @override
  State<CardHorizontalList> createState() => _CardHorizontalList();
}

class _CardHorizontalList extends State<CardHorizontalList> {
  late final PageController _controller;

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _controller = PageController(
      viewportFraction: 1, // 👈 shows next card preview
    );
  }

  void next() {
    if (currentIndex < widget.itemCount - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previous() {
    if (currentIndex > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = widget.title == Strings.ongoingExpertSession
          ? widget.exc.isOngoingLoading.value
          : widget.exc.isUpcomingLoading.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          makeCardHeader(widget.title, onTap: widget.onViewAll),

          Gap(itemGap),

          /// Carousel
          SizedBox(
            // aspectRatio: widget.aspectRatio ?? 1.6,
            height: widget.height, // adjust or make responsive
            child: Stack(
              children: [
                PageView.builder(
                  controller: _controller,
                  itemCount: widget.itemCount,
                  // clipBehavior: Clip.none,
                  padEnds: false,
                  onPageChanged: (index) {
                    setState(() => currentIndex = index);
                  },
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.only(right: itemGap, bottom: itemGap),
                      child: widget.itemBuilder(index),
                    );
                  },
                ),

                /// RIGHT ARROW
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Opacity(
                      opacity: currentIndex == widget.itemCount - 1 ? 0.3 : 1,
                      child: GestureDetector(
                        onTap: isLoading ? null : next,
                        child: CircleAvatar(
                          radius: 20.r,
                          backgroundColor: c.inputBackground,
                          child: SvgIcon(
                            iconPath: IconsPath.arrowForwardSmall,
                            height: 26,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // /// LEFT ARROW
                // Positioned(
                //   left: 0,
                //   top: 0,
                //   bottom: 0,
                //   child: Center(
                //     child: Opacity(
                //       opacity: currentIndex == 0 ? 0 : 1,
                //       child: GestureDetector(
                //         onTap: previous,
                //         child: CircleAvatar(
                //           radius: 20.r,
                //           backgroundColor: ctransp,
                //           child: SvgIcon(iconPath: IconsPath.arrowBackSmall, height: 12),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class ExpertCardShimmer extends StatelessWidget {
  const ExpertCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: c.cardPrimary,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Image
          ShimmerWidget.rectangular(width: double.infinity, height: 120.h),

          10.verticalSpace,

          /// Title
          ShimmerWidget.rectangular(width: 120.w, height: 12.h),

          6.verticalSpace,

          /// Subtitle
          ShimmerWidget.rectangular(width: 80.w, height: 10.h),

          10.verticalSpace,

          /// Button
          Row(
            children: [ShimmerWidget.rectangular(width: 60.w, height: 28.h)],
          ),
        ],
      ),
    );
  }
}
