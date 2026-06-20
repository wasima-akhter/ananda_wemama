import '../../../../app/helper_widgets_export.dart';
import '../controller/chat_inbox_controller.dart';
import '../model/chat_inbox_msg_item_model.dart';
import 'chat_ui_models.dart';

class ChatBubbleCont extends StatelessWidget {
  final FakeMsgItemData message;
  final ChatInboxController cic;

  const ChatBubbleCont({super.key, required this.message, required this.cic});

  bool get _isMe => message.isSentByMe;

  bool _isImageAttachment(Attachment attachment) {
    final mime = (attachment.type ?? '').toLowerCase();

    return mime.contains('image');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: 4.pv,
      child: Row(
        mainAxisAlignment: _isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_isMe) _timeWidget(),

          Flexible(child: _bubble(cic: cic)),
        ],
      ),
    );
  }

  Widget _bubble({required ChatInboxController cic}) {
    final attachments = message.attachments ?? [];

    final imageAttachments = attachments
        .where((e) => _isImageAttachment(e))
        .toList();

    final fileAttachments = attachments
        .where((e) => !_isImageAttachment(e))
        .toList();

    return Align(
      alignment: _isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: Get.width * 0.72),
        child: ContainerBordered(
          hideAlignment: true,
          rad: 14,
          vp: 8,
          hp: 10,
          contClr: _isMe ? c.secondary : c.secondary.withValues( alpha: 0.2),
          alignment: null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TEXT
              if ((message.msg).trim().isNotEmpty)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                        message.msg,
                        style: TxtStyle.outfit(
                          fs: 12,
                          w: _isMe ? 500 : 400,
                          color: _isMe ? white : c.foregroundPrimary,
                        ),
                      ),
                    ),

                    if (!_isMe) ...[Gap(itemGap), _timeWidget()],
                  ],
                ),

              /// IMAGE GRID
              if (imageAttachments.isNotEmpty) ...[
                if (message.msg.trim().isNotEmpty) Gap(10),

                GridView.builder(
                  itemCount: imageAttachments.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (_, index) {
                    final item = imageAttachments[index];

                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: NetworkImageWidget(
                            imageUrl: item.url ?? '',
                            width: double.infinity,
                            height: double.infinity,
                            enablePreview: true,
                          ),
                        ),

                        /// DOWNLOAD
                        Positioned(
                          right: 6,
                          bottom: 6,
                          child: Obx(() {
                            final isDownloading =
                                cic.downloadingUrl.value == (item.url ?? '');

                            final progress = cic.downloadProgress.value;

                            return InkWell(
                              onTap: isDownloading
                                  ? null
                                  : () async {
                                      cic.downloadingUrl.value = item.url ?? '';
                                      cic.downloadProgress.value = 0;

                                      await downloadFile(item.url ?? '', (
                                        progress,
                                      ) {
                                        cic.downloadProgress.value = progress;
                                      });

                                      cic.downloadingUrl.value = '';
                                      cic.downloadProgress.value = 0;
                                    },
                              child: Container(
                                width: 36,
                                height: 36,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: isDownloading
                                    ? Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              value: progress.clamp(0.0, 1.0),
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          ),

                                          FittedBox(
                                            child: Text(
                                              "${(progress * 100).toInt()}%",
                                              style: TxtStyle.outfit(
                                                fs: 8,
                                                color: white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : const Icon(
                                        Icons.download,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                              ),
                            );
                          }),
                        ),
                      ],
                    );
                  },
                ),
              ],

              /// FILES
              if (fileAttachments.isNotEmpty) ...[
                if (imageAttachments.isNotEmpty ||
                    message.msg.trim().isNotEmpty)
                  Gap(10),

                ...fileAttachments.map(
                  (file) => Container(
                    margin: 6.pv,
                    padding: 10.pa,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: c.scaffoldBackground,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.insert_drive_file_rounded),

                        Gap(itemGap),

                        Expanded(
                          child: Text(
                            file.originalName ?? 'File',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TxtStyle.outfit(),
                          ),
                        ),

                        Obx(() {
                          final isDownloading =
                              cic.downloadingUrl.value == (file.url ?? '');

                          final progress = cic.downloadProgress.value;

                          if (isDownloading) {
                            return SizedBox(
                              width: 28,
                              height: 28,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      value: progress,
                                      strokeWidth: 2,
                                    ),
                                  ),

                                  Text(
                                    "${(progress * 100).toInt()}",
                                    style: TxtStyle.outfit(fs: 8, color: white),
                                  ),
                                ],
                              ),
                            );
                          }

                          return IconButton(
                            onPressed: () async {
                              cic.downloadingUrl.value = file.url ?? '';
                              cic.downloadProgress.value = 0;

                              await downloadFile(file.url ?? '', (progress) {
                                cic.downloadProgress.value = progress;
                              });

                              cic.downloadingUrl.value = '';
                              cic.downloadProgress.value = 0;
                            },
                            icon: isDownloading
                                ? Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          value: progress.clamp(0.0, 1.0),
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      ),

                                      FittedBox(
                                        child: Text(
                                          "${(progress * 100).toInt()}%",
                                          style: TxtStyle.outfit(
                                            fs: 8,
                                            color: white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : const Icon(Icons.download_rounded),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _timeWidget() {
    return Container(
      padding: 2.ph,
      child: Text(
        message.time,
        maxLines: 2,
        softWrap: true,
        overflow: TextOverflow.visible,
        style: TxtStyle.outfitSemiB(fs: 10, w: 500, color: c.strokePrimary),
      ),
    );
  }
}
