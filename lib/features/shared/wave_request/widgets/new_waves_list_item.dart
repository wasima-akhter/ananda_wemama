import 'package:mama_app/core/common_widgets/popups.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/common_widgets/common_components/user_detaIl_component/user_detail_controller/user_detail_controller.dart' ;
import '../../../main_tabs/chat/widgets/chat_user_image.dart';
import '../controller/wave_request_controller.dart';

class NewWavesListItem extends StatelessWidget {
  final WaveRequestController wrc;
  final FakeNewWavesModel chatModel;

  const NewWavesListItem({super.key, required this.chatModel, required this.wrc});

  @override
  Widget build(BuildContext context) {
    final imageUrl = chatModel.imageUrl;
    final name = chatModel.name;
    final time = chatModel.time;


    final udc = Get.find<UserDetailController>();


    return CusGestureDetector(
      onTap: () {
        // show a pop up with wave details
        newWavesUserDetailsDialog(
          
          isLoading: udc.isLoading_,
          onTapAction: wrc.onTapAction ,
          isSeeMore: udc.isSeeMore,
          onTapSeeMoreTxt: udc.toggleSeeMore,
          user: udc.fakeUserDetails  
        );
      },
      child: ContainerBordered(
        mv: 10,

        vp: 0,
        hp: 0,
        child: Row(
          children: [
            ChatUserImage(imageUrl: imageUrl, name: name),
            Gap(itemGap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    name.cap,
                    style: TxtStyle.outfitSemiB(fs: 16, w: 500, color: c.primary),
                  ),
                ],
              ),
            ),

            Gap(itemGap),
            Text(time.cap, style: TxtStyle.outfitSmSecNor500),
          ],
        ),
      ).get10cm.mR(10),
    );
  }
}
