import '../../../../app/helper_widgets_export.dart';

/*
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
*/
class CurrentSubscriptionCard extends StatelessWidget {
  final String planName;
  final String price;
  final String expireDate;
  final String? nextBillingDate;
  final bool willRenew;
  final VoidCallback onManageBilling;
  final VoidCallback onCancel;
  final VoidCallback onViewReceipt;

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
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.buttonText,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                planName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _StatusChip(willRenew: willRenew),
            ],
          ),
          if (price.isNotEmpty) ...[
            Gap(6),
            Text(
              price,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
          Gap(12),
          _infoRow(
            willRenew ? 'Next billing date' : 'Expires on',
            nextBillingDate ?? expireDate,
          ),
          Gap(16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onManageBilling,
                  child: const Text('Manage Billing'),
                ),
              ),
              Gap(10),
              Expanded(
                child: OutlinedButton(
                  onPressed: onCancel,
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
          Gap(10),
          TextButton(
            onPressed: onViewReceipt,
            child: const Text('View Billing History'),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      Text(
        value,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    ],
  );
}

class _StatusChip extends StatelessWidget {
  final bool willRenew;
  const _StatusChip({required this.willRenew});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: willRenew
            ? Colors.green.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        willRenew ? 'Active' : 'Cancelling',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: willRenew ? Colors.green : Colors.orange,
        ),
      ),
    );
  }
}
