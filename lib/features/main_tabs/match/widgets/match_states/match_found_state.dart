import 'package:flutter/foundation.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../../controller/match_controller.dart';
import '../../modules/upgrade_now_module.dart';
import '../match_user_details.dart';

class MatchFoundState extends StatelessWidget {
  const MatchFoundState({super.key, required this.mc});

  final MatchController mc;

  @override
  Widget build(BuildContext context) {
    // currentMatch uses _currentMatchIndex — advances locally on pass
    final user = mc.currentMatch;
    if (user == null) return const SizedBox.shrink();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (kDebugMode) Text(mc.fetchedMatches.first.email ?? ''),
        MatchUserDetails(
          resolveAddress: (user) => mc.resolveAddress(
            user,
          ), // ← passed so MatchUserDetails can call mc.resolveAddress()
          user: user,
          isPassLoading: mc.isPassLoading,
          isWaveLoading: mc.isWaveLoading,
          isSeeMore: mc.isSeeMore,
          onTapSeeMore: mc.toggleSeeMore,
          onTapAction: (hasWaved) async => await mc.onAction(
            hasWaved,
            receiverId: mc.fetchedMatches.first.id ?? '',
          ),
        ),

        Gap(itemGap * 2),
        UpgradeNowModule(onTapUgradeNow: mc.onTapUpgradeNow),
        Gap(itemGap * 3),
      ],
    );
  }
}
