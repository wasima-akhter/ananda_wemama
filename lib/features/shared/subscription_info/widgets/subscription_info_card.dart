import '../../../../app/helper_widgets_export.dart';

/*
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
    final billingDate = willRenew
        ? (nextBillingDate ?? expireDate)
        : expireDate;

    return Container(
      decoration: BoxDecoration(
        color: c.buttonText,
        borderRadius: BorderRadius.circular(18),
      ),
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

          InkWell(
            onTap: onManageBilling,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Payment Method',
                      style: TxtStyle.outfitSemiB(
                        fs: 15,
                        color: Color(0xff3D2B1F),
                      ),
                    ),
                  ),
                  Text(
                    willRenew ? 'Manage' : 'Not Available',
                    style: TxtStyle.outfitSemiB(
                      fs: 15,
                      color: Color(0xff3D2B1F),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right, size: 20),
                ],
              ),
            ),
          ),

          _divider(),

          InkWell(
            onTap: onViewReceipt,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Billing History',
                      style: TxtStyle.outfitSemiB(
                        fs: 15,
                        color: Color(0xff3D2B1F),
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right, size: 20),
                ],
              ),
            ),
          ),

          const Divider(height: 1),

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

                  style: TxtStyle.outfitSemiB(fs: 15, color: c.error),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TxtStyle.outfitSemiB(fs: 15, color: Color(0xff3D2B1F)),
            ),
          ),
          Text(
            trailing,
            style: TxtStyle.outfitSemiB(
              fs: 15,
              w: 600,
              color: Color(0xff3D2B1F),
            ),
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }
}
