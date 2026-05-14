import 'package:get/get.dart';

class PaymentController extends GetxController {
  var showAPmentFields = false.obs;

  void payStackBtnOnTap() {
    showAPmentFields.value = true;
  }
}
