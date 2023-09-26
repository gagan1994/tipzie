import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:tripzie/auth/authentication.dart';
import 'package:tripzie/auth/google_signIn_button.dart';
import 'package:tripzie/utils/ui_utils.dart';
import 'package:tripzie/widgets/trippit_mainlayout.dart';

import '../../utils/trippit_assets.dart';
import '../../utils/trppit_color.dart';
import '../../widgets/tripzie_button.dart';

class VerifyOTP extends StatefulWidget {
  static const PAGE_NAME = "/verify_otp";
  PhoneNumberDetails phoneDetails;
  VerifyOTP(this.phoneDetails, {Key? key}) : super(key: key);

  @override
  State<VerifyOTP> createState() => _VerrifyOTPState();
}

class _VerrifyOTPState extends State<VerifyOTP> {
  final myController = TextEditingController();
  var time_left_for_resend;
  Timer? _timer;

  String? otp_text;

  OtpFieldController? otpController;

  var lengthOfOTP = 6;

  @override
  void initState() {
    super.initState();
    startTimer();
    otpController = OtpFieldController();
  }

  void startTimer() {
    setState(() {
      time_left_for_resend = 50;
    });
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (time_left_for_resend == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            time_left_for_resend--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TrippitMainLayout(
        Column(
          children: [
            Expanded(
              child: Container(),
              flex: 2,
            ),
            Expanded(
              child: Container(
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Verification',
                      style: TextStyle(fontSize: 40),
                    ),
                    SizedBox(height: 5),
                    Text.rich(
                      TextSpan(
                        text:
                            'Please enter the OTP sent to ', // default text style
                        children: <TextSpan>[
                          TextSpan(
                              text: widget.phoneDetails.phoneNumber,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(
                            text: ' to verify your account',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: OTPTextField(
                        otpFieldStyle: OtpFieldStyle(
                            backgroundColor: otp_background_color,
                            borderColor: Colors.white,
                            enabledBorderColor: Colors.white),
                        length: lengthOfOTP,
                        controller: otpController,
                        fieldWidth: 50,
                        style: const TextStyle(color: text_color),
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        fieldStyle: FieldStyle.box,
                        outlineBorderRadius: 10,
                        onCompleted: (pin) {
                          print("Completed: " + pin);
                        },
                        onChanged: (otp) {
                          otp_text = otp;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              flex: 4,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TripzieButton(
                  button_text: "Verify",
                  onPressed: () async {
                    if (otp_text == null ||
                        otp_text!.isEmpty ||
                        otp_text!.length != lengthOfOTP) {
                      showSnackBar(context, "Please enter valid OTP");
                      return;
                    }
                    var user = await Authentication.verifyOTP(
                        context, widget.phoneDetails.verifyId, otp_text!);
                    print("user: $user");
                    if (user != null) {
                      loginAction(context, user);
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                _get_resend_ui(),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(arrow_left_go_back),
                      const Text(
                        " Change phone number.",
                        style: TextStyle(color: text_color),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    myController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Widget _get_resend_ui() {
    if (time_left_for_resend == 0) {
      return GestureDetector(
        onTap: () {
          showSnackBar(
              context, "OTP Sent to ${widget.phoneDetails.phoneNumber}");
          Authentication.signInWithPhone(
              context,
              widget.phoneDetails.phoneNumber,
              (verificationId, forceResendingToken) => {
                    widget.phoneDetails.verifyId = verificationId,
                    widget.phoneDetails.token = forceResendingToken
                  });
          startTimer();
          otpController!.clear();
        },
        child: const Text(
          "Resend",
          style: TextStyle(color: text_color, fontWeight: FontWeight.bold),
        ),
      );
    }
    return Text.rich(
      TextSpan(
        text: 'Resend: ', // default text style
        children: <TextSpan>[
          TextSpan(
              text: (time_left_for_resend > 9)
                  ? '00:$time_left_for_resend'
                  : '00:0$time_left_for_resend',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class PhoneNumberDetails {
  String phoneNumber;
  String verifyId;
  int? token;
  PhoneNumberDetails(this.phoneNumber, this.verifyId, this.token);
  @override
  String toString() {
    return "{phoneNumber: $phoneNumber, verifyId: $verifyId, token: $token,}";
  }
}
