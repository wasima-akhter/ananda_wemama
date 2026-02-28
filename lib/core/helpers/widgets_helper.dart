import 'package:pinput/pinput.dart';

import '../../app/helper_widgets_export.dart';

PinTheme? defaultPinTheme = PinTheme(
  width: 56.w,
  height: 58.h,
  textStyle: TxtStyle.urbanist(fs: 20, w: 600, color: c.primary),
  decoration: BoxDecoration(
    color: c.inputBackground,
    borderRadius: 30.brdrRad,

    border: Border.all(color: c.inputBorder),
  ),
);

PinTheme? focusedPinTheme = defaultPinTheme?.copyWith(
  decoration: BoxDecoration(
    color: c.inputBackground,
    borderRadius: 30.brdrRad,
    border: Border.all(color: c.primary, width: 2),
    boxShadow: [
      BoxShadow(color: c.primary.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 3)),
    ],
  ),
);

PinTheme? followingPinTheme = defaultPinTheme?.copyWith(
  decoration: BoxDecoration(
    color: c.inputBackground,
    borderRadius: 30.brdrRad,
    border: Border.all(color: c.inputBorder),
  ),
);
