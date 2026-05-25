import 'package:easy_countdown_timer/easy_countdown_timer_widget.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

import '../../../../app/helper_widgets_export.dart';
import '../../../../core/helpers/widgets_helper.dart';
import '../controller/verify_otp_controller.dart';

class VerifyOtpScreen extends StatelessWidget {
  const VerifyOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final otpc = Get.find<VerifyOtpController>();

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CommonAppBarContent(title: "", hasBackNavArrow: false),
        backgroundColor: bgClr,
        resizeToAvoidBottomInset: true,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Welcome tetxt
                Text(
                  Strings.verification.capEachWord(),
                  style: TxtStyle.outfit(fs: 16, w: 600, color: c.primary),
                ),
                Gap(itemGap),

                Text(
                  Strings.enterSixDigitCodeEmail.capEachWord(),
                  style: TxtStyle.outfit(color: c.primary, w: 600),
                ),

                Gap(itemGap * 5),

                Pinput(
                  animationCurve: Curves.bounceIn,
                  autofocus: true,
                  controller: otpc.otpCntrler,
                  focusNode: otpc.otpFocusNode,

                  errorTextStyle: TxtStyle.outfit(w: 600),
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
                  return filledBtnWTxt(
                    btnTxt: Strings.continueTxt,
                    isLoading: otpc.isLoading,
                    onTap: otpc.onTapVerify,
                  );
                }),
                Gap(itemGap * 3),

                Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          otpc.showTimer
                              ? Strings
                                    .youCanReqOTP // While timer running
                              : Strings.youHaventGotOTP,
                          style: TxtStyle.outfit(w: 500, color: c.secondary),
                        ),
                      ),
                      otpc.showTimer
                          ? DefaultTextStyle(
                              style: TxtStyle.outfitSemiB(
                                fs: 14,
                                w: 600,
                                color: c.primary,
                              ),
                              child: EasyCountdownTimerWidget(
                                key: ValueKey(DateTime.now()),
                                duration: Duration(seconds: 5),
                                digitTextStyle: TxtStyle.outfit(
                                  fs: 14,
                                  w: 600,
                                  color: c.primary,
                                ),
                                separatorTextStyle: TxtStyle.outfit(
                                  fs: 14,
                                  color: c.primary,
                                ),
                                onFinished: () {
                                  log('Countdown Complete!');
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
                                  style: TxtStyle.outfit(
                                    fs: 14,
                                    color: c.primary,
                                  ),
                                ),
                              ),
                            )
                          : CusGestureDetector(
                              onTap: otpc.onTapResendOtp,
                              child: otpc.isResendLoading
                                  ? LoadingPrimary()
                                  : Text(
                                      Strings.resendOTP,
                                      style: TxtStyle.outfit(
                                        w: 600,
                                        color: c.primary,
                                      ),
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
