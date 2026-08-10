import 'package:we_mama/gen/assets.gen.dart';

import '../../../../../app/helper_widgets_export.dart';
import '../../modules/onboard4/cards/onboard_expert_session_card.dart';
import '../../modules/onboard4/models/expert_session_model.dart';

class OnboardExpertGuidanceSection extends StatelessWidget {
  const OnboardExpertGuidanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final sessions = [
      ExpertSessionModelMock(
        image: Assets.images.sessionMockUser1.path,
        title: "Postpartum Recovery: What nobody told you",
        doctor: "Dr. Roma Akachukwu",
        specialty: "Women's Health Specialist",
        date: "August 30",
        time: "04:00 PM",
      ),
      ExpertSessionModelMock(
        image: Assets.images.sessionMockUser2.path,
        title: "Why Won’t My Baby Sleep?",
        doctor: "Dr. Oluwunmi Okeyale",
        specialty: "Sleep Consultant",
        date: "September 9",
        time: "06:00 PM",
      ),
      ExpertSessionModelMock(
        image: Assets.images.sessionMockUser3.path,
        title: "Mental Wellbeing",
        doctor: "Dr. Serena Oriarewo",
        specialty: "Mental Health Specialist",
        date: "September 25",
        time: "05:00 PM",
      ),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Upcoming Sessions",
            style: TxtStyle.poppinsSemiBold15().copyWith(
              fontSize: ScreenSizeX.isTablet
                  ? 12.sp
                  : ScreenSize.isSmallWidth
                  ? 14.sp
                  : 16.sp,
            ),
          ),
        ),

        Gap(ScreenSize.isSmallWidth ? 10.h : 14.h),

        Column(
          children: sessions
              .map(
                (session) => Padding(
                  padding: EdgeInsets.only(
                    bottom: ScreenSize.isSmallWidth ? 4.h : 8.h,
                  ),
                  child:
                      //Container(height: 100, color: Colors.amber),
                      OnboardExpertSessionCard(session: session),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
