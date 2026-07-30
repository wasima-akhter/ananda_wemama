import '../../../app/helper_widgets_export.dart';
import '../../../core/components/ui/inputs/cus_pass_type_text_form_field.dart';
import '../../../core/state_screens/success/screen/success_screen.dart';
import '../controller/payment_controller.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double itemGap = 1.sh * 0.01;

    final pc = Get.find<PaymentController>();

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: bgClr,
        appBar: CommonAppBarContent(title: Strings.payment),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Obx(() {
              final showAPmentFields = pc.showAPmentFields.value;

              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 500, // keeps UI nice on tablets/web
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!showAPmentFields)
                        CusGestureDetector(
                          onTap: pc.payStackBtnOnTap,
                          child: ContainerBordered(
                            hasBrdr: true,
                            vp: 22,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgIcon(
                                  iconPath: IconsPath.currency,
                                  height: 24,
                                ),
                                Text(
                                  Strings.paystack,
                                  style: TxtStyle.inter(
                                    fs: 11,
                                    w: 600,
                                    color: c.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      if (showAPmentFields)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Strings.paymentViaCard,
                              style: TxtStyle.inter(w: 600),
                            ),
                            Gap(itemGap * 2),

                            Text(
                              Strings.yourDetailsAreSafe,
                              style: TxtStyle.inter(fs: 11, w: 600),
                            ),

                            Gap(itemGap * 4),

                            /// Card Number
                            Text(
                              Strings.cardNumber,
                              style: TxtStyle.inter(fs: 11, w: 600),
                            ),
                            Gap(itemGap),
                            CusPassTypeTextFormField(
                              controller: TextEditingController(),
                              hintText: "4084 4084 4084 4084",
                              hintW: 600,
                            ),

                            Gap(itemGap * 3),

                            /// Expire + CVV Row
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Strings.expire,
                                        style: TxtStyle.inter(fs: 11, w: 600),
                                      ),
                                      Gap(itemGap),
                                      CusPassTypeTextFormField(
                                        controller: TextEditingController(),
                                        hintText: "MM/YY",
                                        hintW: 600,
                                      ),
                                    ],
                                  ),
                                ),
                                Gap(16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Strings.cvv.capEachWord(),
                                        style: TxtStyle.inter(fs: 11, w: 600),
                                      ),
                                      Gap(itemGap),
                                      CusPassTypeTextFormField(
                                        controller: TextEditingController(),
                                        hintText: "123",
                                        hintW: 600,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            Gap(itemGap * 3),

                            /// Button
                            CustomBtnWTxt(
                              btnColor: grey200,
                              style: TxtStyle.interSemiB(
                                fs: 18,
                                w: 600,
                                color: c.textSecondary,
                              ),
                              onTap: () {
                                Get.offAllNamed(
                                  RoutePaths.success,
                                  arguments: SuccessViewDataModel(
                                    title: Strings.paymentSuccessful,
                                    subtitle: Strings.aboutPaymentInfoSent,
                                    btnTxt: Strings.okay,
                                    btnOnTap: () {
                                      // redirect to the creating order
                                      //
                                      // change the draft ctl er payment info.

                                      // Get.find<CustomerOrderDraftController>().setPaymentSuccess(
                                      //   reference: "reference_from_the_payment_interface_of_card",
                                      // );
                                      // Get.toNamed(RoutePaths.createOrder);
                                    },
                                    iconClr: c.primary,
                                  ),
                                );
                              },
                              btnTxt: "${Strings.pay} 14,990.30",
                              isLoading: false,
                            ),
                          ],
                        ),
                    ],
                  ).getcm,
                ),
              );
            });
          },
        ),
      ),
    );
  }
}
