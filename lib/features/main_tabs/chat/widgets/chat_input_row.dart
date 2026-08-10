import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/components/ui/dialogs/popups.dart';
import '../../../../core/components/ui/inputs/cus_des_type_text_form_field.dart';
import '../controller/chat_inbox_controller.dart';

class ChatInputRow extends StatelessWidget {
  final ChatInboxController cic;

  const ChatInputRow({super.key, required this.cic});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// ── Attachments preview ──
        Obx(() {
          final files = cic.pickedFiles;

          if (files.isEmpty) return const SizedBox.shrink();

          final images = files.where(isImageFile).toList();
          final nonImages = files.where((f) => !isImageFile(f)).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ── IMAGE ROW ──
              if (images.isNotEmpty)
                ContainerBordered(
                  vp: 2,
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: itemGap,
                    runSpacing: itemGap,
                    children: images.map((file) {
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          /// Image tile
                          CusGestureDetector(
                            onTap: () => showImageViewer(
                              context: context,
                              imageSource: file,
                            ),
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(File(file.path)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),

                          /// Remove button
                          Positioned(
                            top: -6,
                            right: -6,
                            child: CusGestureDetector(
                              onTap: () => cic.removeFileByValue(file),
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: c.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),

              /// ── NON-IMAGE FILE LIST ──
              if (nonImages.isNotEmpty) ...[
                ContainerBordered(
                  vp: 2,
                  // contClr: Colors.amber,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: nonImages.map((file) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: itemGap / 2),
                        child: Row(
                          children: [
                            Icon(
                              Icons.insert_drive_file_outlined,
                              size: 18,
                              color: c.primary,
                            ),
                            Gap(itemGap / 2),

                            Expanded(
                              child: Text(
                                file.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: 12.norSecclrCusFSoutfit,
                              ),
                            ),

                            CusGestureDetector(
                              onTap: () => cic.removeFileByValue(file),
                              child: Icon(
                                Icons.close,
                                size: 18,
                                color: c.primary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ],
          );
        }),

        /// ── Input row ──
        ContainerBordered(
          vp: 0,
          rad: 30,
          hp: 0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Text input
              Expanded(
                child: CusDesTypeTextFormField(
                  controller: cic.msgInputController,
                  focusNode: cic.msgInputFocus,
                  hintText: Strings.typeSomething,
                  minLines: 1,
                  minHeight: 40,
                  suffix: CusCircleIconButton(
                    radius: 15,
                    onTap: () async {
                      final canPickMore =
                          cic.canAddImages(1) || cic.canAddFiles(1);

                      if (!canPickMore) {
                        Get.snackbar(
                          "Limit reached",
                          "You can upload maximum 5 files only.",
                        );
                        return;
                      }

                      await showPickAnyFileBottomSheet(
                        onTapGallery: () async {
                          Get.back();

                          if (!cic.canAddImages(1)) {
                            Get.snackbar(
                              "Limit reached",
                              "You can upload maximum 5 images only.",
                            );
                            return;
                          }

                          await cic.pickMultipleFiles(
                            source: ImageSource.gallery,
                          );
                        },
                        onTapCamera: () async {
                          Get.back();

                          if (!cic.canAddImages(1)) {
                            Get.snackbar(
                              "Limit reached",
                              "You can upload maximum 5 images only.",
                            );
                            return;
                          }

                          await cic.pickMultipleFiles(
                            source: ImageSource.camera,
                          );
                        },
                        onTapFile: () async {
                          Get.back();

                          if (!cic.canAddFiles(1)) {
                            Get.snackbar(
                              "Limit reached",
                              "You can upload maximum 5 files only.",
                            );
                            return;
                          }

                          await cic.pickMultipleFiles();
                        },
                      );
                    },
                    child: SvgIcon(
                      iconPath: IconsPath.addPlusCircle,
                      height: 26,
                    ),
                  ),
                ),
              ),

              Gap(itemGap),

              /// Send button
              Obx(() {
                final isLoading = cic.isSending;

                return CusGestureDetector(
                  onTap: isLoading ? null : cic.onTapSendMsg,
                  child: ContainerBordered(
                    rad: 30,
                    hp: ScreenSizeX.isTablet ? 6 : 22,
                    vp: 10,
                    contClr: isLoading
                        ? c.secondary.withOpacity(0.5)
                        : c.secondary,
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : SvgIcon(
                            iconPath: IconsPath.sendSmallWhite,
                            height: 20,
                          ),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
