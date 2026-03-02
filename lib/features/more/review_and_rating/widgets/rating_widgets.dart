import '../../../../app/helper_widgets_export.dart';
import '../../../../core/common_widgets/progress_bar_widget.dart';
import '../../../../core/helpers/date_helper.dart';
import '../model/review_model.dart';

class ItemTemplate extends StatelessWidget {
  final String title;
  final Widget subWidget;
  final String rightText;
  final double? hp;
  const ItemTemplate({
    super.key,
    required this.title,
    required this.subWidget,
    required this.rightText,
    this.hp,
  });

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      hp: hp ?? 15,
      vp: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(title, style: componentTxtStyle),

                Gap(5),
                subWidget,
              ],
            ),
          ),
          Text(rightText, style: TxtStyle.inter(fs: 10, w: 700)),
        ],
      ),
    );
  }
}

class RatingCard extends StatelessWidget {
  final RatingMap ratingmap;

  const RatingCard({super.key, required this.ratingmap});

  @override
  Widget build(BuildContext context) {
    // Convert RatingMap to a list for easier mapping
    final ratingValues = [
      ratingmap.numOfstar1,
      ratingmap.numOfstar2,
      ratingmap.numOfstar3,
      ratingmap.numOfstar4,
      ratingmap.numOfstar5,
    ];

    return ContainerBordered(
      hp: 15,
      vp: 15,
      hasBrdr: true,
      brdrClr: c.inputBorder,
      boxShadow: boxShadowAllSides,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(Strings.ratings.capEachWord(), style: TxtStyle.inter(fs: 11, w: 700)),
          Gap(itemGap * 1.5),

          // Rating bars
          ListView.separated(
            separatorBuilder: (context, index) => Gap(itemGap * 0.3),
            reverse: true, // optional: highest stars at top
            itemCount: ratingValues.length,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return RatingProgressBar(
                ratingValue: ratingValues[index], // get correct value
                index: index + 1, // show stars 1..5
              );
            },
          ),
        ],
      ),
    );
  }
}

class RatingProgressBar extends StatelessWidget {
  final String ratingValue;
  final int index;
  const RatingProgressBar({super.key, required this.ratingValue, required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Container(
                width: 9,
                child: Text(index.toString(), style: TxtStyle.inter(w: 600, fs: 11)),
              ),

              Gap(2), // small real gap

              SvgIcon(
                iconPath: ratingValue == "0" ? IconsPath.starFilled : IconsPath.starFilled,
                height: 12,
              ),
            ],
          ),
        ),

        Gap(6),

        Expanded(flex: 7, child: ProgressBarWidget(percent: ratingValue, barThickness: 4)),

        Gap(6),

        Expanded(
          flex: 2,
          child: TextFit(
            int.parse(ratingValue).formatToK(),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: TxtStyle.inter(w: 600, fs: 11),
          ),
        ),
      ],
    );
  }
}

class RatingMap {
  final String numOfstar1;
  final String numOfstar2;
  final String numOfstar3;
  final String numOfstar4;
  final String numOfstar5;

  RatingMap({
    required this.numOfstar1,
    required this.numOfstar2,
    required this.numOfstar3,
    required this.numOfstar4,
    required this.numOfstar5,
  });
}

class ReviewTemplate extends StatelessWidget {
  final List<AllReview> reviewList;
  const ReviewTemplate({super.key, required this.reviewList});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(reviewList.length, (index) {
          final reviewItem = reviewList[index];
          final agoTxt = DateHelper().formatTimeAgo(reviewItem.updatedAt.toString()).date;
          final rating = (reviewItem.rating ?? 0).toString();
          final reviewerName = (reviewItem.reviewerName ?? '').capEachWord();
          final review = (reviewItem.description ?? '').cap;

          return ContainerBordered(
            hp: 15,
            vp: 15,
            hasBrdr: true,
            brdrClr: c.inputBorder,
            boxShadow: boxShadowAllSides,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ItemTemplate(
                  hp: 0,
                  title: reviewerName,
                  subWidget: StarsHorList(rating: rating),
                  rightText: agoTxt,
                ),
                Gap(itemGap * 2),

                // Text("There are many variations of passage", style: TxtStyle.inter(w: 600)),
                Text(review, style: TxtStyle.inter(fs: 11, h: 1.3)),
              ],
            ),
          ).mB(reviewList.length == 1 ? 0 : 12);
        }),
      ],
    );
  }
}

class StarsHorList extends StatelessWidget {
  final String rating;
  const StarsHorList({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    final ratingInt = int.parse(rating);
    return Row(
      children: List.generate(5, (index) {
        return SvgIcon(
          iconPath: index < ratingInt ? IconsPath.starFilled : IconsPath.starFilled,
          height: index < ratingInt ? 10 : 9,
        ).mR(2);
      }),
    );
  }
}
