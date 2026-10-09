import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vlr/controllers/attendance_controller.dart';
import 'package:vlr/controllers/work_shift_controller.dart';
import 'package:vlr/data/models/employee_model.dart';
import 'package:vlr/data/models/work_shift_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_dropdown.dart';
import 'package:vlr/views/widget/button/appbar_back_button.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class AddAttendenceOrverideScreen extends StatefulWidget {
  const AddAttendenceOrverideScreen({super.key});

  @override
  State<AddAttendenceOrverideScreen> createState() => _AddAttendenceOrverideScreenState();
}

class _AddAttendenceOrverideScreenState extends State<AddAttendenceOrverideScreen> {
  EmployeesModel? selectedEmployee;
  WorkShiftModel? selectedShift;
  
  final TextEditingController dateController = TextEditingController();
  final TextEditingController checkInController = TextEditingController();
  final TextEditingController checkOutController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  
  String selectedStatus = "present";
  final List<String> statusOptions = ["present", "absent", "leave", "half_day"];
  
  String selectedWorkingMode = "office";
  final List<String> workingModeOptions = ["office", "remote", "field"];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AttendanceController>().fetchTeamEmployeesListPagination(refresh: true);
      Get.find<WorkShiftController>().getWorkShifts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: CustomText(
          "Add Attendance Override",
          style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp),
        ),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
        leading: const AppBarBackButton(),
      ),
      body: GetBuilder<AttendanceController>(builder: (attendanceCtrl) {
        return GetBuilder<WorkShiftController>(builder: (shiftCtrl) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFormCard([
                  CustomDropDownList<EmployeesModel>(
                    heading: "SELECT EMPLOYEE",
                    isRequired: true,
                    items: attendanceCtrl.employeesModelList,
                    value: selectedEmployee,
                    hintText: "-- Choose Employee --",
                    onChanged: (val) => setState(() => selectedEmployee = val),
                  ),
                  sizedBoxHeight(height: 20),
                  AppTextFieldWithHeading(
                    heading: "SELECT DATE",
                    isRequired: true,
                    controller: dateController,
                    hindText: "YYYY-MM-DD",
                    readOnly: true,
                    suffix: Icon(Icons.calendar_today_rounded, size: 20.sp, color: primaryColor),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        dateController.text = DateFormat('yyyy-MM-dd').format(picked);
                      }
                    },
                  ),
                ]),
                sizedBoxHeight(height: 20),
                _buildFormCard([
                  Row(
                    children: [
                      Expanded(
                        child: AppTextFieldWithHeading(
                          heading: "CHECK-IN TIME",
                          controller: checkInController,
                          hindText: "HH:MM (24h)",
                          readOnly: true,
                          onTap: () => _selectTime(checkInController),
                        ),
                      ),
                      sizedBoxWidth(width: 16),
                      Expanded(
                        child: AppTextFieldWithHeading(
                          heading: "CHECK-OUT TIME",
                          controller: checkOutController,
                          hindText: "HH:MM (24h)",
                          readOnly: true,
                          onTap: () => _selectTime(checkOutController),
                        ),
                      ),
                    ],
                  ),
                  sizedBoxHeight(height: 20),
                  CustomDropDownList<WorkShiftModel>(
                    heading: "WORK SHIFT",
                    items: shiftCtrl.workShiftList,
                    value: selectedShift,
                    onChanged: (val) => setState(() => selectedShift = val),
                  ),
                ]),
                sizedBoxHeight(height: 20),
                _buildFormCard([
                  Row(
                    children: [
                      Expanded(
                        child: CustomDropDownList<String>(
                          heading: "STATUS",
                          items: statusOptions,
                          value: selectedStatus,
                          onChanged: (val) => setState(() => selectedStatus = val!),
                        ),
                      ),
                      sizedBoxWidth(width: 16),
                      Expanded(
                        child: CustomDropDownList<String>(
                          heading: "WORKING MODE",
                          items: workingModeOptions,
                          value: selectedWorkingMode,
                          onChanged: (val) => setState(() => selectedWorkingMode = val!),
                        ),
                      ),
                    ],
                  ),
                  sizedBoxHeight(height: 20),
                  AppTextFieldWithHeading(
                    heading: "NOTES (OPTIONAL)",
                    controller: notesController,
                    hindText: "Enter reason for override...",
                    maxLines: 3,
                  ),
                ]),
                sizedBoxHeight(height: 32),
                ElevatedButton(
                  onPressed: () => _submit(attendanceCtrl),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tertiaryColor,
                    minimumSize: Size(double.infinity, 50.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  child: attendanceCtrl.isLoading
                      ? SizedBox(width: 20.w, height: 20.w, child:  CircularProgressIndicator(color: white, strokeWidth: 2))
                      : CustomText("Submit Override", style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 16.sp)),
                ),
                sizedBoxHeight(height: 40),
              ],
            ),
          );
        });
      }),
    );
  }

  Widget _buildFormCard(List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(color: black.withValues(alpha: 0.04), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(children: children),
    );
  }

  Future<void> _selectTime(TextEditingController controller) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final hour = picked.hour.toString().padLeft(2, '0');
      final minute = picked.minute.toString().padLeft(2, '0');
      controller.text = "$hour:$minute";
    }
  }

  void _submit(AttendanceController controller) async {
    if (selectedEmployee == null || dateController.text.isEmpty) {
      showToast(message: "Please select employee and date", toastType: ToastType.warning);
      return;
    }

    final body = {
      "employee_id": selectedEmployee!.id,
      "date": dateController.text,
      "check_in": checkInController.text,
      "check_out": checkOutController.text,
      "status": selectedStatus,
      "working_mode": selectedWorkingMode,
      "shift_id": selectedShift?.id?.toString(),
      "notes": notesController.text.trim(),
    };

    final res = await controller.addAttendanceOverride(body);
    if (res.isSuccess) {
      showToast(message: res.message, toastType: ToastType.success);
      Navigator.pop(context);
    } else {
      showToast(message: res.message, toastType: ToastType.error);
    }
  }
}
