import 'package:image_picker/image_picker.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../app/service_export.dart';
import '../../../../core/utils/validator/validators.dart';
import '../controller/edit_profile_controller.dart';
import '../widgets/user_photo_widget.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double itemGap = 1.sh * 0.01;

    final epc = Get.find<EditProfileController>();
    final refreshKey = GlobalKey<RefreshIndicatorState>();
    final formkey = GlobalKey<FormState>();

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: bgClr,
        appBar: CommonAppBarContent(title: Strings.editProfile),
        body: Center(
          child: CusRefreshIndicator(
            refreshKey: refreshKey,
            onRefresh: () async {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(() {
                  final selImage = epc.fileImage.value;
                  return UserPhotoWidget(
                    // imageUrl: "http://10.10.20.57:8001/${storage.getUserInfo.imageUrl}",
                    imageUrl: makeImageUrl(imageUrl: storage.getUserInfo.imageUrl ?? ''),
                    selImage: selImage,
                  );
                }),
                Gap(itemGap),
                CustomBtnWTxt(
                  // style: TxtStyle.interSemiB(fs: 11, w: 700),
                  isSmall: true,
                  txtClr: c.textPrimary,
                  style: TxtStyle.interSemiB(fs: 11, w: 700),
                  padding: const EdgeInsets.all(5),
                  onTap: () async {
                    showPickImageBottomSheet(
                      isScrollControlled: true,
                      onTapGallery: () async {
                        await epc.pickSingleImage(ImageSource.gallery);
                        // place the selected image in the photo
                      },
                      onTapCamera: () async {
                        await epc.pickSingleImage(ImageSource.camera);
                      },
                    );

                    // open gallery
                  },
                  w: 100,

                  btnTxt: Strings.editPhoto,
                  isLoading: false,
                ),

                Form(
                  key: formkey,
                  child: Column(
                    children: [
                      Gap(itemGap * 6),

                      CusNameTypeTextFormField(
                        controller: epc.nameCtrl,
                        validator: (value) => validateName(value),
                        hintText: '',
                      ),
                      Gap(itemGap),

                      CusNameTypeTextFormField(
                        controller: epc.phoneCtrl,
                        validator: (value) => validatePhone(value),
                        hintText: '',
                      ),
                      Gap(itemGap * 4),
                    ],
                  ),
                ),

                Obx(
                  () => CustomBtnWTxt(
                    btnTxt: Strings.save,

                    isLoading: epc.isLoading,
                    onTap: () {
                      epc.updateProfileDetails(
                        name: epc.nameCtrl.text,
                        phone: epc.phoneCtrl.text,
                        formkey: formkey,
                        profileImage: epc.fileImage.value,
                      );
                    },
                  ),
                ),
                Gap(itemGap * 1.5),
              ],
            ).getcm,
          ),
        ),
      ),
    );
  }
}
