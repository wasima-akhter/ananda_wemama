import 'package:we_mama/core/helpers/string_helper.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../models/ui/common_data_models.dart';

class IdentityDetailComponent extends StatelessWidget {
  final String? supplierId;
  final IdentityCardDataModel? identityCardData;
  final bool? isCircle; // new: circle mode

  final bool? hasLocationRow;
  final bool? hasRatingRow;
  final Widget? rightBtnWidet;
  const IdentityDetailComponent({
    super.key,
    this.identityCardData,
    this.hasLocationRow,
    this.rightBtnWidet,
    this.isCircle,
    this.hasRatingRow,
    this.supplierId,
  });

  @override
  Widget build(BuildContext context) {
    String title = '';
    String phone = '';
    String email = '';
    String? address = '';
    String? imageUrl = '';
    String? avgRating = '';
    String? totalRating = '';
    if (identityCardData != null) {
      title = (identityCardData!.title).capEachWord();
      phone = identityCardData!.phone;
      email = identityCardData!.email;
      address = identityCardData!.address ?? '';
      imageUrl = identityCardData!.imageUrl;
      avgRating = identityCardData!.avgRating;
      totalRating = identityCardData!.totalRating;
      imageUrl = identityCardData!.imageUrl;
    }
    return ContainerBordered(
      vp: 20.h,
      hp: 8.w,
      boxShadow: boxShadowAllSides,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // image
          Expanded(
            flex: 2,
            child: CircleAvatar(
              radius: 30.r,
              child: NetworkImageWidget(
                imageUrl: imageUrl,
                isCircle: isCircle ?? false,
                isUser: true,
              ),
            ),
          ),
          Gap(12),
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title.isNotEmpty)
                  Column(
                    children: [
                      TextFit(title, style: title_600_mClr_Outfit),
                      Gap(itemGap * 0.5),
                    ],
                  ),
                TextFit(
                  phone,
                  style: TxtStyle.inter(w: 600, fs: 13, color: txtDeepGrey),
                ),
                Gap(itemGap * 0.5),
                TextFit(
                  email,
                  style: TxtStyle.inter(w: 600, fs: 13, color: txtDeepGrey),
                ),

                if (hasRatingRow == true) Gap(itemGap),
                Row(
                  children: [
                    if (hasLocationRow == true)
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            SvgIcon(
                              iconPath: IconsPath.locationBold,
                              height: 16.h,
                              width: 16.w,
                            ),
                            Gap(itemGap * 0.2),
                            Container(
                              constraints: BoxConstraints(
                                maxWidth: 1.sw * 0.13,
                              ),
                              child: TextFit(
                                address,
                                style: TxtStyle.inter(
                                  fs: 11,
                                  color: c.primary,
                                  w: 600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (hasRatingRow == true)
                      Expanded(
                        flex: 3,
                        child: CusGestureDetector(
                          onTap: () {
                            Get.toNamed(
                              RoutePaths.reviewAndRating,
                              arguments: supplierId ?? '',
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                avgRating != null && avgRating.isNotEmpty
                                    ? avgRating
                                    : "0.0",
                                style: TxtStyle.inter(
                                  fs: 11,
                                  color: c.primary,
                                  w: 600,
                                ),
                              ),
                              Gap(itemGap * 0.5),
                              SvgIcon(
                                iconPath: IconsPath.heartHalfFilled,
                                height: 12.h,
                                width: 12.w,
                              ),
                              Gap(itemGap),

                              Expanded(
                                child: TextFit(
                                  "($totalRating Rating)",
                                  style: TxtStyle.inter(
                                    fs: 11,
                                    color: c.primary,
                                    w: 600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),

                if (rightBtnWidet != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [rightBtnWidet ?? SizedBox.shrink()],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
