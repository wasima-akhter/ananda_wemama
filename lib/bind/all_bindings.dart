// import 'package:get/get.dart';
// import 'package:mama_app/views/video_meeting/controller/meeting_controller.dart';

// class MeetingBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<MeetingController>(() => MeetingController(), fenix: true);
//   }
// }

// class HomeBinding extends Bindings {
//   @override
//   void dependencies() {
//     // Get.lazyPut<MeetingController>(() => MeetingController(), fenix: true);
//   }
// }

// // class ForgotPasswordScreenBinding extends Bindings {
// //   @override
// //   void dependencies() {
// //     Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController());
// //   }
// // }

// // class SigninScreenBinding extends Bindings {
// //   @override
// //   void dependencies() {
// //     Get.lazyPut<SigninController>(() => SigninController());
// //   }
// // }

// // class SignupScreenBinding extends Bindings {
// //   @override
// //   void dependencies() {
// //     Get.lazyPut<SignupController>(() => SignupController());
// //   }
// // }

// // class OtpScreenBinding extends Bindings {
// //   @override
// //   void dependencies() {
// //     final args = Get.arguments as Map<String, dynamic>?;

// //     Get.lazyPut<VerifyOtpController>(
// //       () => VerifyOtpController(
// //         flowType: args?['flow'] ?? OtpFlowType.signup,
// //         email: args?['email'] ?? storage.getUserEmail,
// //       ), // fallback for signup
// //     );
// //   }
// // }

// // class MainNavBinding extends Bindings {
// //   @override
// //   void dependencies() {
// //     Get.put(StationLocationController(), permanent: true);
// //     // 🔥 CREATE PROFILE FIRST
// //     Get.put(ProfileController(), permanent: true);

// //     Get.put(RevenueHistoryController());
// //     Get.put(SuppliersAllOrdersController());

// //     Get.put(HomeSupplierController(), permanent: true);
// //     Get.put(HomeController(), permanent: true);

// //     // THEN MainNav can safely find it
// //     Get.put(MainNavController(), permanent: true);

// //     Get.put(CustomerOrderDraftController());

// //     Get.lazyPut<CustomerOrdersController>(() => CustomerOrdersController());
// //     Get.lazyPut<SpentController>(() => SpentController());
// //     Get.lazyPut<EditProfileController>(() => EditProfileController());
// //     Get.lazyPut<SuccessController>(() => SuccessController());
// //     Get.lazyPut<PrivacyPolicyController>(() => PrivacyPolicyController());

// //     Get.lazyPut<CustomerCreateOrderDetailSelectionController>(
// //       () => CustomerCreateOrderDetailSelectionController(),
// //     );
// //     Get.lazyPut<PaymentController>(() => PaymentController());
// //     Get.lazyPut<InventoryController>(() => InventoryController());

// //     Get.lazyPut<NotificationSettingsController>(() => NotificationSettingsController());
// //   }
// // }

// // class CreateOrderBinding extends Bindings {
// //   @override
// //   void dependencies() {
// //     Get.lazyPut<CreateOrderController>(() => CreateOrderController());
// //   }
// // }

// // class AccountSettingsBinding extends Bindings {
// //   @override
// //   void dependencies() {
// //     Get.lazyPut<AccountSettingsController>(() => AccountSettingsController());
// //   }
// // }

// // class BankDetailsBinding extends Bindings {
// //   @override
// //   void dependencies() {
// //     Get.lazyPut<BankDetailsController>(() => BankDetailsController());
// //   }
// // }

// // class ChangePasswordBinding extends Bindings {
// //   @override
// //   void dependencies() {
// //     Get.lazyPut<ChangePasswordController>(() => ChangePasswordController());
// //   }
// // }

// // class ContactSupportBinding extends Bindings {
// //   @override
// //   void dependencies() {
// //     Get.lazyPut<ContactSupportController>(() => ContactSupportController());
// //   }
// // }

// // class DeliveryAddressBinding extends Bindings {
// //   @override
// //   void dependencies() {
// //     Get.lazyPut<CustomerAddDeliveryAddressController>(() => CustomerAddDeliveryAddressController());
// //   }
// // }

// // class OrderDetailsBinding extends Bindings {
// //   @override
// //   void dependencies() {
// //     final args = Get.arguments;

// //     if (args is CustomerOrderDetailsArg_Model) {
// //       Get.lazyPut<CustomerOrderDetailsController>(() => CustomerOrderDetailsController(args));
// //     } else if (args is SupplierOrderDetailsArg_Model) {
// //       Get.lazyPut<SupplierOrderDetailsController>(() => SupplierOrderDetailsController(args));
// //     }
// //     Get.lazyPut<DeliveryDetailsController>(() => DeliveryDetailsController());
// //   }
// // }

// // class NotificationBinding extends Bindings {
// //   @override
// //   void dependencies() {
// //     Get.lazyPut<NotificationController>(() => NotificationController());
// //   }
// // }

// // class GoogleMapBinding extends Bindings {
// //   @override
// //   void dependencies() {
// //     Get.lazyPut<GoogleMapController>(() => GoogleMapController());
// //   }
// // }

// // class TermsAndConditionsBinding extends Bindings {
// //   @override
// //   void dependencies() {
// //     Get.lazyPut<TermsAndConditionsController>(() => TermsAndConditionsController());
// //   }
// // }

// // class ReviewAndRatingBinding extends Bindings {
// //   @override
// //   void dependencies() {
// //     final supplierId = Get.arguments as String;
// //     Get.lazyPut<ReviewAndRatingController>(() => ReviewAndRatingController(supplierId));
// //   }
// // }

// // class FindSuppliesBinding extends Bindings {
// //   @override
// //   void dependencies() {
// //     Get.lazyPut<FindSuppliesController>(() => FindSuppliesController());
// //   }
// // }
