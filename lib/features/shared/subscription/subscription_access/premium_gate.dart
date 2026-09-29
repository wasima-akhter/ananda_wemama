import '../../../../app/helper_widgets_export.dart';
import 'premium_access_service.dart';

class PremiumGate extends StatefulWidget {
  final Widget child;
  final WidgetBuilder? lockedBuilder;
  final bool waitForReady;
  final bool useIOSFallback; // ← New parameter

  const PremiumGate({
    super.key,
    required this.child,
    this.lockedBuilder,
    this.waitForReady = true,
    this.useIOSFallback = true, // ← Default: enabled
  });

  @override
  State<PremiumGate> createState() => _PremiumGateState();
}

class _PremiumGateState extends State<PremiumGate> {
  late final RxBool _verifyingStatus = false.obs;

  @override
  void initState() {
    super.initState();

    // ✅ On first build, trigger iOS fallback if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _attemptIOSVerification();
    });
  }

  Future<void> _attemptIOSVerification() async {
    if (!widget.useIOSFallback) return;

    final access = PremiumAccessService.to;
    if (access.isPremiumUser.value || !access.isReady.value) return;

    if (GetPlatform.isIOS) {
      _verifyingStatus.value = true;

      try {
        // ✅ Add timeout to prevent infinite wait
        await access.getPremiumStatusWithFallback().timeout(
          const Duration(seconds: 3),
          onTimeout: () {
            print('⚠️  [PremiumGate] iOS verification timeout');
            return false;
          },
        );
      } finally {
        _verifyingStatus.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final access = PremiumAccessService.to;

    return Obx(() {
      // ✅ State 1: Waiting for premium service to be ready
      if (widget.waitForReady && !access.isReady.value) {
        print('⏳ [PremiumGate] Service not ready');
        return const SizedBox.shrink();
      }

      // ✅ State 2: Verifying premium status on iOS (fallback)
      if (_verifyingStatus.value) {
        print('🔄 [PremiumGate] Verifying iOS status...');
        // Optionally show a loading indicator or just hide
        return const SizedBox.shrink();
      }

      // ✅ State 3: Premium user → show child
      if (access.isPremiumUser.value) {
        print('✅ [PremiumGate] User is premium → showing child');
        return widget.child;
      }

      // ❌ State 4: Not premium → show locked UI or hide
      print('🔒 [PremiumGate] User not premium → showing locked');
      return widget.lockedBuilder?.call(context) ?? const SizedBox.shrink();
    });
  }
}

class PremiumLock extends StatefulWidget {
  const PremiumLock({
    super.key,
    required this.child,
    this.disabledOpacity = .45,
    this.useIOSFallback = true,
  });

  final Widget child;
  final double disabledOpacity;
  final bool useIOSFallback;

  @override
  State<PremiumLock> createState() => _PremiumLockState();
}

class _PremiumLockState extends State<PremiumLock> {
  @override
  void initState() {
    super.initState();

    // ✅ Trigger iOS verification on mount
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _attemptIOSVerification();
    });
  }

  Future<void> _attemptIOSVerification() async {
    if (!widget.useIOSFallback) return;

    final access = PremiumAccessService.to;

    // Already premium or not ready → skip
    if (access.isPremiumUser.value || !access.isReady.value) return;

    // ✅ On iOS, double-check
    if (GetPlatform.isIOS) {
      await access.getPremiumStatusWithFallback();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isPremium = PremiumAccessService.to.isPremiumUser.value;

      return IgnorePointer(
        ignoring: !isPremium,
        child: Opacity(
          opacity: isPremium ? 1 : widget.disabledOpacity,
          child: widget.child,
        ),
      );
    });
  }
}
