import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vlr/controllers/daily_report_controller.dart';
import 'package:vlr/data/models/reports/daily_report_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_button.dart';
import 'package:vlr/views/base/shimmer.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class DailyReportScreen extends StatefulWidget {
  const DailyReportScreen({super.key});

  @override
  State<DailyReportScreen> createState() => _DailyReportScreenState();
}

class _DailyReportScreenState extends State<DailyReportScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = "";
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<DailyReportController>().getDailyReports();
      Get.find<DailyReportController>().getTeamReports();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _dateController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _fetchFilteredData() {
    if (_tabController.index == 0) {
      Get.find<DailyReportController>().getDailyReports(
        date: _dateController.text.isNotEmpty ? _dateController.text : null,
      );
    } else {
      Get.find<DailyReportController>().getTeamReports(
        search: _searchController.text.trim().isNotEmpty ? _searchController.text.trim() : null,
        status: _selectedStatus.isNotEmpty ? _selectedStatus : null,
        date: _dateController.text.isNotEmpty ? _dateController.text : null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText("Daily Work Reports"),
        backgroundColor: primaryColor,
        foregroundColor: white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: white,
          unselectedLabelColor: white.withOpacity(0.6),
          indicatorColor: secondaryColor,
          tabs: const [
            Tab(text: "My Reports"),
            Tab(text: "Team Reports"),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              _selectDate(context);
            },
            icon: const Icon(Icons.calendar_month),
          ),
          if (_dateController.text.isNotEmpty || _searchController.text.isNotEmpty || _selectedStatus.isNotEmpty)
            IconButton(
              onPressed: () {
                setState(() {
                  _dateController.clear();
                  _searchController.clear();
                  _selectedStatus = "";
                });
                _fetchFilteredData();
              },
              icon: const Icon(Icons.clear_all),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.find<DailyReportController>().clearFormData();
          Get.find<DailyReportController>().getPendingTasks();
          navigate(context: context, page: const AddDailyReportScreen());
        },
        backgroundColor: primaryColor,
        child: Icon(Icons.add, color: white),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // My Reports Tab
          GetBuilder<DailyReportController>(
            builder: (controller) {
              if (controller.isLoading && controller.dailyReports.isEmpty) {
                return _buildShimmerList();
              }

              if (controller.dailyReports.isEmpty) {
                return _buildEmptyState("No reports found");
              }

              return RefreshIndicator(
                onRefresh: () async => _fetchFilteredData(),
                child: ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  itemCount: controller.dailyReports.length,
                  separatorBuilder: (context, index) => sizedBoxHeight(height: 12),
                  itemBuilder: (context, index) {
                    final report = controller.dailyReports[index];
                    return _buildReportCard(context, report, false);
                  },
                ),
              );
            },
          ),

          // Team Reports Tab
          GetBuilder<DailyReportController>(
            builder: (controller) {
              return Column(
                children: [
                  _buildTeamFilters(),
                  Expanded(
                    child: Builder(builder: (context) {
                      if (controller.isLoading && controller.teamReports.isEmpty) {
                        return _buildShimmerList();
                      }

                      if (controller.teamReports.isEmpty) {
                        return _buildEmptyState("No team reports found");
                      }

                      return RefreshIndicator(
                        onRefresh: () async => _fetchFilteredData(),
                        child: ListView.separated(
                          padding: EdgeInsets.all(16.w),
                          itemCount: controller.teamReports.length,
                          separatorBuilder: (context, index) => sizedBoxHeight(height: 12),
                          itemBuilder: (context, index) {
                            final report = controller.teamReports[index];
                            return _buildReportCard(context, report, true);
                          },
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTeamFilters() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search employee...",
                    prefixIcon: const Icon(Icons.search),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                  ),
                  onSubmitted: (_) => _fetchFilteredData(),
                ),
              ),
              sizedBoxWidth(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[400]!),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedStatus,
                    isDense: true,
                    items: const [
                      DropdownMenuItem(value: "", child: CustomText("All Status")),
                      DropdownMenuItem(value: "submitted", child: CustomText("Submitted")),
                      DropdownMenuItem(value: "manager_approved", child: CustomText("Approved")),
                      DropdownMenuItem(value: "rejected", child: CustomText("Rejected")),
                    ],
                    onChanged: (val) {
                      setState(() {
                        _selectedStatus = val ?? "";
                      });
                      _fetchFilteredData();
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
      _fetchFilteredData();
    }
  }

  Widget _buildReportCard(BuildContext context, DailyReportModel report, bool isTeam) {
    return GestureDetector(
      onTap: () {
        Get.find<DailyReportController>().getDailyReportDetails(report.id!);
        navigate(
          context: context,
          page: DailyReportDetailScreen(isTeamReport: isTeam),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isTeam && report.employee != null) ...[
              Row(
                children: [
                  CircleAvatar(
                    radius: 14.r,
                    backgroundColor: primaryColor.withOpacity(0.1),
                    child: CustomText(
                      report.employee?.name?.isNotEmpty == true ? report.employee!.name![0].toUpperCase() : "E",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                  ),
                  sizedBoxWidth(width: 8),
                  Expanded(
                    child: CustomText(
                      report.employee?.name ?? "Employee",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ],
              ),
              const Divider(),
              sizedBoxHeight(height: 4),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  report.reportDate ?? "N/A",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                _buildStatusBadge(report.status ?? ""),
              ],
            ),
            sizedBoxHeight(height: 8),
            CustomText(
              report.summary ?? "No summary",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
            ),
            sizedBoxHeight(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem(Icons.list_alt, "${report.itemsCount ?? 0} Items"),
                _buildInfoItem(Icons.percent, "${report.completionPercentage ?? 0}% Complete"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: primaryColor),
        sizedBoxWidth(width: 4),
        CustomText(text, style: TextStyle(fontSize: 12.sp)),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'submitted':
        color = Colors.blue;
        break;
      case 'manager_approved':
        color = Colors.green;
        break;
      case 'rejected':
        color = Colors.red;
        break;
      default:
        color = Colors.orange;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: CustomText(
        status.capitalizeFirst ?? status,
        style: TextStyle(color: color, fontSize: 10.sp, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: 5,
      separatorBuilder: (context, index) => sizedBoxHeight(height: 12),
      itemBuilder: (context, index) => CustomShimmer(
        isLoading: true,
        child: Container(
          height: 100.h,
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined, size: 64.sp, color: Colors.grey[300]),
          sizedBoxHeight(height: 16),
          CustomText(message, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class DailyReportDetailScreen extends StatelessWidget {
  final bool isTeamReport;
  const DailyReportDetailScreen({super.key, this.isTeamReport = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText("Report Details"),
        backgroundColor: primaryColor,
        foregroundColor: white,
      ),
      body: GetBuilder<DailyReportController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final report = controller.selectedReport;
          if (report == null) {
            return const Center(child: CustomText("Report not found"));
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isTeamReport && report.employee != null) ...[
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.person, color: primaryColor),
                              sizedBoxWidth(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(report.employee?.name ?? "", style: const TextStyle(fontWeight: FontWeight.bold)),
                                  CustomText("Code: ${report.employee?.employeeCode ?? 'N/A'}", style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        sizedBoxHeight(height: 16),
                      ],
                      _buildDetailHeader(report),
                      sizedBoxHeight(height: 20),
                      const CustomText("Summary", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      sizedBoxHeight(height: 8),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: CustomText(report.summary ?? "No summary provided"),
                      ),
                      sizedBoxHeight(height: 20),
                      CustomText("Items (${report.items?.length ?? 0})", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      sizedBoxHeight(height: 12),
                      if (report.items != null)
                        ...report.items!.map((item) => _buildItemCard(item)).toList(),
                    ],
                  ),
                ),
              ),
              if (isTeamReport && report.status?.toLowerCase() == 'submitted')
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          title: "Reject",
                          color: Colors.red,
                          borderColor: Colors.red,
                          onTap: () async {
                            final res = await controller.rejectTeamReport(report.id!);
                            if (res.isSuccess) {
                              showToast(message: res.message, toastType: ToastType.success);
                              Get.back();
                              controller.getTeamReports();
                            } else {
                              showToast(message: res.message, toastType: ToastType.error);
                            }
                          },
                        ),
                      ),
                      sizedBoxWidth(width: 12),
                      Expanded(
                        child: CustomButton(
                          title: "Approve",
                          color: Colors.green,
                          borderColor: Colors.green,
                          onTap: () async {
                            final res = await controller.approveTeamReport(report.id!);
                            if (res.isSuccess) {
                              showToast(message: res.message, toastType: ToastType.success);
                              Get.back();
                              controller.getTeamReports();
                            } else {
                              showToast(message: res.message, toastType: ToastType.error);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDetailHeader(DailyReportModel report) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow("Date", report.reportDate ?? "N/A"),
          const Divider(),
          _buildInfoRow("Status", report.status ?? "N/A"),
          const Divider(),
          _buildInfoRow("Submitted At", report.createdAt != null ? DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(report.createdAt!)) : "N/A"),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(label, style: const TextStyle(color: Colors.grey)),
          CustomText(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildItemCard(DailyReportItemModel item) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomText(
                  item.title ?? "No Title",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              _buildPriorityBadge(item.priority ?? ""),
            ],
          ),
          sizedBoxHeight(height: 4),
          CustomText(
            item.details ?? "No details",
            style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
          ),
          sizedBoxHeight(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSmallBadge(item.category ?? "General", Colors.blue),
              _buildSmallBadge(item.status ?? "N/A", Colors.orange),
              CustomText("${item.timeSpentHours}h ${item.timeSpentMinutes}m", style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityBadge(String priority) {
    Color color = Colors.grey;
    if (priority.toLowerCase() == 'high') color = Colors.red;
    if (priority.toLowerCase() == 'medium') color = Colors.orange;
    if (priority.toLowerCase() == 'low') color = Colors.green;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: CustomText(priority, style: TextStyle(color: color, fontSize: 10.sp, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSmallBadge(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: CustomText(text, style: TextStyle(color: color, fontSize: 10.sp)),
    );
  }
}

class AddDailyReportScreen extends StatefulWidget {
  const AddDailyReportScreen({super.key});

  @override
  State<AddDailyReportScreen> createState() => _AddDailyReportScreenState();
}

class _AddDailyReportScreenState extends State<AddDailyReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText("Submit Daily Report"),
        backgroundColor: primaryColor,
        foregroundColor: white,
      ),
      body: GetBuilder<DailyReportController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextFieldWithHeading(
                  heading: "Report Date",
                  controller: controller.reportDateController,
                  readOnly: true,
                  onTap: () => _selectDate(context, controller),
                  hindText: "YYYY-MM-DD",
                ),
                sizedBoxHeight(height: 16),
                AppTextFieldWithHeading(
                  heading: "Daily Summary",
                  controller: controller.summaryController,
                  maxLines: 3,
                  hindText: "Enter overall summary of the day",
                ),
                sizedBoxHeight(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText("Report Items", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    TextButton.icon(
                      onPressed: () => _showAddItemDialog(context, controller),
                      icon: const Icon(Icons.add),
                      label: const CustomText("Add Item"),
                    ),
                  ],
                ),
                sizedBoxHeight(height: 12),
                if (controller.items.isEmpty)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.w),
                      child: const CustomText("No items added yet", style: TextStyle(color: Colors.grey)),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.items.length,
                    separatorBuilder: (context, index) => sizedBoxHeight(height: 12),
                    itemBuilder: (context, index) {
                      final item = controller.items[index];
                      return Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(item.title ?? "", style: const TextStyle(fontWeight: FontWeight.bold)),
                                  CustomText("${item.category} • ${item.timeSpentHours}h ${item.timeSpentMinutes}m",
                                      style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => controller.removeItem(index),
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                sizedBoxHeight(height: 40),
                CustomButton(
                  isLoading: controller.isLoading,
                  title: "Submit Report",
                  onTap: () async {
                    if (controller.reportDateController.text.isEmpty) {
                      showToast(message: "Please select a date");
                      return;
                    }
                    if (controller.items.isEmpty) {
                      showToast(message: "Please add at least one report item");
                      return;
                    }

                    final result = await controller.submitDailyReport();
                    if (result.isSuccess) {
                      showToast(message: result.message, toastType: ToastType.success);
                      Get.back();
                      controller.getDailyReports();
                    } else {
                      showToast(message: result.message, toastType: ToastType.error);
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, DailyReportController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      controller.reportDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      controller.update();
    }
  }

  void _showAddItemDialog(BuildContext context, DailyReportController controller) {
    final titleController = TextEditingController();
    final detailsController = TextEditingController();
    final hoursController = TextEditingController();
    final minutesController = TextEditingController();
    String category = "Development";
    String status = "Completed";
    String priority = "High";
    int? selectedTaskId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 20.h,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText("Add Work Item", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    sizedBoxHeight(height: 16),
                    
                    // Task Selection (Optional)
                    const CustomText("Link to Task (Optional)", style: TextStyle(fontWeight: FontWeight.w500)),
                    sizedBoxHeight(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int?>(
                          value: selectedTaskId,
                          isExpanded: true,
                          hint: const CustomText("Select a task"),
                          items: [
                            const DropdownMenuItem<int?>(value: null, child: CustomText("None")),
                            ...controller.pendingTasks.map((task) => DropdownMenuItem<int?>(
                                  value: task.id,
                                  child: CustomText(task.title ?? "Task ${task.id}"),
                                )),
                          ],
                          onChanged: (val) {
                            setState(() {
                              selectedTaskId = val;
                              if (val != null) {
                                final task = controller.pendingTasks.firstWhere((t) => t.id == val);
                                titleController.text = task.title ?? "";
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    sizedBoxHeight(height: 16),
                    
                    AppTextFieldWithHeading(
                      heading: "Title",
                      controller: titleController,
                      hindText: "What did you work on?",
                    ),
                    sizedBoxHeight(height: 16),
                    AppTextFieldWithHeading(
                      heading: "Details",
                      controller: detailsController,
                      maxLines: 2,
                      hindText: "Provide more details",
                    ),
                    sizedBoxHeight(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CustomText("Category", style: TextStyle(fontWeight: FontWeight.w500)),
                              sizedBoxHeight(height: 8),
                              _buildDropdown(["Development", "Testing", "Documentation", "Meeting", "Support", "Training"], category, (val) {
                                setState(() => category = val!);
                              }),
                            ],
                          ),
                        ),
                        sizedBoxWidth(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CustomText("Priority", style: TextStyle(fontWeight: FontWeight.w500)),
                              sizedBoxHeight(height: 8),
                              _buildDropdown(["High", "Medium", "Low"], priority, (val) {
                                setState(() => priority = val!);
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                    sizedBoxHeight(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CustomText("Status", style: TextStyle(fontWeight: FontWeight.w500)),
                              sizedBoxHeight(height: 8),
                              _buildDropdown(["Completed", "In Progress", "On Hold"], status, (val) {
                                setState(() => status = val!);
                              }),
                            ],
                          ),
                        ),
                        sizedBoxWidth(width: 12),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: AppTextFieldWithHeading(
                                  heading: "Hours",
                                  controller: hoursController,
                                  keyboardType: TextInputType.number,
                                  hindText: "0",
                                ),
                              ),
                              sizedBoxWidth(width: 8),
                              Expanded(
                                child: AppTextFieldWithHeading(
                                  heading: "Mins",
                                  controller: minutesController,
                                  keyboardType: TextInputType.number,
                                  hindText: "0",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    sizedBoxHeight(height: 24),
                    CustomButton(
                      title: "Add to Report",
                      onTap: () {
                        if (titleController.text.isEmpty) {
                          showToast(message: "Title is required");
                          return;
                        }
                        controller.addItem(DailyReportItemModel(
                          title: titleController.text,
                          details: detailsController.text,
                          category: category,
                          status: status,
                          priority: priority,
                          timeSpentHours: int.tryParse(hoursController.text) ?? 0,
                          timeSpentMinutes: int.tryParse(minutesController.text) ?? 0,
                          taskId: selectedTaskId,
                        ));
                        Navigator.pop(context);
                      },
                    ),
                    sizedBoxHeight(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDropdown(List<String> items, String value, Function(String?) onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items.map((e) => DropdownMenuItem(value: e, child: CustomText(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
