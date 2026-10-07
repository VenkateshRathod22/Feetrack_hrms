import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/auth_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/extensions.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/base/custom_image.dart';
import 'package:vlr/views/screens/auth_screens/sign_in_screen.dart';
import 'package:vlr/views/screens/dashboard/dashboard_screen.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: AppConstants.screenPadding,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    Assets.imagesLoginBg,
                  ),
                  fit: BoxFit.cover),
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24.sp),
                      decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(24)),
                      child:
                          GetBuilder<AuthController>(builder: (authController) {
                        return Column(
                          children: [
                            CustomImage(
                              path: Assets.imagesLogo,
                              height: 64.h,
                              fit: BoxFit.cover,
                            ),
                            sizedBoxHeight(height: 16),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40.w),
                              child: Column(
                                children: [
                                  CustomText(
                                    "Create Partner Account",
                                    maxLines: 3,
                                    textAlign: TextAlign.center,
                                    style: Helper(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontSize: 24.sp,
                                        ),
                                  ),
                                  sizedBoxHeight(height: 4),
                                  CustomText(
                                    "Join Feetrack as a Partner and start managing your business with ease.",
                                    maxLines: 3,
                                    textAlign: TextAlign.center,
                                    style: Helper(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            fontSize: 14.sp, color: greyDart2),
                                  ),
                                ],
                              ),
                            ),
                            sizedBoxHeight(height: 32),
                            AppTextFieldWithHeading(
                              headingWidget: CustomText(
                                "Full Name",
                                style: Helper(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      fontSize: 14.sp,
                                      color: blueDark2,
                                    ),
                              ),
                              controller: authController.fullNameController,
                              preFixWidget: Icon(
                                Icons.person_outline_rounded,
                                color: greyDart2,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              hindText: "Enter your Full Name",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please Enter you full name";
                                }
                                return null;
                              },
                            ),
                            sizedBoxHeight(height: 16),
                            AppTextFieldWithHeading(
                              headingWidget: CustomText(
                                "Email",
                                style: Helper(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      fontSize: 14.sp,
                                      color: blueDark2,
                                    ),
                              ),
                              controller: authController.emailController,
                              preFixWidget: Icon(
                                Icons.email_outlined,
                                color: greyDart2,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              hindText: "Enter your email",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please Enter you email";
                                }
                                if (value.isNotEmail) {
                                  return "Please proper email";
                                }
                                return null;
                              },
                            ),
                            sizedBoxHeight(height: 16),
                            AppTextFieldWithHeading(
                              headingWidget: CustomText(
                                "Mobile Number",
                                style: Helper(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      fontSize: 14.sp,
                                      color: blueDark2,
                                    ),
                              ),
                              controller: authController.mobileController,
                              preFixWidget: Icon(
                                Icons.call_outlined,
                                color: greyDart2,
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                              hindText: "98765 43210",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter you mobile number";
                                }
                                if (value.length != 10) {
                                  return "Please proper mobile number";
                                }
                                return null;
                              },
                            ),
                            sizedBoxHeight(height: 16),
                            AppTextFieldWithHeading(
                              headingWidget: CustomText(
                                "Password",
                                style: Helper(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      fontSize: 14.sp,
                                      color: blueDark2,
                                    ),
                              ),
                              obscureText: true,
                              controller: authController.passwordController,
                              preFixWidget: Icon(
                                Icons.lock_outline_rounded,
                                color: greyDart2,
                              ),
                              keyboardType: TextInputType.text,
                              hindText: "Enter your password",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please Enter you password";
                                }
                                if (value.length < 8) {
                                  return "The password field must be at least 8 characters";
                                }
                                if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
                                  return "The password must contain at least one letter.";
                                }

                                if (value !=
                                    authController
                                        .confirmPasswordController.text) {
                                  return "Pleas check a confirm password";
                                }
                                return null;
                              },
                            ),
                            sizedBoxHeight(height: 16),
                            AppTextFieldWithHeading(
                              headingWidget: CustomText(
                                "Confirm Password",
                                style: Helper(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      fontSize: 14.sp,
                                      color: blueDark2,
                                    ),
                              ),
                              obscureText: true,
                              controller:
                                  authController.confirmPasswordController,
                              textInputAction: TextInputAction.done,
                              preFixWidget: Icon(
                                Icons.lock_outline_rounded,
                                color: greyDart2,
                              ),
                              keyboardType: TextInputType.text,
                              hindText: "Enter your confirm password",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter you confirm password";
                                }
                                if (value.length < 8) {
                                  return "The password field must be at least 8 characters";
                                }
                                if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
                                  return "The password must contain at least one letter.";
                                }

                                if (value !=
                                    authController.passwordController.text) {
                                  return "Pleas check a confirm password";
                                }
                                return null;
                              },
                            ),
                            sizedBoxHeight(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                    value: authController.acceptTerms,
                                    onChanged: (value) {
                                      authController.toggleTerms();
                                    }),
                                Expanded(
                                  child: RichText(
                                    maxLines: 3,
                                    text: TextSpan(
                                        text: "I agree to the ",
                                        style: Helper(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              fontSize: 14.sp,
                                              color: greyDart2,
                                            ),
                                        children: [
                                          TextSpan(
                                            text: "Terms & Conditions ",
                                            style: Helper(context)
                                                .textTheme
                                                .labelSmall
                                                ?.copyWith(
                                                  fontSize: 14.sp,
                                                  color: primaryColor,
                                                ),
                                          ),
                                          TextSpan(
                                            text: "and ",
                                            style: Helper(context)
                                                .textTheme
                                                .labelSmall
                                                ?.copyWith(
                                                  fontSize: 14.sp,
                                                  color: greyDart2,
                                                ),
                                          ),
                                          TextSpan(
                                            text: "Privacy Policy",
                                            style: Helper(context)
                                                .textTheme
                                                .labelSmall
                                                ?.copyWith(
                                                  fontSize: 14.sp,
                                                  color: primaryColor,
                                                ),
                                          )
                                        ]),
                                  ),
                                ),
                              ],
                            ),
                            sizedBoxHeight(height: 16),
                            CustomButton(
                              height: 56,
                              radius: 14,
                              isLoading: authController.isLoading,
                              onTap: () {
                                if (!authController.acceptTerms) {
                                  return showToast(
                                      message: "Check Term & Condition");
                                }
                                log("Registration URL: ${AppConstants.baseUrl}${AppConstants.registrationPost}");
                                if (formKey.currentState?.validate() ?? false) {
                                  authController.registerUser().then((value) {
                                    if (value.isSuccess) {
                                      authController.updateProfile(isUpdateFCMToken: true).then((value) {
                                        if (value.isSuccess) {
                                          navigate(
                                              context: context,
                                              isRemoveUntil: true,
                                              page: const DashboardScreen());

                                          log("------- authController.updateFCMToken() message : ${value.message}");
                                        } else {
                                          log("------- authController.updateFCMToken() message : ${value.message}");
                                        }
                                      });

                                      showToast(
                                          message: value.message,
                                          typeCheck: value.isSuccess);
                                    } else {
                                      showToast(
                                          message: value.message,
                                          typeCheck: value.isSuccess);
                                    }
                                  });
                                }
                              },
                              child: CustomText(
                                "Create Partner Account",
                                style: Helper(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(fontSize: 16.sp, color: white),
                              ),
                            ),
                            sizedBoxHeight(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  "Already have an account? ",
                                  style: Helper(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          fontSize: 16.sp, color: greyDart2),
                                ),
                                CustomButton(
                                  onTap: () {
                                    navigate(
                                        context: context,
                                        page: const SignInScreen());
                                  },
                                  type: ButtonType.tertiary,
                                  child: CustomText(
                                    "Sign In",
                                    style: Helper(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          fontSize: 16.sp,
                                          color: blueLight3,
                                        ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
