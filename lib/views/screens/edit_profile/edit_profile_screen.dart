import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/auth_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/extensions.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/base/custom_image.dart';
import 'package:vlr/views/base/image_picker_sheet.dart';
import 'package:vlr/views/base/shimmer.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authController = Get.find<AuthController>();
      authController.fullNameController.text =
          authController.userModel?.name ?? "";
      authController.emailController.text =
          authController.userModel?.email ?? "";
      authController.mobileController.text =
          authController.userModel?.mobile ?? "";
    });
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          "Update Profile",
          style: Helper(context).textTheme.titleMedium?.copyWith(
                fontSize: 18.sp,
              ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: Padding(
        padding: AppConstants.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GetBuilder<AuthController>(builder: (authController) {
              return CustomButton(
                height: 56.h,
                isLoading: authController.isLoading,
                onTap: () {
                  authController.updateProfile().then((value) {
                    if (value.isSuccess) {
                      pop(context);
                      showToast(
                          message: value.message, typeCheck: value.isSuccess);
                    } else {
                      showToast(
                          message: value.message, typeCheck: value.isSuccess);
                      log(value.message);
                    }
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      "Save Changes",
                      style: Helper(context).textTheme.titleMedium?.copyWith(
                            fontSize: 16.sp,
                            color: white,
                          ),
                    ),
                    sizedBoxWidth(width: 12.w),
                    SvgPicture.asset(
                      Assets.svgsCheckInCircle,
                      colorFilter: ColorFilter.mode(white, BlendMode.srcIn),
                    )
                  ],
                ),
              );
            }),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: AppConstants.screenPadding,
        child: GetBuilder<AuthController>(builder: (authController) {
          return Form(
            key: formKey,
            child: Column(
              children: [
                Center(
                  child: CustomShimmer(
                    isLoading: authController.isLoading,
                    child: Container(
                      height: 128.h,
                      width: 128.w,
                      decoration: BoxDecoration(
                          color: white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 4,
                            color: greyLight6,
                          ),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 4),
                              blurRadius: 6,
                              spreadRadius: -4,
                              color: black.withValues(alpha: 0.1),
                            ),
                            BoxShadow(
                              offset: const Offset(0, 10),
                              blurRadius: 15,
                              spreadRadius: -3,
                              color: black.withValues(alpha: 0.1),
                            ),
                          ]),
                      child: authController.profileImage == null
                          ? CustomImage(
                              path: Assets.imagesNoProfile,
                              fit: BoxFit.cover,
                              onTap: () async {
                                final file = await getImageBottomSheet(context);
                                if (file != null) {
                                  authController.updateImages(file);
                                }
                              })
                          : InkWell(
                              onTap: () async {
                                final file = await getImageBottomSheet(context);
                                if (file != null) {
                                  authController.updateImages(file);
                                }
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(79),
                                child: Image.file(
                                  authController.profileImage!,
                                  height: 130,
                                  width: 130,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
                sizedBoxHeight(height: 40),
                AppTextFieldWithHeading(
                  headingWidget: CustomText(
                    "Full Name",
                    style: Helper(context).textTheme.labelMedium?.copyWith(
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
                    style: Helper(context).textTheme.labelMedium?.copyWith(
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
                    style: Helper(context).textTheme.labelMedium?.copyWith(
                          fontSize: 14.sp,
                          color: blueDark2,
                        ),
                  ),
                  controller: authController.mobileController,
                  preFixWidget: Icon(
                    Icons.call_outlined,
                    color: greyDart2,
                  ),
                  textInputAction: TextInputAction.done,
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
              ],
            ),
          );
        }),
      ),
    );
  }
}
