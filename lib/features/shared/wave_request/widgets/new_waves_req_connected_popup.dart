import 'package:we_mama/core/models/ui/common_data_models.dart';
import 'package:we_mama/features/main_tabs/chat/controller/chat_controller.dart';

import '../../../../app/helper_widgets_export.dart';

class NewWavesReqConnectedPopup extends StatelessWidget {
  final String myImageUrl;
  final String peerImageUrl;
  final String peerName;
  final String conversationId;
  const NewWavesReqConnectedPopup({
    super.key,
    required this.myImageUrl,
    required this.peerImageUrl,
    required this.peerName,
    required this.conversationId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 30.w, horizontal: 10.w),
          decoration: BoxDeco.decRadiusAll(20, clr: c.textOnPrimary),
          child: BounceSingleChildScrollView(
            child: Column(
              children: [
                _TopImageRow(
                  myImageUrl: myImageUrl,
                  peerImageUrl: peerImageUrl,
                ),

                Gap(itemGap * 2),

                Text(
                  "${Strings.youAnd} $peerName \n${Strings.connected}",
                  textAlign: TextAlign.center,
                  style: TxtStyle.outfitSemiB(fs: 25, w: 500),
                ),
                Gap(itemGap * 2),

                CustomBtnWTxt(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  style: TxtStyle.outfitSemiB(
                    fs: 12,
                    color: c.textOnPrimary,
                    w: 500,
                  ),
                  btnColor: c.primary,
                  onTap: () async {
                    Get.back();

                    // 4. Navigate to chat inbox after a brief moment
                    Future.delayed(const Duration(milliseconds: 500), () {
                      Get.offAndToNamed(
                        RoutePaths.chatInbox,
                        arguments: ChatInboxArgPassModel(
                          chatId: conversationId,
                          isBlocked: false,
                          autoHello: true, // ← triggers auto hello
                        ),
                      );
                    });

                    // update chatList
                    if (Get.isRegistered<ChatController>()) {
                      ChatController.to.getChatList();
                    }
                  },
                  btnTxt: Strings.sayHello,
                  isLoading: false,
                  rad: 12,
                ),
                Gap(itemGap * 1.5),
                CustomBtnWTxt(
                  outlined: true,
                  borderClr: c.secondary,
                  onTap: () {
                    if (Get.isRegistered<ChatController>()) {
                      ChatController.to.getChatList();
                    }
                    Get.back();
                  },

                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  btnTxt: Strings.keepBrowsing,
                  btnColor: ctransp,
                  style: TxtStyle.outfitSemiB(
                    fs: 12,
                    color: c.primary.withValues(alpha: 0.7),
                    w: 500,
                  ),

                  isLoading: false,
                  rad: 12,
                ),

                Gap(itemGap * 3),
                ContainerBordered(
                  contClr: c.cardPrimary,
                  hp: 12,
                  vp: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Strings.chatUnlock,
                        style: TxtStyle.interSemiB(fs: 12, w: 500),
                      ),
                      Gap(itemGap),
                      _makeChatUnlockMsges(
                        title: Strings.directMessaging,
                        subtitle: Strings.unlimitedMessagesInfo,
                        iconPath: IconsPath.lockOutlined,
                      ),
                      Gap(itemGap * 1.5),
                      _makeChatUnlockMsges(
                        title: Strings.safeEnvironment,
                        subtitle: Strings.verifiedMembersOnly,
                        iconPath: IconsPath.security,
                      ),
                      Gap(4),
                    ],
                  ),
                ),
              ],
            ).getcm,
          ),
        ),
      ],
    );
  }

  Widget _makeChatUnlockMsges({
    required String title,
    required String subtitle,
    required String iconPath,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgIconColored(iconPath: iconPath, iconColor: c.primary, height: 25),

        Gap(itemGap),

        ///
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TxtStyle.interSemiB(fs: 13, w: 500)),
              Gap(6),
              Text(
                subtitle.capEachWord(),
                style: TxtStyle.inter(fs: 11, color: c.primary),
              ).mR(6),
            ],
          ),
        ),
      ],
    );
  }
}

class _TopImageRow extends StatelessWidget {
  final String myImageUrl;
  final String peerImageUrl;

  const _TopImageRow({required this.myImageUrl, required this.peerImageUrl});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Transform.translate(
              offset: Offset(-25, 0), // half overlap
              child: _makeImage(imageUrl: myImageUrl),
            ),
            Transform.translate(
              offset: Offset(25, 0), // half overlap
              child: _makeImage(imageUrl: peerImageUrl),
            ),
          ],
        ),
      ],
    );
  }

  Widget _makeImage({required String imageUrl}) {
    return Container(
      decoration: 0.circleBrdr(brdrW: 1, brdrClr: c.primary),
      child: NetworkImageWidget(imageUrl: imageUrl, isCircle: true, radius: 40),
    );
  }
}
