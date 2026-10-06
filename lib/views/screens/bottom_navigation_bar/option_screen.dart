import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/auth_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/dashboard/home_screen/widget/quick_action_section/quick_action_widget.dart';

class OptionScreen extends StatefulWidget {
  const OptionScreen({super.key});

  @override
  State<OptionScreen> createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch profile on initialization to ensure the latest permissions are loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AuthController>().fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          "All Options",
          style: Helper(context).textTheme.titleMedium?.copyWith(
                fontSize: 18.sp,
                color: white,
              ),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 0,
        leading: Navigator.canPop(context) ? IconButton(
          onPressed: () => Navigator.pop(context),
          icon:  Icon(Icons.arrow_back, color: white),
        ) : null,
      ),
      body: GetBuilder<AuthController>(builder: (authController) {
        final allActions = [
          ...quickActionModelList(context: context),
          ...managementActions1(context: context),
          ...managementActions2(context: context),
        ].where((action) {
          if (action.requiredPermission == null) return true;
          return authController.hasPermission(action.requiredPermission!);
        }).toList();

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                "Quick Access",
                style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 16.sp),
              ),
              sizedBoxHeight(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 20.h,
                  crossAxisSpacing: 10.w,
                  mainAxisExtent: 95.h,
                ),
                itemCount: allActions.length,
                itemBuilder: (context, index) {
                  return QuickActionWidget(quickActionModel: allActions[index]);
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
