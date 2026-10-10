import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:vlr/controllers/permission_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class LocationRowWidget extends StatefulWidget {
  const LocationRowWidget({super.key});

  @override
  State<LocationRowWidget> createState() => _LocationRowWidgetState();
}

class _LocationRowWidgetState extends State<LocationRowWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PermissionController>(
      builder: (permissionController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  "Face & location verified",
                  style: Helper(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12.sp,
                        color: greyLight5,
                      ),
                ),
              ],
            ),
            sizedBoxHeight(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on_rounded,
                  color: greyLight9,
                  size: 12.sp,
                ),
                sizedBoxWidth(width: 4),
                Column(
                  children: [
                    CustomText(
                      permissionController.areaName ?? "Location pending...",
                      style: Helper(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 12.sp,
                            color: greyLight9,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            sizedBoxHeight(height: 16),
            Divider(
              color: dividerColor1,
            ),
          ],
        );
      },
    );
  }
}
