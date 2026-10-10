import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/account_screen/widget/account_option_section/account_option_section.dart';
import 'package:vlr/views/screens/account_screen/widget/puch_time_in_out_section/daily_attendance_section.dart';
import 'package:vlr/views/screens/account_screen/widget/reporting_manager_widget.dart';
import 'package:vlr/views/screens/account_screen/widget/row_logout_account_delete_section/row_logout_account_delete_section.dart';
import 'package:vlr/views/screens/attendance/attendance_punch_in_out_successful_screen/attendance_punch_in_out_success_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AttendanceController>().fetchTodayAttendance();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  primaryColor,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          "Account",
          style: Helper(context).textTheme.titleMedium?.copyWith(
                fontSize: 16,
                color: white,
              ),
        ),
        leading: Navigator.canPop(context) ? IconButton(
            onPressed: () {
              pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: white,
            )) : null,
        actions: [
          IconButton(
            onPressed: () {
              navigate(context: context, page: const AttendancePunchInOutSuccessScreen());
            },
            icon: Icon(
              Icons.notifications_none_outlined,
              color: white,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
             // UserInfoTopHome(),
            sizedBoxHeight(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  const DailyAttendanceSection(),
                  sizedBoxHeight(height: 16.h),
                  const ReportingManagerWidget(),
                  sizedBoxHeight(height: 24.h),
                  const AccountOptionSection(),
                  sizedBoxHeight(height: 24.h),
                  const RowOfLogOutAndDeleteAccountSection(),
                  sizedBoxHeight(height: 30.h),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
