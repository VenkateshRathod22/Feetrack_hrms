import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vlr/controllers/staff_contoller.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';

class ReportFilterWidget extends StatefulWidget {
  final Function(String? employeeId, String? status, DateTime startDate, DateTime endDate) onFilterChanged;
  final String? initialStatus;
  final List<String>? statusOptions;

  const ReportFilterWidget({
    super.key,
    required this.onFilterChanged,
    this.initialStatus,
    this.statusOptions,
  });

  @override
  State<ReportFilterWidget> createState() => _ReportFilterWidgetState();
}

class _ReportFilterWidgetState extends State<ReportFilterWidget> {
  String? selectedEmployeeId;
  String? selectedStatus;
  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.initialStatus;
    Get.find<StaffController>().getEmployeesListing();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      margin: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText("Employee", style: Helper(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                    sizedBoxHeight(height: 4),
                    GetBuilder<StaffController>(builder: (staffController) {
                      return DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: selectedEmployeeId,
                        hint: Text("All Employees"),
                        decoration: _inputDecoration(),
                        items: [
                          const DropdownMenuItem(value: null, child: Text("All Employees")),
                          ...staffController.employeeListing.map((e) => DropdownMenuItem(
                                value: e.id.toString(),
                                child: Text(e.name ?? ""),
                              )),
                        ],
                        onChanged: (val) {
                          setState(() => selectedEmployeeId = val);
                          _applyFilter();
                        },
                      );
                    }),
                  ],
                ),
              ),
              sizedBoxWidth(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText("Approval Status", style: Helper(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                    sizedBoxHeight(height: 4),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: selectedStatus,
                      hint: Text("All Statuses"),
                      decoration: _inputDecoration(),
                      items: [
                        const DropdownMenuItem(value: null, child: Text("All Statuses")),
                        ...(widget.statusOptions ?? ['pending', 'approved', 'rejected']).map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(capitalize(e)),
                            )),
                      ],
                      onChanged: (val) {
                        setState(() => selectedStatus = val);
                        _applyFilter();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          sizedBoxHeight(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText("From Date", style: Helper(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                    sizedBoxHeight(height: 4),
                    InkWell(
                      onTap: () => _selectDate(context, true),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                        decoration: _boxDecoration(),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today_rounded, size: 14.sp, color: grey),
                            sizedBoxWidth(width: 8),
                            CustomText(DateFormat('dd-MM-yyyy').format(startDate), style: TextStyle(fontSize: 12.sp)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              sizedBoxWidth(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText("To Date", style: Helper(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                    sizedBoxHeight(height: 4),
                    InkWell(
                      onTap: () => _selectDate(context, false),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                        decoration: _boxDecoration(),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today_rounded, size: 14.sp, color: grey),
                            sizedBoxWidth(width: 8),
                            CustomText(DateFormat('dd-MM-yyyy').format(endDate), style: TextStyle(fontSize: 12.sp)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: greyLight1)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: greyLight1)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: primaryColor)),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(8.r),
      border: Border.all(color: greyLight1),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? startDate : endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
      _applyFilter();
    }
  }

  void _applyFilter() {
    widget.onFilterChanged(selectedEmployeeId, selectedStatus, startDate, endDate);
  }
}
