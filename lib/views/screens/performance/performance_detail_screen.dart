import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/staff_contoller.dart';
import 'package:vlr/data/models/performance_detail_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/base/custom_image.dart';

class PerformanceDetailScreen extends StatefulWidget {
  final String employeeId;
  const PerformanceDetailScreen({super.key, required this.employeeId});

  @override
  State<PerformanceDetailScreen> createState() => _PerformanceDetailScreenState();
}

class _PerformanceDetailScreenState extends State<PerformanceDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<StaffController>().getPerformanceStaffDetail(widget.employeeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          "Performance Insights",
          style: Helper(context).textTheme.titleMedium?.copyWith(
                color: white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon:  Icon(Icons.arrow_back_ios_new_rounded, color: white),
        ),
      ),
      body: GetBuilder<StaffController>(builder: (staffController) {
        if (staffController.isLoading || staffController.performanceDetail == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final detail = staffController.performanceDetail!;
        final employee = detail.employee;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.all(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Employee Profile Section
              _buildModernProfileCard(context, employee),
              sizedBoxHeight(height: 24),

              /// Performance Summary Stats
              CustomText(
                "Key Metrics",
                style: Helper(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
              ),
              sizedBoxHeight(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  _buildStatCard("Total Present", "${detail.stats?.totalPresent ?? 0}", Icons.calendar_today_rounded, Colors.blue),
                  _buildStatCard("Late Marks", "${detail.stats?.lateMarks ?? 0}", Icons.access_time_rounded, Colors.orange),
                  _buildStatCard("Completed", "${detail.stats?.tasksCompleted ?? 0}", Icons.task_alt_rounded, Colors.green),
                  _buildStatCard("Total Tasks", "${detail.stats?.totalTasks ?? 0}", Icons.assignment_rounded, Colors.purple),
                ],
              ),
              sizedBoxHeight(height: 12),
              _buildFullWidthStatCard("Leaves Taken", "${detail.stats?.leavesTaken ?? 0}", Icons.exit_to_app_rounded, Colors.red),
              
              sizedBoxHeight(height: 32),

              /// Performance Weights Section
              _buildSectionHeader(context, "Performance Distribution"),
              sizedBoxHeight(height: 16),
              _buildWeightDistributionCard(context, detail.weights),
              
              sizedBoxHeight(height: 32),

              /// Monthly Performance History
              _buildSectionHeader(context, "Monthly History — 2026"),
              sizedBoxHeight(height: 16),
              _buildModernDataTable(context, detail),
              
              sizedBoxHeight(height: 32),

              /// Presets Section
              _buildSectionHeader(context, "Available Strategy Presets"),
              sizedBoxHeight(height: 16),
              _buildPresetsList(context, detail.presets),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildModernProfileCard(BuildContext context, dynamic employee) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CustomImage(
                path: employee?.avatarUrl ?? "",
                height: 80.h,
                width: 80.w,
                radius: 24.r,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  height: 14,
                  width: 14,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          sizedBoxWidth(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  employee?.name ?? "N/A",
                  style: Helper(context).textTheme.titleMedium?.copyWith(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                ),
                CustomText(
                  employee?.designation ?? "N/A",
                  style: Helper(context).textTheme.bodyMedium?.copyWith(
                        color: greyDart2,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                sizedBoxHeight(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: CustomText(
                    "ID: ${employee?.employeeCode ?? "N/A"}",
                    style: Helper(context).textTheme.labelSmall?.copyWith(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withValues(alpha: 0.1), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                value,
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w800, color: color, letterSpacing: -1),
              ),
              CustomText(
                label,
                style: TextStyle(fontSize: 11.sp, color: greyDart2, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFullWidthStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 16.r),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withValues(alpha: 0.1), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12.r)),
            child: Icon(icon, color: color, size: 24),
          ),
          sizedBoxWidth(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                label,
                style: TextStyle(fontSize: 12.sp, color: greyDart2, fontWeight: FontWeight.w600),
              ),
              CustomText(
                value,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: color),
              ),
            ],
          ),
          const Spacer(),
          Icon(Icons.trending_down_rounded, color: color.withValues(alpha: 0.5), size: 20),
        ],
      ),
    );
  }

  Widget _buildWeightDistributionCard(BuildContext context, dynamic weights) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          _buildProgressWeightRow(context, "Attendance", weights?.attendance, Colors.blue),
          _buildProgressWeightRow(context, "Tasks", weights?.tasks, Colors.green),
          _buildProgressWeightRow(context, "Merchant Target", weights?.merchantTarget, Colors.orange),
          _buildProgressWeightRow(context, "Monthly Target", weights?.monthlyTarget, Colors.purple),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(thickness: 1, color: Color(0xFFF1F5F9)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText("Total Aggregate", style: Helper(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(10.r)),
                child: CustomText("${weights?.total ?? 0}%", style:  TextStyle(color: white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressWeightRow(BuildContext context, String label, int? value, Color color) {
    double progress = (value ?? 0) / 100;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(label, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: const Color(0xFF475569))),
              CustomText("${value ?? 0}%", style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          sizedBoxHeight(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernDataTable(BuildContext context, dynamic detail) {
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            horizontalMargin: 20,
            columnSpacing: 24.w,
            headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
            headingTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.sp, color: primaryColor),
            columns: const [
              DataColumn(label: Text("Month")),
              DataColumn(label: Text("Atten.")),
              DataColumn(label: Text("Tasks")),
              DataColumn(label: Text("Merch.")),
              DataColumn(label: Text("Month.")),
              DataColumn(label: Text("Total")),
              DataColumn(label: Text("Grade")),
            ],
            rows: (detail.monthlyPerformance ?? []).isEmpty
                ? [
                    const DataRow(cells: [
                      DataCell(Text("Jan")),
                      DataCell(Text("0")),
                      DataCell(Text("0")),
                      DataCell(Text("0")),
                      DataCell(Text("0")),
                      DataCell(Text("0")),
                      DataCell(Text("-")),
                    ])
                  ]
                : detail.monthlyPerformance!.map<DataRow>((p) {
                    return DataRow(cells: [
                      DataCell(Text(p.month ?? "", style: const TextStyle(fontWeight: FontWeight.w600))),
                      DataCell(Text("${p.attendance ?? 0}")),
                      DataCell(Text("${p.tasks ?? 0}")),
                      DataCell(Text("${p.merchantTarget ?? 0}")),
                      DataCell(Text("${p.monthlyTarget ?? 0}")),
                      DataCell(Text("${p.totalScore ?? 0}", style: const TextStyle(fontWeight: FontWeight.bold))),
                      DataCell(_buildGradeBadge(p.grade)),
                    ]);
                  }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildGradeBadge(String? grade) {
    Color color = Colors.grey;
    if (grade == 'A' || grade == 'A+') color = Colors.green;
    if (grade == 'B') color = Colors.blue;
    if (grade == 'C') color = Colors.orange;
    if (grade == 'D' || grade == 'F') color = Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
      child: Text(grade ?? "-", style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  Widget _buildPresetsList(BuildContext context, List<PerformancePreset>? presets) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: presets?.length ?? 0,
      separatorBuilder: (_, __) => sizedBoxHeight(height: 12),
      itemBuilder: (context, index) {
        final preset = presets![index];
        return Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFFF1F5F9)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      preset.name ?? "Strategy Preset",
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp, color: const Color(0xFF1E293B)),
                    ),
                    sizedBoxHeight(height: 8),
                    Row(
                      children: [
                        _buildPresetChip("A: ${preset.weights?.attendance}%", Colors.blue),
                        sizedBoxWidth(width: 8),
                        _buildPresetChip("T: ${preset.weights?.tasks}%", Colors.green),
                        sizedBoxWidth(width: 8),
                        _buildPresetChip("M: ${preset.weights?.merchantTarget}%", Colors.orange),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPresetChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(4)),
      child: Text(text, style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold, color: color)),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          title,
          style: Helper(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 16.sp,
                color: const Color(0xFF1E293B),
              ),
        ),
        Icon(Icons.info_outline_rounded, size: 18, color: greyDart2),
      ],
    );
  }
}
