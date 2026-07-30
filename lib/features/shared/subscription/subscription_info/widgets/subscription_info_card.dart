import 'package:we_mama/features/shared/subscription/subscription_info/controller/subscription_info_controller.dart';

import '../../../../../app/helper_widgets_export.dart';

class CurrentSubscriptionCard extends StatelessWidget {
  final String planName;
  final String price;
  final String expireDate;
  final String? nextBillingDate;
  final bool willRenew;
  final VoidCallback onManageBilling;
  final VoidCallback onCancel;
  final VoidCallback onViewReceipt;
  final TextEditingController promoCodeTextController;

  const CurrentSubscriptionCard({
    super.key,
    required this.planName,
    required this.price,
    required this.expireDate,
    this.nextBillingDate,
    required this.willRenew,
    required this.onManageBilling,
    required this.onCancel,
    required this.onViewReceipt,
    required this.promoCodeTextController,
  });

  @override
  Widget build(BuildContext context) {
    final billingDate = willRenew
        ? (nextBillingDate ?? expireDate)
        : expireDate;

    return Container(
      decoration: BoxDecoration(
        color: c.buttonText,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 12),
      child: Column(
        children: [
          _tile(
            title: willRenew ? 'Renew Date' : 'Expires On',
            trailing: billingDate,
          ),

          _divider(),

          _tile(title: 'Plan', trailing: planName),

          _divider(),

          _tile(title: 'Amount', trailing: price),

          _divider(),

          _divider(),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Have a promo code?",
                  style: TxtStyle.poppinsSemiB(
                    fs: 12,
                    color: const Color(0xff3D2B1F),
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: CusNameTypeTextFormField(
                        rad: 12,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.w,
                        ),
                        controller: promoCodeTextController,
                        hintText: "Enter promo code",
                        isDense: true,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Obx(
                      () => CustomBtnWTxt(
                        rad: 12,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.w,
                        ),
                        isSmall: true,
                        isLoading:
                            SubscriptionInfoController.to.flowLoading.value,
                        onTap: () async {
                          await SubscriptionInfoController.to.applyPromoCode();
                        },
                        btnTxt: "Apply",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _divider(),

          InkWell(
            onTap: onManageBilling,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Payment Method',
                      style: TxtStyle.poppinsSemiB(
                        fs: 12,
                        color: Color(0xff3D2B1F),
                      ),
                    ),
                  ),
                  Text(
                    willRenew ? 'Manage' : 'Not Available',
                    style: TxtStyle.poppinsSemiB(
                      fs: 12,
                      color: Color(0xff3D2B1F),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.chevron_right, size: 16.sp),
                ],
              ),
            ),
          ),

          _divider(),

          InkWell(
            onTap: onViewReceipt,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Billing History',
                      style: TxtStyle.poppinsSemiB(
                        fs: 12,
                        color: Color(0xff3D2B1F),
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right, size: 16.sp),
                ],
              ),
            ),
          ),
          Gap(10),

          const Divider(height: 1).mHV(12, 0),

          InkWell(
            onTap: onCancel,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(18),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Cancel Subscription',

                  style: TxtStyle.poppinsSemiB(fs: 12, color: c.error),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      color: Colors.grey.shade200,
      indent: 20,
      endIndent: 20,
    );
  }

  Widget _tile({required String title, required String trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: TxtStyle.poppinsSemiB(fs: 12, color: Color(0xff3D2B1F)),
            ),
          ),
          Expanded(
            child: Text(
              trailing,
              style: TxtStyle.poppinsSemiB(
                fs: 12,
                w: 600,
                color: Color(0xff3D2B1F),
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
