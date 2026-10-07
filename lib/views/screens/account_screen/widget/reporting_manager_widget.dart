import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/base/custom_image.dart';

class ReportingManagerWidget extends StatelessWidget {
  const ReportingManagerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          width: 1,
          color: greyLight,
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 0,
            color: black.withValues(alpha: 0.05),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            "Reporting Manager",
            style: Helper(context).textTheme.titleMedium?.copyWith(
                  fontSize: 16.sp,
                  color: blackText2,
                ),
          ),
          sizedBoxHeight(height: 16.h),
          Row(
            children: [
              CustomImage(
                path: Assets.imagesProfile,
                height: 56.h,
                width: 56.w,
                radius: 999,
              ),
              sizedBoxWidth(width: 16.w),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      "Ajeet Das",
                      style: Helper(context).textTheme.titleMedium?.copyWith(
                            fontSize: 16.sp,
                            color: blackText2,
                          ),
                    ),
                    sizedBoxHeight(height: 4.h),
                    CustomText(
                      "Operations Manager",
                      style: Helper(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 12.sp,
                            color: blackText2,
                          ),
                    ),
                    sizedBoxHeight(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.call_outlined,
                          color: blackText2,
                          size: 16.sp,
                        ),
                        sizedBoxWidth(width: 4.w),
                        CustomText(
                          "98765 43210",
                          style: Helper(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 12.sp,
                                color: blackText2,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomButton(
                      height: 34.h,
                      onTap: () {},
                      radius: 8,
                      color: greyLight1,
                      borderColor: tertiaryColor.withValues(alpha: 0.20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.call_outlined,
                            color: tertiaryColor,
                            size: 16.sp,
                          ),
                          sizedBoxWidth(width: 4.w),
                          CustomText(
                            "Call",
                            style:
                                Helper(context).textTheme.titleSmall?.copyWith(
                                      fontSize: 12.sp,
                                      color: tertiaryColor,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    CustomButton(
                      height: 34.h,
                      onTap: () {},
                      radius: 8,
                      color: greyLight1,
                      borderColor: tertiaryColor.withValues(alpha: 0.20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.message_outlined,
                            color: tertiaryColor,
                            size: 16.sp,
                          ),
                          sizedBoxWidth(width: 4.w),
                          CustomText(
                            "Message",
                            style:
                                Helper(context).textTheme.titleSmall?.copyWith(
                                      fontSize: 12.sp,
                                      color: tertiaryColor,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
