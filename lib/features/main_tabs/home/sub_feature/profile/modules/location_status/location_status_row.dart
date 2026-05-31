import '../../../../../../../app/helper_widgets_export.dart';
import 'disable_location_button.dart';
import 'enable_location_button.dart';
import 'location_status_icon.dart';

class LocationStatusRow extends StatelessWidget {
  final bool isActive;

  const LocationStatusRow({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        LocationStatusIcon(isActive: isActive),

        Gap(4.w),

        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text(
                isActive ? "You are active now" : Strings.youAreInactiveNow,

                style: TxtStyle.interSemiB(
                  fs: 13,
                  w: 600,
                  color: isActive ? c.primary : c.primary.withOpacity(0.5),
                ),
              ),

              isActive
                  ? const DisableLocationButton()
                  : const EnableLocationButton(),
            ],
          ),
        ),
      ],
    );
  }
}
