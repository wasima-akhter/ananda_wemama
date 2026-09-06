import 'package:we_mama/core/components/ui/media/safe_asset_image/safe_image_asset.dart';
import 'package:we_mama/gen/assets.gen.dart';

import '../../../../../../app/helper_widgets_export.dart';
import '../models/expert_session_model.dart';

class OnboardExpertSessionCard extends StatelessWidget {
  const OnboardExpertSessionCard({super.key, required this.session});

  final ExpertSessionModelMock session;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenSizeX.isTablet
          ? 120.h
          : ScreenSize.isSmallWidth
          ? 115.h
          : 110.h, // adjust as needed
      padding: EdgeInsets.all(7.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F4F1),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: newBorderClr),
      ),
      child: Row(
        children: [
          SizedBox(
            width: ScreenSize.isSmallWidth ? 65.w : 75.w,
            // color: Colors.blue,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  session.title,
                  style: TxtStyle.poppinsSemiBold15().copyWith(
                    fontSize: ScreenSizeX.isTablet
                        ? 9.sp
                        : ScreenSize.isSmallWidth
                        ? 12.sp
                        : 13.sp,
                    height: 1.3,
                  ),
                  maxLines: 2,
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.doctor,
                      style: TxtStyle.poppinsMedium13(
                        fs: ScreenSizeX.isTablet ? 8 : 11,
                      ),
                    ),

                    Text(
                      session.specialty,
                      style: TxtStyle.poppinsMedium13(
                        fs: ScreenSizeX.isTablet ? 8 : 11,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    SvgIcon(
                      iconPath: Assets.icons.calenderNew,
                      height: ScreenSize.isSmallWidth ? 16 : 18,
                    ),
                    Gap(6),
                    Text(
                      "${session.date} - ${session.time}",
                      style: TxtStyle.poppinsMedium13(
                        color: c.foregroundPrimary,
                        fs: ScreenSizeX.isTablet ? 8 : 11,
                      ),
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
