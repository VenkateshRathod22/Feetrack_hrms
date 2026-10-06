import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/controllers/permission_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/screens/account_screen/widget/daily_attendance_section/punch_out_button.dart';

class CaptureVerificationSection extends StatelessWidget {
  const CaptureVerificationSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: greyLight6),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                24.r,
              ),
              topRight: Radius.circular(
                24.r,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.camera_alt_outlined,
                color: blueLight3,
              ),
              sizedBoxWidth(width: 8.w),
              CustomText(
                "CAPTURE VERIFICATION",
                style: Helper(context).textTheme.labelMedium?.copyWith(
                      fontSize: 14,
                      color: greyDart2,
                    ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1, color: greyLight6),
              left: BorderSide(width: 1, color: greyLight6),
              right: BorderSide(width: 1, color: greyLight6),
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(
                24.r,
              ),
              bottomRight: Radius.circular(
                24.r,
              ),
            ),
          ),
          child: Column(
            children: [
              GetBuilder<PermissionController>(
                builder: (controller) {
                  return Container(
                    height: 250.h,
                    width: 200.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32.r),
                      color: Colors.black,
                    ),
                    child: controller.selfie == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.videocam_off_outlined,
                                color: Colors.white,
                                size: 40.sp,
                              ),
                              CustomText(
                                "Camera is off",
                                style: Helper(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(color: Colors.white),
                              ),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(32.r),
                            child: Image.file(
                              controller.selfie!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                  );
                },
              ),
              sizedBoxHeight(height: 24),
              GetBuilder<PermissionController>(builder: (permissionController) {
                return Column(
                  children: [
                    CustomButton(
                      height: 52.h,
                      onTap: () async {
                        if (permissionController.currentAddress ==
                            "Location pending...") {
                          showToast(
                            message: "Wait, location is loading",
                            toastType: ToastType.info,
                          );
                          return;
                        }

                        final picker = ImagePicker();

                        final XFile? file = await picker.pickImage(
                          source: ImageSource.camera,
                          preferredCameraDevice: CameraDevice.front,
                          imageQuality: 35,
                          maxWidth: 720,
                          maxHeight: 1280,
                        );

                        if (file == null) return;

                        permissionController.setSelfie(
                          File(file.path),
                        );

                        showToast(
                          message: "Selfie captured successfully",
                          toastType: ToastType.success,
                        );
                      },
                      radius: 999.r,
                      type: ButtonType.secondary,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            color: blueLight3,
                          ),
                          sizedBoxWidth(width: 12.w),
                          CustomText(
                            "Start Camera",
                            style:
                                Helper(context).textTheme.titleMedium?.copyWith(
                                      fontSize: 16.sp,
                                      color: blueLight3,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    sizedBoxHeight(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: blueLight3,
                        ),
                        sizedBoxWidth(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                permissionController.currentAddress ??
                                    "Location pending...",
                                maxLines: 4,
                                style: Helper(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontSize: 16.sp,
                                      color: greyDart2,
                                    ),
                              ),
                              sizedBoxHeight(height: 4.h),
                              CustomText(
                                (permissionController.currentAddress != null ||
                                        (permissionController
                                                .currentAddress?.isNotEmpty ??
                                            false))
                                    ? "${(permissionController.latitude ?? "").toString()} , ${(permissionController.latitude ?? "").toString()}"
                                    : "",
                                maxLines: 4,
                                style: Helper(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      fontSize: 14.sp,
                                      color: blackText3,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
             
            ],
          ),
        ),
      ],
    );
  }
}
