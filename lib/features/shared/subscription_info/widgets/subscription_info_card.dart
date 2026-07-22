import '../../../../app/helper_widgets_export.dart';

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
