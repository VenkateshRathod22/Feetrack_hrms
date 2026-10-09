// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:vlr/controllers/auth_controller.dart';
// import 'package:vlr/services/constants.dart';
// import 'package:vlr/services/custom_text.dart';
// import 'package:vlr/services/theme.dart';
// import 'package:vlr/views/base/custom_button.dart';
// import 'package:vlr/views/base/custom_image.dart';
// import 'package:vlr/views/screens/auth_screens/register_screen.dart';
// import 'package:vlr/views/screens/dashboard/dashboard_screen.dart';
// import 'package:vlr/views/widget/text_box/app_text_box.dart';

// class SignInScreen extends StatefulWidget {
//   const SignInScreen({super.key});

//   @override
//   State<SignInScreen> createState() => _SignInScreenState();
// }

// class _SignInScreenState extends State<SignInScreen> {
//   final formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;

//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           height: size.height,
//           width: double.infinity,
//           padding: AppConstants.screenPadding,
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//                 image: AssetImage(
//                   Assets.imagesLoginBg,
//                 ),
//                 fit: BoxFit.cover),
//           ),
//           child: Form(
//             key: formKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Center(
//                   child: Container(
//                     width: double.infinity,
//                     padding: EdgeInsets.all(24.sp),
//                     decoration: BoxDecoration(
//                         color: white, borderRadius: BorderRadius.circular(24)),
//                     child: GetBuilder<AuthController>(builder: (authController) {
//                       return Column(
//                         children: [
//                           CustomImage(
//                             path: Assets.imagesLogo,
//                             height: 64.h,
//                             fit: BoxFit.cover,
//                           ),
//                           sizedBoxHeight(height: 16),
//                           CustomText(
//                             "Sign in",
//                             style:
//                                 Helper(context).textTheme.titleMedium?.copyWith(
//                                       fontSize: 24.sp,
//                                     ),
//                           ),
//                           sizedBoxHeight(height: 16),
//                           CustomText(
//                             "Welcome back! Please enter your details.",
//                             style: Helper(context)
//                                 .textTheme
//                                 .bodySmall
//                                 ?.copyWith(fontSize: 14.sp, color: greyDart2),
//                           ),
//                           sizedBoxHeight(height: 32),
//                           AppTextFieldWithHeading(
//                             headingWidget: CustomText(
//                               "Login",
//                               style:
//                                   Helper(context).textTheme.labelMedium?.copyWith(
//                                         fontSize: 14.sp,
//                                         color: blueDark2,
//                                       ),
//                             ),
//                             controller: authController.emailController,
//                             preFixWidget: Icon(
//                               Icons.person_outline,
//                               color: greyDart2,
//                             ),
//                             keyboardType: TextInputType.emailAddress,
//                             hindText: "Email",
//                           ),
//                           sizedBoxHeight(height: 16),
//                           AppTextFieldWithHeading(
//                             headingWidget: CustomText(
//                               "Password",
//                               style:
//                                   Helper(context).textTheme.labelMedium?.copyWith(
//                                         fontSize: 14.sp,
//                                         color: blueDark2,
//                                       ),
//                             ),
//                             controller: authController.passwordController,
//                             textInputAction: TextInputAction.done,
//                             preFixWidget: Icon(
//                               Icons.lock_outline_rounded,
//                               color: greyDart2,
//                             ),
//                             keyboardType: TextInputType.text,
//                             hindText: "Password",
//                           ),
//                           sizedBoxHeight(height: 16),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               CustomText(
//                                 "Forgot Password?",
//                                 style: Helper(context)
//                                     .textTheme
//                                     .labelSmall
//                                     ?.copyWith(
//                                       fontSize: 16.sp,
//                                       color: blueLight3,
//                                     ),
//                               ),
//                             ],
//                           ),
//                           sizedBoxHeight(height: 16),
//                           CustomButton(
//                             height: 56,
//                             radius: 14,
//                             isLoading: authController.isLoading,
//                             onTap: () {
//                               authController.postUserLogin().then((value) {
//                                 if (value.isSuccess) {
//                                   authController.fetchProfile().then((profileValue) {
//                                     authController
//                                         .updateProfile(isUpdateFCMToken: true)
//                                         .then((value) {
//                                       if (value.isSuccess) {
//                                         navigate(
//                                             context: context,
//                                             isRemoveUntil: true,
//                                             page: const DashboardScreen());

//                                         log("------- authController.updateFCMToken() message : ${value.message}");
//                                       } else {
//                                         log("------- authController.updateFCMToken() message : ${value.message}");
//                                         // Still navigate even if FCM update fails, as long as profile was fetched
//                                         navigate(
//                                             context: context,
//                                             isRemoveUntil: true,
//                                             page: const DashboardScreen());
//                                       }
//                                     });
//                                   });

//                                   showToast(
//                                       message: value.message,
//                                       typeCheck: value.isSuccess);
//                                 } else {
//                                   showToast(
//                                       message: value.message,
//                                       typeCheck: value.isSuccess);
//                                 }
//                               });
//                             },
//                             child: CustomText(
//                               "Sign In",
//                               style: Helper(context)
//                                   .textTheme
//                                   .labelSmall
//                                   ?.copyWith(fontSize: 16.sp, color: white),
//                             ),
//                           ),
//                           sizedBoxHeight(height: 32),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               CustomText(
//                                 "Don't have an account? ",
//                                 style: Helper(context)
//                                     .textTheme
//                                     .bodySmall
//                                     ?.copyWith(fontSize: 11.sp, color: greyDart2),
//                               ),
//                               CustomButton(
//                                 onTap: () {
//                                   navigate(
//                                       context: context,
//                                       page: const RegisterScreen());
//                                 },
//                                 type: ButtonType.tertiary,
//                                 child: CustomText(
//                                   "Create Account",
//                                   style: Helper(context)
//                                       .textTheme
//                                       .bodyLarge
//                                       ?.copyWith(
//                                         fontSize: 11.sp,
//                                         color: blueLight3,
//                                       ),
//                                 ),
//                               ),
//                             ],
//                           )
//                         ],
//                       );
//                     }),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:vlr/controllers/auth_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/base/custom_image.dart';
import 'package:vlr/views/screens/auth_screens/register_screen.dart';
import 'package:vlr/views/screens/dashboard/dashboard_screen.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final primaryTextColor = colorScheme.onSurface;
    final secondaryTextColor =
        colorScheme.onSurface.withValues(alpha: 0.65);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.imagesLoginBg),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: AppConstants.screenPadding,

            // Dark overlay makes the background comfortable in dark mode.
            color: isDark
                ? const Color(0xCC0E1420)
                : Colors.transparent,

            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24.r),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(
                          color: colorScheme.onSurface.withValues(
                            alpha: 0.08,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.shadowColor.withValues(
                              alpha: isDark ? 0.20 : 0.08,
                            ),
                            blurRadius: 20.r,
                            offset: Offset(0, 8.h),
                          ),
                        ],
                      ),
                      child: GetBuilder<AuthController>(
                        builder: (authController) {
                          return Column(
                            children: [
                              CustomImage(
                                path: Assets.imagesLogo,
                                height: 64.h,
                                fit: BoxFit.contain,
                              ),

                              sizedBoxHeight(height: 16),

                              CustomText(
                                "Sign in",
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w700,
                                  color: primaryTextColor,
                                ),
                              ),

                              sizedBoxHeight(height: 12),

                              CustomText(
                                "Welcome back! Please enter your details.",
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 14.sp,
                                  color: secondaryTextColor,
                                ),
                              ),

                              sizedBoxHeight(height: 32),

                              // Login field
                              AppTextFieldWithHeading(
                                headingWidget: CustomText(
                                  "Login",
                                  style:
                                      theme.textTheme.labelMedium?.copyWith(
                                    fontSize: 14.sp,
                                    color: primaryTextColor,
                                  ),
                                ),
                                controller: authController.emailController,
                                preFixWidget: Icon(
                                  Icons.person_outline_rounded,
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.65,
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                hindText: "Email",
                              ),

                              sizedBoxHeight(height: 16),

                              // Password field
                              AppTextFieldWithHeading(
                                headingWidget: CustomText(
                                  "Password",
                                  style:
                                      theme.textTheme.labelMedium?.copyWith(
                                    fontSize: 14.sp,
                                    color: primaryTextColor,
                                  ),
                                ),
                                controller: authController.passwordController,
                                textInputAction: TextInputAction.done,
                                obscureText: true,
                                preFixWidget: Icon(
                                  Icons.lock_outline_rounded,
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.65,
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                                hindText: "Password",
                              ),

                              sizedBoxHeight(height: 16),

                              // Forgot password
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CustomText(
                                    "Forgot Password?",
                                    style:
                                        theme.textTheme.labelSmall?.copyWith(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),

                              sizedBoxHeight(height: 20),

                              // Sign in button
                              CustomButton(
                                height: 56,
                                radius: 14,
                                color: colorScheme.primary,
                                isLoading: authController.isLoading,
                                onTap: () {
                                  authController.postUserLogin().then((value) {
                                    if (value.isSuccess) {
                                      authController.fetchProfile().then(
                                        (profileValue) {
                                          authController
                                              .updateProfile(
                                                isUpdateFCMToken: true,
                                              )
                                              .then((updateValue) {
                                            if (updateValue.isSuccess) {
                                              navigate(
                                                context: context,
                                                isRemoveUntil: true,
                                                page: const DashboardScreen(),
                                              );

                                              log(
                                                "updateFCMToken message: "
                                                "${updateValue.message}",
                                              );
                                            } else {
                                              log(
                                                "updateFCMToken message: "
                                                "${updateValue.message}",
                                              );

                                              // Preserve existing behavior:
                                              // navigate even if the FCM update fails.
                                              navigate(
                                                context: context,
                                                isRemoveUntil: true,
                                                page: const DashboardScreen(),
                                              );
                                            }
                                          });
                                        },
                                      );

                                      showToast(
                                        message: value.message,
                                        typeCheck: value.isSuccess,
                                      );
                                    } else {
                                      showToast(
                                        message: value.message,
                                        typeCheck: value.isSuccess,
                                      );
                                    }
                                  });
                                },
                                child: CustomText(
                                  "Sign In",
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    color: colorScheme.onPrimary,
                                  ),
                                ),
                              ),

                              sizedBoxHeight(height: 24),

                              // Registration navigation
                              Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 4.w,
                                children: [
                                  CustomText(
                                    "Don't have an account?",
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontSize: 11.sp,
                                      color: secondaryTextColor,
                                    ),
                                  ),

                                  CustomButton(
                                    onTap: () {
                                      navigate(
                                        context: context,
                                        page: const RegisterScreen(),
                                      );
                                    },
                                    type: ButtonType.tertiary,
                                    child: CustomText(
                                      "Create Account",
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w700,
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
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