import 'package:mama_app/core/components/ui/media/safe_asset_image.dart/safe_image_asset.dart';

import '../../../../../../app/helper_widgets_export.dart';
import '../../onboard2/onboard2_feature_card.dart';
import '../models/expert_session_model.dart';

class OnboardExpertSessionCard extends StatelessWidget {
  const OnboardExpertSessionCard({super.key, required this.session});

  final ExpertSessionModelMock session;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110.h, // adjust as needed
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F4F1),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        children: [
          Container(
            width: 80.w,
            color: Colors.blue,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: SizedBox.expand(
                child: SafeAssetImage(
                  assetPath: session.image,

                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          Gap(12.w),

          Expanded(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(session.title, style: poppinsSemiBold18(), maxLines: 2),

                Text(session.doctor, style: poppinsMedium16()),

                Text(session.specialty, style: poppinsMedium16()),

                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14.sp,
                      color: c.primary,
                    ),
                    Gap(6.w),
                    Text(
                      "${session.date} • ${session.time}",
                      style: poppinsMedium16(color: c.foregroundPrimary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
