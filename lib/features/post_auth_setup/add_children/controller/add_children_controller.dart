import 'package:uuid/uuid.dart';

import '../../../../app/controller_export.dart';
import '../../../../core/helpers/date_helper.dart';

class AddChildrenController extends GetxController {
  static AddChildrenController get to => Get.find<AddChildrenController>();
  final _uuid = const Uuid();

  final isLoading_ = false.obs;
  bool get isLoading => isLoading_.value;

  final children = <ChildInfo>[].obs;

  // ==========================
  // Create Child State
  // ==========================

  final createDob = Rxn<DateTime>();
  final createGender = Rxn<ChildGenderAdd>();

  bool get canCreate => createDob.value != null && createGender.value != null;

  // ==========================
  // Edit Child State
  // ==========================

  final editingChildId = RxnString();

  final editDob = Rxn<DateTime>();
  final editGender = Rxn<ChildGenderAdd>();

  bool isEditing(String childId) => editingChildId.value == childId;

  // ==========================
  // Create Flow
  // ==========================

  Future<void> pickCreateDob() async {
    final picked = await pickDatePickerToAddChild(initialDate: createDob.value);

    if (picked == null) return;

    createDob.value = picked;
  }

  void setCreateGender(ChildGenderAdd gender) {
    createGender.value = gender;
  }

  void clearCreateForm() {
    createDob.value = null;
    createGender.value = null;
  }

  void saveChild() {
    if (!canCreate) return;

    children.add(
      ChildInfo(
        id: _uuid.v4(),
        dateOfBirth: createDob.value!,
        gender: createGender.value!,
      ),
    );

    clearCreateForm();
  }

  // ==========================
  // Edit Flow
  // ==========================

  void startEditing(ChildInfo child) {
    editingChildId.value = child.id;

    editDob.value = child.dateOfBirth;
    editGender.value = child.gender;
  }

  void stopEditing() {
    editingChildId.value = null;

    editDob.value = null;
    editGender.value = null;
  }

  Future<void> pickEditDob() async {
    final picked = await pickDatePickerToAddChild(initialDate: editDob.value);

    if (picked == null) return;

    editDob.value = picked;
  }

  void setEditGender(ChildGenderAdd gender) {
    editGender.value = gender;
  }

  void saveEditedChild(String childId) {
    if (editDob.value == null || editGender.value == null) {
      return;
    }

    final index = children.indexWhere((e) => e.id == childId);

    if (index == -1) return;

    children[index] = children[index].copyWith(
      dateOfBirth: editDob.value!,
      gender: editGender.value!,
    );

    stopEditing();
  }

  void deleteChild(String childId) {
    children.removeWhere((e) => e.id == childId);

    if (editingChildId.value == childId) {
      stopEditing();
    }
  }
}

enum ChildGenderAdd { boy, girl }

class ChildInfo {
  ChildInfo({
    required this.id,
    required this.dateOfBirth,
    required this.gender,
  });

  final String id;
  final DateTime dateOfBirth;
  final ChildGenderAdd gender;

  ChildInfo copyWith({DateTime? dateOfBirth, ChildGenderAdd? gender}) {
    return ChildInfo(
      id: id,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
    );
  }
}
