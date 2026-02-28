import 'package:mama_app/core/helpers/string_helper.dart';

import '../../../app/helper_widgets_export.dart';

class CommunitySpotlight extends StatelessWidget {
  const CommunitySpotlight({super.key});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      vp: 10,
      hp: 10,

      contClr: c.cardOngoing,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,

            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(Strings.communitySpotlight.capEachWord(), style: 13.titleMclrCusFSsemi),

              ContainerBordered(
                hasBrdr: true,
                contClr: c.inputBackground,

                rad: 16,
                vp: 8,
                hp: 18,

                child: Text(Strings.joinDiscussion.capEachWord(), style: 12.titleMclrCusFSURB),
              ),
            ],
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              StackOfImages(),
              Container(child: Text("42 " + Strings.mumsAreDiscussingThis, style: normRsmSecURB)),
            ],
          ),

          CommunitySpotlightInsideCard(),
        ],
      ),
    );
  }
}

class StackOfImages extends StatelessWidget {
  const StackOfImages({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      width: 120.w,

      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Positioned(
            left: 0, // overlap amount
            child: _buildImage(IconsPath.userDemo1Sm),
          ),
          Positioned(
            left: 35, // overlap amount
            child: _buildImage(IconsPath.userDemo1Sm),
          ),
          Positioned(
            left: 70, // overlap amount
            child: _buildImage(IconsPath.userDemo1Sm),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String path) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: SvgIcon(iconPath: path),
    );
  }
}

class CommunitySpotlightInsideCard extends StatelessWidget {
  const CommunitySpotlightInsideCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      hp: 10,
      vp: 10,
      mv: 8,
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
