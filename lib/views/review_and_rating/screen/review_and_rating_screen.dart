import '../../../app/helper_widgets_export.dart';
import '../controller/review_and_rating_controller.dart';
import '../model/review_model.dart';
import '../widgets/rating_review_shimmer.dart';
import '../widgets/rating_widgets.dart';

class ReviewAndRatingScreen extends StatelessWidget {
  final String supplierId;
  const ReviewAndRatingScreen({super.key, required this.supplierId});

  @override
  Widget build(BuildContext context) {
    final rrc = Get.find<ReviewAndRatingController>();
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CommonAppBarContent(title: Strings.reviewAndRating),
        resizeToAvoidBottomInset: true,
        backgroundColor: bgClr,
        body: Obx(() {
          final showAllReviews = rrc.showAllReviews.value;
          final listOfReviews = rrc.allReviewsData.value.allReviews ?? [];

          final listOfReviews1Less = (listOfReviews != null && listOfReviews.length > 1)
              ? listOfReviews.sublist(1)
              : <AllReview>[]; // empty list if null or only 1 item

          print("reviewlist length: ${listOfReviews1Less.length}");

          final isLoading = rrc.isLoading;

          if (isLoading) return ReviewAndRating1stPartShimmer();

          return SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                ReviewAndRating1stPart(rrc: rrc),
                if (showAllReviews) ReviewTemplate(reviewList: listOfReviews1Less).get10cm,
              ],
            ),
          );
        }).get10cm,
      ),
    );
  }
}

class ReviewAndRating1stPart extends StatelessWidget {
  final ReviewAndRatingController rrc;
  const ReviewAndRating1stPart({super.key, required this.rrc});

  @override
  Widget build(BuildContext context) {
    final ratingInfo = rrc.allReviewsData.value.result?.first;
    final rating = (ratingInfo?.averageRating ?? 0).toString();
    final totalReviews = (ratingInfo?.totalReviews ?? 0).toString();
    final starWise = ratingInfo?.starWise;
    final the1Star = (starWise?.the1Star ?? 0).toString();
    final the2Star = (starWise?.the2Star ?? 0).toString();
    final the3Star = (starWise?.the3Star ?? 0).toString();
    final the4Star = (starWise?.the4Star ?? 0).toString();
    final the5Star = (starWise?.the5Star ?? 0).toString();

    final listOfReviews = rrc.allReviewsData.value.allReviews ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.whatOthersThinkAboutSupplier, style: TxtStyle.inter(fs: 18)),
        Gap(itemGap * 2),
        ItemTemplate(
          title: Strings.reviewAndRatings.capEachWord(),

          subWidget: Row(
            children: [
              Text(rating, style: TxtStyle.inter(fs: 11, w: 600, color: c.primary)),
              Gap(5),
              Row(
                children: List.generate(5, (index) {
                  return SvgIcon(
                    iconPath: index == 4 ? IconsPath.starFilled : IconsPath.starFilled,
                    height: index == 4 ? 9 : 10,
                  ).mR(2);
                }),
              ),
              Gap(5),

              Text(
                "[${int.parse(totalReviews).formatToK()} ${Strings.review}]",
                style: TxtStyle.inter(fs: 11, w: 600),
              ),
            ],
          ),
          rightText: "",
        ),
        Gap(itemGap * 2),

        RatingCard(
          ratingmap: RatingMap(
            numOfstar1: the1Star,
            numOfstar2: the2Star,
            numOfstar3: the3Star,
            numOfstar4: the4Star,
            numOfstar5: the5Star,
          ),
        ),
        Gap(itemGap * 2.5),

        ReviewTemplate(reviewList: listOfReviews?.take(1).toList() ?? []),

        if (!rrc.showAllReviews.value && listOfReviews?.length != 1)
          CustomBtnWTxt(
            borderClr: c.primary,
            txtClr: c.primary,

            outlined: true,
            btnTxt: Strings.readAllReviews,
            onTap: rrc.readAllReviewOnTap,
            isLoading: false,
          ).mT(itemGap * 2),
        Gap(itemGap * 2.5),
      ],
    ).get10cm;
  }
}
