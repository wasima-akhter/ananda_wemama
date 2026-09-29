import 'package:easy_countdown_timer/easy_countdown_timer_widget.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:we_mama/features/auth/core/auth_button_templates.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/helpers/widgets_helper.dart';
import '../../../entry/onboard/modules/core/onboard_logo_header_row.dart';
import '../../core/auth_scaffold.dart';
import '../controller/verify_otp_controller.dart';

class VerifyOtpScreen extends StatelessWidget {
  const VerifyOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final otpc = Get.find<VerifyOtpController>();

    return SafeArea(
      top: false,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) =>
            didPop ? null : Get.offNamed(RoutePaths.signin),
        child: Scaffold(
          appBar: getOnboardAppBar(),
          backgroundColor: bgClrNew,
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                OnboardLogoHeaderRow(
                  onTap: () => Get.offNamed(RoutePaths.signin),
                ),

                Gap(20.h),
                // Welcome tetxt
                Text(
                  Strings.verification.capEachWord(),
                  style: TxtStyle.dmSerifDisplayRegular(),
                ),

                Gap(itemGap),

                Text(
                  Strings.enterSixDigitCodeEmail.capEachWord(),
                  textAlign: TextAlign.center,
                  style: TxtStyle.poppinsSemiBold12Center(),
                ),

                Gap(itemGap * 5),

                Pinput(
                  animationCurve: Curves.bounceIn,
                  autofocus: true,
                  controller: otpc.otpCntrler,
                  focusNode: otpc.otpFocusNode,

                  cursor: Container(
                    width: 1, // thinner cursor
                    height: 22.h,
                    color: c.primary,
                  ),

                  errorTextStyle: TxtStyle.poppinsSemiB(w: 600),
                  errorBuilder: (errorText, pin) {
                    return const Text("Invalid OTP");
                  },
                  keyboardType: TextInputType.number,
                  // (validator runs after typing, formatter blocks while typing).
                  // 👇 THIS blocks letters, symbols, spaces — only 0-9 allowed
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  followingPinTheme: followingPinTheme,
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return "Enter complete OTP";
                    }
                    return null;
                  },

                  onSubmitted: (value) {},
                  onCompleted: (value) {},

                  length: 6,
                ),
                Gap(itemGap * 3),

                Obx(() {
                  return AuthButton(
                    isLoading: otpc.isLoading,
                    onTap: otpc.onTapVerify,
                  );
                }),
                Gap(itemGap * 3),

                Obx(() {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        otpc.showTimer
                            ? Strings
                                  .youCanReqOTP // While timer running
                            : Strings.youHaventGotOTP,
                        style: TxtStyle.poppinsSemiB(color: c.secondary),
                      ),
                      Gap(itemGap * 2),
                      otpc.showTimer
                          ? DefaultTextStyle(
                              style: TxtStyle.poppinsSemiB(color: c.primary),
                              child: EasyCountdownTimerWidget(
                                key: ValueKey(DateTime.now()),
                                duration: Duration(seconds: 5),
                                digitTextStyle: TxtStyle.poppinsSemiB(
                                  color: c.primary,
                                ),
                                separatorTextStyle: TxtStyle.poppinsSemiB(
                                  color: c.primary,
                                ),
                                onFinished: () {
                                  print('Countdown Complete!');
                                  otpc.showTimer_.value = false; // hide timer
                                  otpc.isOtpResent_.value =
                                      false; // switch text back to "youHaventGotOTP"
                                },

                                showDays: false,
                                showHours: false,
                                showMinutes: true,
                                showSeconds: true,
                                separatedWidget: Text(
                                  " : ",
                                  style: TxtStyle.poppinsSemiB(
                                    color: c.primary,
                                  ),
                                ),
                              ),
                            )
                          : CusGestureDetector(
                              onTap: otpc.onTapResendOtp,
                              child: otpc.isResendLoading
                                  ? LoadingPrimary()
                                  : Stack(
                                      children: [
                                        Text(
                                          Strings.resendOTP,
                                          style: TxtStyle.poppinsSemiB(
                                            w: 600,
                                            fs: 12,
                                            color: c.primary,
                                            h: 1.02,
                                          ),
                                        ),
                                        Positioned(
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            height: 1,
                                            color: c.primary.withValues(
                                              alpha: 0.6,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                    ],
                  );
                }),
              ],
            ).getcm,
          ),
        ),
      ),
    );
  }
}
