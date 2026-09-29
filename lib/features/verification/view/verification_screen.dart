import '../../../app/helper_widgets_export.dart';
import '../../../core/themes/color/colors.dart';
import '../controller/verification_controller.dart';
import '../model/verification_model.dart';

class VerificationScreen extends GetView<VerificationController> {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // mandatory gate
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            Obx(
              () => controller.isSignoutLoading.value
                  ? LoadingPrimary()
                  : TextButton(
                      onPressed: controller.signOut,
                      child: Text('Sign out', style: TxtStyle.btnTxt),
                    ),
            ),

            Gap(10.w),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Obx(() => _buildBody(controller)),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(VerificationController c) {
    // 1. Waiting on Persona to finish reviewing
    if (c.isPolling.value) {
      return const _StateView(
        icon: Icons.hourglass_top,
        title: 'Reviewing your ID',
        message:
            'This usually takes a few seconds. Please keep this screen open.',
        loading: true,
      );
    }

    // 2. Polling gave up after 2 minutes
    if (c.pollTimedOut.value) {
      return _StateView(
        icon: Icons.schedule,
        title: 'Still reviewing',
        message:
            'This is taking longer than usual. You can check again or come back later.',
        buttonText: 'Check again',
        onTap: c.checkAgain,
      );
    }

    switch (c.status.value) {
      case VerificationStatus.needsReview:
        return _StateView(
          icon: Icons.manage_search,
          title: 'Under review',
          message:
              'Our team is manually reviewing your submission. We will let you know once it is done.',
          buttonText: 'Check status',
          onTap: c.checkAgain,
        );
      case VerificationStatus.declined:
        return _StateView(
          icon: Icons.cancel_outlined,
          title: 'Verification failed',
          message:
              'We could not verify your identity. Please try again with a clear photo of your ID.',
          buttonText: 'Try again',
          loading: c.isStarting.value,
          onTap: c.onTapVerify,
        );
      case VerificationStatus.expired:
        return _StateView(
          icon: Icons.timer_off_outlined,
          title: 'Session expired',
          message: 'Your verification session expired. Please start again.',
          buttonText: 'Start again',
          loading: c.isStarting.value,
          onTap: c.onTapVerify,
        );
      case VerificationStatus.pending:
        return _StateView(
          icon: Icons.verified_user_outlined,
          title: 'Finish verifying',
          message:
              'You started verification but did not finish. Continue where you left off.',
          buttonText: 'Continue',
          loading: c.isStarting.value,
          onTap: c.onTapVerify,
        );
      case VerificationStatus.approved:
        return const _StateView(
          icon: Icons.check_circle_outline,
          title: 'Verified',
          message: 'Taking you in...',
          loading: true,
        );
      case VerificationStatus.processing:
      case VerificationStatus.notStarted:
        return _StateView(
          icon: Icons.verified_user_outlined,
          title: 'Verify your identity',
          message:
              'To keep the community safe, we need to confirm your identity with a photo ID and a selfie.',
          buttonText: 'Verify Identity',
          loading: c.isStarting.value,
          onTap: c.onTapVerify,
        );
    }
  }
}

class _StateView extends StatelessWidget {
  const _StateView({
    required this.icon,
    required this.title,
    required this.message,
    this.buttonText,
    this.onTap,
    this.loading = false,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          decoration: BoxDecoration(
            color: AppPalette.cream50,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppPalette.brown900_10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                height: 88,
                width: 88,
                decoration: BoxDecoration(
                  color: AppPalette.brown700_10,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 42, color: AppPalette.brown900),
              ),

              const SizedBox(height: 24),

              // Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: AppPalette.textPrimary,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 12),

              // Message
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppPalette.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),

              if (buttonText != null) ...[
                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: loading ? null : onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPalette.brown900,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppPalette.brown900.withValues(
                        alpha: 0.55,
                      ),
                      disabledForegroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: loading
                          ? const SizedBox(
                              key: ValueKey('loading'),
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              buttonText!,
                              key: const ValueKey('text'),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ] else if (loading) ...[
                const SizedBox(height: 28),

                const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppPalette.brown900,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
