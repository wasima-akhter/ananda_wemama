import 'package:mama_app/core/helpers/string_helper.dart';

import '../../../app/helper_widgets_export.dart';

class CommunitySpotlight extends StatelessWidget {
  final bool? isFromOnboardScreen;
  const CommunitySpotlight({super.key, this.isFromOnboardScreen});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      vp: 10,
      hp: 10,
      boxShadow: boxShadowBottom(),

      contClr: c.cardOngoing,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,

            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(Strings.communitySpotlight.capEachWord(), style: TxtStyle.outfitSmTitle),

              CusGestureDetector(
                onTap: () => isFromOnboardScreen == true
                    ? {}
                    : Get.toNamed(
                        RoutePaths.communityDetail,
                        arguments: {
                          'btnState': MyCommunityBtnState.join,
                          'isAlreadyMember': false, // ← came via join button = now member
                        },
                      ),
                child: ContainerBordered(
                  hasBrdr: true,
                  contClr: c.inputBackground,

                  rad: 18,
                  vp: 8,
                  hp: 18,

                  child: Text(Strings.joinDiscussion.capEachWord(), style: 12.titleMclrCusFSURB),
                ),
              ),
            ],
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              StackOfImages(),

              Gap(itemGap),
              Container(child: Text("42 " + Strings.mumsAreDiscussingThis, style: normRsmSecURB)),
            ],
          ),

          Gap(itemGap),

          CommunitySpotlightInsideCard(),
        ],
      ),
    );
  }
}

class StackOfImages extends StatelessWidget {
  final int? numOfImage;
  const StackOfImages({super.key, this.numOfImage});

  @override
  Widget build(BuildContext context) {
    const double radius = 15;
    const double overlap = 25;
    return SizedBox(
      width: (radius * 2) + (overlap * 2), // total visual width
      height: radius * 2,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.centerLeft,
        children: List.generate(numOfImage ?? 3, (index) {
          return Positioned(
            left: index * overlap,
            child: _buildImage(radius: radius),
          );
        }),
      ),
    );
  }

  Widget _buildImage({String? path, double? radius}) {
    return circledImageBgComponent(radius: radius, imagePath: path);
  }
}

class CommunitySpotlightInsideCard extends StatelessWidget {
  const CommunitySpotlightInsideCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      hp: 10,
      vp: 10,

      contClr: c.cardMood,
      child: Column(
        children: [
          Text(Strings.emotionalPostpartumQuestion.capEachWord(), style: normRsmPriURB),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(Strings.postpartumRecovery.capEachWord(), style: titleBPriURB),
              Text(Strings.repliesTimeAgo, style: normRsmPriURB),
            ],
          ),
        ],
      ),
    );
  }
}
