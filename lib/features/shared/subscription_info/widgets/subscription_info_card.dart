import '../../../../app/helper_widgets_export.dart';

class CurrentSubscriptionCard extends StatelessWidget {
  final String planName;
  final String price;
  final String expireDate;
  final String nextBillingDate;
  final VoidCallback onManageBilling;
  final VoidCallback onViewReceipt;

  const CurrentSubscriptionCard({
    super.key,
    required this.planName,
    required this.price,
    required this.expireDate,
    required this.nextBillingDate,
    required this.onManageBilling,
    required this.onViewReceipt,
  });

  @override
  Widget build(BuildContext context) {
    return ContainerBordered(
      contClr: c.cardPrimary,
      brdrClr: c.inputBorder,
      hasBrdr: true,
      rad: 16,
      hp: 18,
      vp: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// CURRENT PLAN BADGE
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ContainerBordered(
                contClr: c.primary,
                rad: 20,
                hp: 16,
                vp: 6,
                child: Text(
                  "Current Plan",
                  style: TxtStyle.outfit(fs: 13, w: 600, color: c.scaffoldBackground),
                ),
              ),
            ],
          ),

          Gap(14),

          /// PLAN TITLE
          Text(planName, style: TxtStyle.outfit(fs: 18, w: 600, color: c.primary)),

          Gap(6),

          /// PRICE
          Text(price, style: TxtStyle.outfit(fs: 20, w: 700, color: c.primary)),

          Gap(16),

          /// BILLING INFO
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Expire on", style: TxtStyle.outfit(fs: 12, color: c.secondary)),
                  Gap(4),
                  Text(expireDate, style: TxtStyle.outfit(fs: 13, w: 600, color: c.secondary)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Next Billing", style: TxtStyle.outfit(fs: 12, color: c.secondary)),
                  Gap(4),
                  Text(nextBillingDate, style: TxtStyle.outfit(fs: 13, w: 600, color: c.secondary)),
                ],
              ),
            ],
          ),

          Gap(18),

          /// MANAGE BILLING
          CustomBtnWTxt(
            rad: 12,
            btnTxt: "Manage Billing",
            onTap: onManageBilling,
            isLoading: false,
            isSmall: true,

            style: TxtStyle.outfit(w: 500, color: white),
          ),

          Gap(10),

          /// VIEW RECEIPT
          CustomBtnWTxt(
            outlined: true,
            isLoading: false,
            btnTxt: "View Receipt History",
            onTap: onViewReceipt,
            style: TxtStyle.outfit(w: 500),
          ),
        ],
      ),
    );
  }
}
