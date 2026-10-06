import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/braches_controller.dart';
import 'package:vlr/controllers/department_controller.dart';
import 'package:vlr/controllers/staff_contoller.dart';
import 'package:vlr/controllers/training_report_controller.dart';
import 'package:vlr/data/models/reports/training_report_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_dropdown.dart';
import 'package:vlr/views/screens/training_management/add_training_program_screen.dart';
import 'package:vlr/views/screens/training_management/widget/taining_stats_card_widget.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';
import 'package:collection/collection.dart';

class TrainingProgramsListScreen extends StatefulWidget {
  const TrainingProgramsListScreen({super.key});

  @override
  State<TrainingProgramsListScreen> createState() => _TrainingProgramsListScreenState();
}

class _TrainingProgramsListScreenState extends State<TrainingProgramsListScreen> {
  String? selectedYear = DateTime.now().year.toString();
  String? selectedMonth;
  String? selectedBranch;
  String? selectedDepartment;
  String? selectedEmployee;
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  final List<String> years = [
    for (int i = DateTime.now().year - 2; i <= DateTime.now().year + 2; i++) i.toString()
  ];
  final List<String> months = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() {
    _fetchData();
    Get.find<BrachesController>().getBranchesList();
    Get.find<DepartmentController>().getDepartmentList();
    Get.find<StaffController>().getEmployeesListing();
  }

  Map<String, dynamic> _getFilterData() {
    Map<String, dynamic> filters = {};
    if (selectedYear != null) filters['year'] = selectedYear;
    if (selectedMonth != null && selectedMonth != "Full Year (Jan-Dec)") {
      int monthIdx = months.indexOf(selectedMonth!) + 1;
      filters['month'] = monthIdx.toString().padLeft(2, '0');
    }
    if (selectedBranch != null && selectedBranch != "All Branches") {
      final branches = Get.find<BrachesController>().branchList;
      final branch = branches.firstWhereOrNull((e) => e.name == selectedBranch);
      if (branch != null) filters['branch_id'] = branch.id.toString();
    }
    if (selectedDepartment != null && selectedDepartment != "All Departments") {
      final depts = Get.find<DepartmentController>().departmentList;
      final dept = depts.firstWhereOrNull((e) => e.name == selectedDepartment);
      if (dept != null) filters['department_id'] = dept.id.toString();
    }
    if (selectedEmployee != null && selectedEmployee != "All Employees") {
      final employees = Get.find<StaffController>().employeeListing;
      final emp = employees.firstWhereOrNull((e) => e.name == selectedEmployee);
      if (emp != null) filters['employee_id'] = emp.id.toString();
    }
    if (searchController.text.isNotEmpty) {
      filters['search'] = searchController.text;
    }
    return filters;
  }

  void _fetchData() {
    final search = _getFilterData();
    Get.find<TrainingReportController>().getTrainingPrograms(search: search);
    Get.find<TrainingReportController>().getTrainingDashboard(search: search);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: CustomText("Training Dashboard", style: Helper(context).textTheme.titleMedium?.copyWith(fontSize: 18.sp)),
        centerTitle: true,
        backgroundColor: white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _showAssignTrainingBottomSheet(context),
            icon: Icon(Icons.assignment_ind_rounded, color: primaryColor),
            tooltip: "Assign Training",
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => navigate(context: context, page: const AddTrainingProgramScreen()),
        backgroundColor: primaryColor,
        icon:  Icon(Icons.add_rounded, color: white),
        label: CustomText("Add Program", style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 14.sp)),
      ),
      body: GetBuilder<TrainingReportController>(builder: (controller) {
        if (controller.isLoading && controller.trainingPrograms.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () async {
            _fetchData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildFilterSection(),
                const TrainingStatsCardWidget(),
                const TrainingBarWidget(),
                const TrainingPieWidget(),
                const TrainingScoreByProgramWidget(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText("Training Records", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: blackText1)),
                      CustomText("${controller.trainingAssignments.length} Records", style: TextStyle(fontSize: 11.sp, color: greyText)),
                    ],
                  ),
                ),
                if (controller.trainingAssignments.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: const Center(child: Text("No training records found")),
                  )
                else
                  ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.r),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.trainingAssignments.length,
                    separatorBuilder: (_, __) => sizedBoxHeight(height: 12.h),
                    itemBuilder: (context, index) {
                      final assignment = controller.trainingAssignments[index];
                      return _buildAssignmentCard(context, assignment);
                    },
                  ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 12.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText("All Programs Master", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: blackText1)),
                      CustomText("${controller.trainingPrograms.length} Items", style: TextStyle(fontSize: 11.sp, color: greyText)),
                    ],
                  ),
                ),
                if (controller.trainingPrograms.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: const Center(child: Text("No training programs found")),
                  )
                else
                  ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.r),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.trainingPrograms.length,
                    separatorBuilder: (_, __) => sizedBoxHeight(height: 12.h),
                    itemBuilder: (context, index) {
                      final program = controller.trainingPrograms[index];
                      return _buildProgramCard(context, program);
                    },
                  ),
                sizedBoxHeight(height: 80),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      margin: EdgeInsets.all(16.r),
      padding: EdgeInsets.all(16.r),
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
        children: [
          Row(
            children: [
              Expanded(
                child: CustomDropDownList<String>(
                  heading: "Year",
                  items: years,
                  value: selectedYear,
                  onChanged: (val) {
                    setState(() => selectedYear = val);
                    _fetchData();
                  },
                ),
              ),
              sizedBoxWidth(width: 12),
              Expanded(
                child: CustomDropDownList<String>(
                  heading: "Month",
                  items: ["Full Year (Jan-Dec)", ...months],
                  value: selectedMonth ?? "Full Year (Jan-Dec)",
                  onChanged: (val) {
                    setState(() => selectedMonth = val == "Full Year (Jan-Dec)" ? null : val);
                    _fetchData();
                  },
                ),
              ),
            ],
          ),
          sizedBoxHeight(height: 12),
          GetBuilder<BrachesController>(builder: (branchController) {
            return CustomDropDownList<String>(
              heading: "Branch",
              items: ["All Branches", ...branchController.branchList.map((e) => e.name ?? "")],
              value: selectedBranch ?? "All Branches",
              onChanged: (val) {
                setState(() => selectedBranch = val == "All Branches" ? null : val);
                _fetchData();
              },
            );
          }),
          sizedBoxHeight(height: 12),
          GetBuilder<DepartmentController>(builder: (deptController) {
            return CustomDropDownList<String>(
              heading: "Department",
              items: ["All Departments", ...deptController.departmentList.map((e) => e.name ?? "")],
              value: selectedDepartment ?? "All Departments",
              onChanged: (val) {
                setState(() => selectedDepartment = val == "All Departments" ? null : val);
                _fetchData();
              },
            );
          }),
          sizedBoxHeight(height: 12),
          GetBuilder<StaffController>(builder: (staffController) {
            return CustomDropDownList<String>(
              heading: "Employee",
              items: ["All Employees", ...staffController.employeeListing.map((e) => e.name ?? "")],
              value: selectedEmployee ?? "All Employees",
              onChanged: (val) {
                setState(() => selectedEmployee = val == "All Employees" ? null : val);
                _fetchData();
              },
            );
          }),
          sizedBoxHeight(height: 12),
          AppTextFieldWithHeading(
            controller: searchController,
            heading: "Search",
            hindText: "Search training records...",
            onChanged: (val) {
              if (_debounce?.isActive ?? false) _debounce!.cancel();
              _debounce = Timer(const Duration(milliseconds: 500), () {
                _fetchData();
              });
            },
          ),
        ],
      ),
    );
  }

  void _showAssignTrainingBottomSheet(BuildContext context) {
    int? selectedProgramId;
    List<String> selectedEmployeeIds = [];
    DateTime? startDate;
    DateTime? endDate;

    final staffController = Get.find<StaffController>();
    if (staffController.employeeListing.isEmpty) {
      staffController.getEmployeesListing();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(builder: (context, setModalState) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          padding: EdgeInsets.all(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText("Assign Training", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: blackText1)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
                ],
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sizedBoxHeight(height: 16),
                      CustomText("Select Program", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                      sizedBoxHeight(height: 8),
                      GetBuilder<TrainingReportController>(builder: (controller) {
                        return DropdownButtonFormField<int>(
                          isExpanded: true,
                          value: selectedProgramId,
                          decoration: _inputDecoration("Choose program"),
                          items: controller.trainingPrograms.map((p) => DropdownMenuItem(value: p.id, child: Text(p.title ?? ""))).toList(),
                          onChanged: (val) => setModalState(() => selectedProgramId = val),
                        );
                      }),
                      sizedBoxHeight(height: 20),
                      CustomText("Select Employees", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                      sizedBoxHeight(height: 8),
                      GetBuilder<StaffController>(builder: (staffCtrl) {
                        return Container(
                          decoration: BoxDecoration(
                            color: greyLight1,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: greyLight2),
                          ),
                          constraints: BoxConstraints(maxHeight: 250.h),
                          child: staffCtrl.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: staffCtrl.employeeListing.length,
                                  itemBuilder: (context, index) {
                                    final employee = staffCtrl.employeeListing[index];
                                    final isSelected = selectedEmployeeIds.contains(employee.id);
                                    return CheckboxListTile(
                                      title: Text(employee.name ?? "", style: TextStyle(fontSize: 13.sp)),
                                      subtitle: Text(employee.employeeCode ?? "", style: TextStyle(fontSize: 11.sp, color: greyText)),
                                      value: isSelected,
                                      activeColor: primaryColor,
                                      onChanged: (val) {
                                        setModalState(() {
                                          if (val == true) {
                                            selectedEmployeeIds.add(employee.id!);
                                          } else {
                                            selectedEmployeeIds.remove(employee.id);
                                          }
                                        });
                                      },
                                    );
                                  },
                                ),
                        );
                      }),
                      sizedBoxHeight(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText("Start Date", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                                sizedBoxHeight(height: 8),
                                InkWell(
                                  onTap: () async {
                                    final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
                                    if (date != null) setModalState(() => startDate = date);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                                    decoration: BoxDecoration(
                                      color: white,
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(color: greyLight2),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.calendar_today_rounded, size: 16.sp, color: greyText),
                                        sizedBoxWidth(width: 8),
                                        Text(startDate == null ? "Select Date" : startDate!.toString().split(" ")[0]),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          sizedBoxWidth(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText("End Date", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                                sizedBoxHeight(height: 8),
                                InkWell(
                                  onTap: () async {
                                    final date = await showDatePicker(context: context, initialDate: startDate ?? DateTime.now(), firstDate: startDate ?? DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
                                    if (date != null) setModalState(() => endDate = date);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                                    decoration: BoxDecoration(
                                      color: white,
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(color: greyLight2),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.calendar_today_rounded, size: 16.sp, color: greyText),
                                        sizedBoxWidth(width: 8),
                                        Text(endDate == null ? "Select Date" : endDate!.toString().split(" ")[0]),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      sizedBoxHeight(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r))),
                          onPressed: () async {
                            if (selectedProgramId == null || selectedEmployeeIds.isEmpty || startDate == null || endDate == null) {
                              showToast(message: "Please fill all fields", toastType: ToastType.warning);
                              return;
                            }

                            final body = {
                              "training_id": selectedProgramId,
                              "employee_ids": selectedEmployeeIds,
                              "start_date": startDate!.toString().split(" ")[0],
                              "end_date": endDate!.toString().split(" ")[0],
                            };

                            final res = await Get.find<TrainingReportController>().assignTraining(body);
                            if (res.isSuccess) {
                              Navigator.pop(context);
                              showToast(message: res.message, toastType: ToastType.success);
                            } else {
                              showToast(message: res.message, toastType: ToastType.error);
                            }
                          },
                          child: CustomText("Assign Now", style: TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 16.sp)),
                        ),
                      ),
                      sizedBoxHeight(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 13.sp, color: greyText),
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: greyLight2)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: greyLight2)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: const BorderSide(color: primaryColor)),
      filled: true,
      fillColor: white,
    );
  }

  Widget _buildAssignmentCard(BuildContext context, TrainingAssignmentModel record) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [BoxShadow(color: black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomText(record.employeeName ?? "N/A", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: blackText1)),
              ),
              _buildStatusBadge(record.status),
            ],
          ),
          sizedBoxHeight(height: 4),
          CustomText(record.trainingTitle ?? "N/A", style: TextStyle(fontSize: 12.sp, color: primaryColor, fontWeight: FontWeight.w600)),
          sizedBoxHeight(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _scoreDetail("Attendance", "${record.attendancePercentage}%"),
              _scoreDetail("Score", "${record.assessmentScore}%"),
              _scoreDetail("Result", capitalize(record.result ?? "Pending"), color: record.result == 'passed' ? Colors.green : (record.result == 'failed' ? Colors.red : blackText1)),
            ],
          ),
          sizedBoxHeight(height: 12),
          const Divider(),
          sizedBoxHeight(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _recordItem(Icons.business_outlined, record.department ?? "N/A"),
              _recordItem(Icons.calendar_today_outlined, record.assignedAt?.split("T")[0] ?? "N/A"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _scoreDetail(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(label, style: TextStyle(fontSize: 9.sp, color: greyText)),
        CustomText(value, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: color ?? blackText1)),
      ],
    );
  }

  Widget _recordItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 12, color: greyText),
        sizedBoxWidth(width: 6),
        CustomText(text, style: TextStyle(fontSize: 10.sp, color: greyDart2)),
      ],
    );
  }

  Widget _buildStatusBadge(String? status) {
    Color color = Colors.blue;
    if (status == 'completed') color = Colors.green;
    if (status == 'assigned') color = Colors.orange;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20.r)),
      child: CustomText(capitalize(status ?? "N/A"), style: TextStyle(fontSize: 10.sp, color: color, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildProgramCard(BuildContext context, TrainingProgramModel program) {
    return Container(
      padding: EdgeInsets.all(16.r),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomText(program.title ?? "N/A", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: blackText1)),
              ),
              _buildActionMenu(program),
            ],
          ),
          sizedBoxHeight(height: 4),
          CustomText(program.trainer ?? "N/A", style: TextStyle(fontSize: 12.sp, color: primaryColor, fontWeight: FontWeight.w600)),
          sizedBoxHeight(height: 8),
          CustomText(program.description ?? "", style: TextStyle(fontSize: 11.sp, color: greyText), maxLines: 2, overflow: TextOverflow.ellipsis),
          sizedBoxHeight(height: 12),
          const Divider(),
          sizedBoxHeight(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _detailItem("Type", capitalize(program.trainingType)),
              _detailItem("Duration", "${program.duration} Days"),
              _detailItem("Assignments", (program.assignmentsCount ?? 0).toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(label, style: TextStyle(fontSize: 9.sp, color: greyText)),
        CustomText(value, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold, color: blackText1)),
      ],
    );
  }

  Widget _buildActionMenu(TrainingProgramModel program) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: Icon(Icons.more_vert_rounded, size: 20, color: greyDart2),
      onSelected: (val) {
        if (val == 'edit') {
          navigate(context: context, page: AddTrainingProgramScreen(program: program));
        } else if (val == 'delete') {
          _confirmDelete(program);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit_rounded, size: 18, color: Colors.blue), SizedBox(width: 8), Text("Edit")])),
        const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_rounded, size: 18, color: Colors.red), SizedBox(width: 8), Text("Delete")])),
      ],
    );
  }

  void _confirmDelete(TrainingProgramModel program) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Program?"),
        content: Text("Are you sure you want to delete '${program.title}'? This action cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Get.find<TrainingReportController>().deleteTrainingProgram(program.id!).then((res) {
                if (res.isSuccess) {
                  showToast(message: res.message, toastType: ToastType.success);
                } else {
                  showToast(message: res.message, toastType: ToastType.error);
                }
              });
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class TrainingBarWidget extends StatelessWidget {
  const TrainingBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrainingReportController>(builder: (controller) {
      final trends = controller.trainingAnalytics?.monthlyTrends;
      if (trends == null || trends.isEmpty) return const SizedBox.shrink();

      int maxVal = 1;
      for (var trend in trends) {
        if ((trend.assigned ?? 0) > maxVal) maxVal = trend.assigned!;
        if ((trend.completed ?? 0) > maxVal) maxVal = trend.completed!;
      }

      return Container(
        margin: EdgeInsets.all(16.r),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [BoxShadow(color: black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText("Training Assigned vs Completed (2026)", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: blackText1)),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(color: greyLight1, borderRadius: BorderRadius.circular(4.r)),
                  child: CustomText("Monthly Trend", style: TextStyle(fontSize: 8.sp, color: greyText)),
                ),
              ],
            ),
            sizedBoxHeight(height: 20),
            SizedBox(
              height: 180.h,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: trends.map((trend) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _buildBar(trend.assigned ?? 0, maxVal, Colors.blue),
                              sizedBoxWidth(width: 4),
                              _buildBar(trend.completed ?? 0, maxVal, Colors.green),
                            ],
                          ),
                          sizedBoxHeight(height: 8),
                          CustomText(trend.month ?? "", style: TextStyle(fontSize: 10.sp, color: greyText)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            sizedBoxHeight(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _legendItem("Assigned", Colors.blue),
                sizedBoxWidth(width: 16),
                _legendItem("Completed", Colors.green),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBar(int value, int max, Color color) {
    double heightFactor = (value / max).clamp(0.02, 1.0);
    return Container(
      width: 10.w,
      height: heightFactor * 120.h,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.8),
        borderRadius: BorderRadius.vertical(top: Radius.circular(2.r)),
      ),
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 8.w, height: 8.w, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        sizedBoxWidth(width: 6),
        CustomText(label, style: TextStyle(fontSize: 10.sp, color: greyText)),
      ],
    );
  }
}

class TrainingPieWidget extends StatelessWidget {
  const TrainingPieWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrainingReportController>(builder: (controller) {
      final breakdown = controller.trainingAnalytics?.deptBreakdown;
      if (breakdown == null || breakdown.isEmpty) return const SizedBox.shrink();

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [BoxShadow(color: black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.donut_large_rounded, size: 16.sp, color: Colors.green),
                sizedBoxWidth(width: 8),
                CustomText("Department Training Completion Rate", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: blackText1)),
              ],
            ),
            sizedBoxHeight(height: 20),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 140.r,
                    width: 140.r,
                    child: CircularProgressIndicator(
                      value: (breakdown.first.scorePct ?? 0) / 100,
                      strokeWidth: 20.w,
                      backgroundColor: greyLight1,
                      color: Colors.green,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText("${breakdown.first.scorePct}%", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: blackText1)),
                      CustomText("Completion", style: TextStyle(fontSize: 10.sp, color: greyText)),
                    ],
                  )
                ],
              ),
            ),
            sizedBoxHeight(height: 24),
            ...breakdown.take(3).map((dept) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                children: [
                  Container(width: 12.w, height: 12.w, decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(2.r))),
                  sizedBoxWidth(width: 8),
                  Expanded(child: CustomText(dept.department ?? "N/A", style: TextStyle(fontSize: 11.sp, color: greyDart2))),
                  CustomText("${dept.completed}/${dept.assigned}", style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600)),
                ],
              ),
            )),
          ],
        ),
      );
    });
  }
}

class TrainingScoreByProgramWidget extends StatelessWidget {
  const TrainingScoreByProgramWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrainingReportController>(builder: (controller) {
      final breakdown = controller.trainingAnalytics?.programBreakdown;
      if (breakdown == null || breakdown.isEmpty) return const SizedBox.shrink();

      return Container(
        margin: EdgeInsets.all(16.r),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [BoxShadow(color: black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bar_chart_rounded, size: 16.sp, color: Colors.deepPurple),
                sizedBoxWidth(width: 8),
                CustomText("Average Assessment Score by Program", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: blackText1)),
              ],
            ),
            sizedBoxHeight(height: 20),
            ...breakdown.take(5).map((program) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: CustomText(program.title ?? "N/A", style: TextStyle(fontSize: 11.sp, color: greyDart2))),
                      CustomText("${program.scorePct}%", style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                    ],
                  ),
                  sizedBoxHeight(height: 6),
                  LinearProgressIndicator(
                    value: (program.scorePct ?? 0) / 100,
                    backgroundColor: greyLight1,
                    color: Colors.deepPurple.withValues(alpha: 0.7),
                    minHeight: 8.h,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ],
              ),
            )),
          ],
        ),
      );
    });
  }
}
