import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

import '../../../services/constants.dart';
import '../../../services/theme.dart';
import '../../base/custom_button.dart';
import '../../base/custom_image.dart';
import '../../base/custom_toast.dart' hide ToastType;

class OTPVerification extends StatefulWidget {
  final String phone;
  const OTPVerification({super.key, required this.phone});

  @override
  State<OTPVerification> createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  final TextEditingController _pinController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Get.find<AuthController>().generatedOtp(phone: widget.phone);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Center(child: CustomImage(path: 'Assets.imagesMessage')),
          ),
          Text(
            "Verify Your Code",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.black,
                ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "We have sent the verification to +91 9876543210",
            style: Theme.of(context).textTheme.titleSmall!.copyWith(),
          ),
          Text(
            "Change Phone Number?",
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: primaryColor),
          ),
          const SizedBox(
            height: 20,
          ),
          Pinput(
            inputFormatters: [
              LengthLimitingTextInputFormatter(6),
              FilteringTextInputFormatter.digitsOnly
            ],
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            controller: _pinController,
            length: 6,
            defaultPinTheme: PinTheme(
              width: 45,
              height: 55,
              textStyle: TextStyle(
                fontSize: 20,
                color: Colors.black.withOpacity(0.3),
              ),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.black.withOpacity(0.3),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            focusedPinTheme: PinTheme(
              width: 45,
              height: 55,
              textStyle: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            submittedPinTheme: PinTheme(
              width: 45,
              height: 55,
              textStyle: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (value) {},
          ),
          const SizedBox(height: 60),
          const Text("Didn’t you received any code?"),
          const Text("Resend a new code.",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalPadding, vertical: 15),
          child: SizedBox(
            height: 50,
            child: CustomButton(
              radius: 6,
              elevation: 0,
              color: Colors.black,
              onTap: () {
                if (_pinController.text.length != 6) {
                  // showCustomToast(
                  //     msg: 'Invalid Otp', toastType: );
                  return;
                }
                // Get.find<AuthController>().verifyOtp(phone: widget.phone, otp: _pinController.text).then((value) {
                //   if (value.isSuccess) {
                //     if (value.data['new']) {
                //       Navigator.pushAndRemoveUntil(context, getCustomRoute(child: const SignUpScreen()), (route) => false);
                //     } else {
                //       // Todo: Get Profile...
                //       Navigator.pushAndRemoveUntil(context, getCustomRoute(child: const DashboardScreen()), (route) => false);
                //     }
                //   }
                // });
              },
              child: Text(
                'Next',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 14,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
