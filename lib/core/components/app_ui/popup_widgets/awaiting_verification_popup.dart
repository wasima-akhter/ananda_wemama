import '../../../../app/helper_widgets_export.dart';

class AwaitingVerificationPopup extends StatelessWidget {
  final VoidCallback onBackToLogin;

  const AwaitingVerificationPopup({super.key, required this.onBackToLogin});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.green, width: 3),
          ),
          child: const Icon(Icons.access_time, color: Colors.green, size: 32),
        ),

        const SizedBox(height: 20),

        const Text(
          'Awaiting For Verification',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 8),

        const Text(
          'authority will be check your documents\nand ensure that you are legit or not',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),

        const SizedBox(height: 24),

        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: onBackToLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB6EFB7),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: (10).brdrRad),
            ),
            child: const Text('Back To Login'),
          ),
        ),
      ],
    );
  }
}
