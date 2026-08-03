import '../../../../../../app/helper_widgets_export.dart';
import '../../../../../../core/components/ui/dialogs/popup_input_tile.dart';
import '../../../../../../core/components/ui/inputs/cus_des_type_text_form_field.dart';
import '../../../../../../core/helpers/date_helper.dart';
import '../../../../../../core/utils/validator/validators.dart';
import '../controller/edit_profile_controller.dart';

class EditProfileForm extends StatelessWidget {
  const EditProfileForm({super.key, required this.epc, required this.formKey});

  final EditProfileController epc;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Gap(itemGap * 2),

          CusNameTypeTextFormField(
            rad: 12,
            controller: epc.nameCtrl,
            hintText: Strings.name,
            hintStyle: TxtStyle.outfitSemiB(fs: 13),
            style: TxtStyle.outfitSemiB(fs: 13, w: 400),
            brdrClr: c.inputBorder,
            fillColor: c.cardPrimary,
            focusNode: epc.nameFocus,
            validator: (value) => validateName(value),
          ),

          Gap(itemGap),

          Obx(
            () => PopupInputTile(
              rad: 12,
              hintText: Strings.dateOfBirth.cap,
              value: epc.selectedDob.value,
              brdrClr: c.inputBorder,
              brdrW: 0.6,
              onTap: () => pickDateWithOptions(
                selectedDate: epc.selectedDob,
                keepPrivate: epc.keepDobPrivate,
                unfocusAll: epc.unfocusAll,
              ),
            ),
          ),
          Gap(itemGap),

          PopupInputTile(
            rad: 12,
            hintText: Strings.mumsStage.cap,
            value: Strings.mumsStage.cap, // epc.selectedMumStage.value,
            brdrClr: c.inputBorder,
            brdrW: 0.6,
            onTap: epc.openMumStagePicker,
          ),

          Gap(itemGap),

          PopupInputTile(
            rad: 12,
            hintText: Strings.lifestyleInterests.cap,
            value:
                Strings.lifestyleInterests.cap, //epc.selectedInterests.value,
            brdrClr: c.inputBorder,
            brdrW: 0.6,
            onTap: epc.openInterestsPicker,
          ),

          Gap(itemGap),

          Obx(
            () => PopupInputTile(
              rad: 12,
              hintText: Strings.state.cap,
              value: "${Strings.state.cap}: ${epc.selectedState.value}",
              brdrClr: c.inputBorder,
              brdrW: 0.6,
              onTap: epc.openStateBottomSheet,
            ),
          ),

          Gap(itemGap),

          Obx(
            () => PopupInputTile(
              rad: 12,
              hintText: Strings.city.cap,
              value: "${Strings.city.cap}: ${epc.selectedCity.value}",
              brdrClr: c.inputBorder,
              brdrW: 0.6,
              onTap: epc.openCityBottomSheet,
            ),
          ),

          Gap(itemGap),

          Obx(
            () => PopupInputTile(
              rad: 12,
              hintText: Strings.children.cap,
              value: epc.children.isEmpty
                  ? Strings.children.cap
                  : "${Strings.children.cap} (${epc.children.length})",
              brdrClr: c.inputBorder,
              brdrW: 0.6,
              onTap: epc.openChildrenBottomSheet,
            ),
          ),

          Gap(itemGap),

          CusDesTypeTextFormField(
            controller: epc.bioCtrl,
            hintText: Strings.writeBioHere,
            hintStyle: TxtStyle.outfitSemiB(fs: 13),
            style: TxtStyle.outfitSemiB(fs: 13, w: 400),
            rad: 12,
            focusNode: epc.bioFocus,
            bgClr: c.cardPrimary,
            validator: (value) => validateDescription(value),
          ),

          Gap(itemGap * 2.5),
        ],
      ),
    );
  }
}
