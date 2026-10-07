import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/controllers/notice_controller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/screens/attendance/attendacn_details/widget/notic_container.dart';
import 'package:vlr/views/screens/attendance/attendance_mart_screen/widget/check_list_section/check_list_section.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Get.find<AttendanceController>().fetchCheckListPoint().then((value) {
      //   if (value.isSuccess) {
      //     showToast(message: value.message, typeCheck: value.isSuccess);
      //   } else {
      //     showToast(message: value.message, typeCheck: value.isSuccess);
      //   }
      // });
      // Get.find<NoticeController>().fetchNoticeBoard();
      Get.find<NoticeController>().fetchNoticeBoard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: AppConstants.screenPadding,
          child: Column(
            children: [
              const CheckListSection(),
              CustomButton(
                onTap: () {
                  Get.find<AttendanceController>()
                      .submitCheckListPointForPunchIn()
                      .then((value) {});
                },
                title: "Submit",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
