// lib/core/common_widgets/socket_status_banner.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'socket_service.dart';
import 'socket_status_controller.dart';

class SocketStatusBanner extends StatelessWidget {
  const SocketStatusBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (!Get.isRegistered<SocketStatusController>())
          return const SizedBox.shrink();

        final sc = SocketStatusController.to;

        // ── Connected — hide entirely ─────────────────────────────────────────
        if (sc.isConnected) return const SizedBox.shrink();

        final isReconnecting = sc.isReconnecting;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          width: double.infinity,
          color: isReconnecting
              ? const Color(0xFFF59E0B) // amber
              : const Color(0xFFEF4444), // red
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          child: Row(
            children: [
              // Status dot
              _PulseDot(color: isReconnecting ? Colors.white : Colors.white),
              const SizedBox(width: 8),

              // Message
              Expanded(
                child: Text(
                  isReconnecting
                      ? 'Reconnecting... (attempt ${sc.retryCount.value})'
                      : 'Connection lost. Tap to retry.',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Manual retry button (only on hard failure)
              if (!isReconnecting)
                GestureDetector(
                  onTap: () async {
                    SocketStatusController.to.setReconnecting(1);
                    try {
                      Get.find<SocketService>().connectSocket();
                    } catch (_) {}
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                    child: const Text(
                      'Retry',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Pulsing dot — mimics WhatsApp's live indicator
class _PulseDot extends StatefulWidget {
  final Color color;
  const _PulseDot({required this.color});

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = Tween(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      ),
    );
  }
}
