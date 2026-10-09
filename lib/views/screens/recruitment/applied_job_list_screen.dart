import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vlr/controllers/recruitment_controller.dart';
import 'package:vlr/data/models/response/applied_job_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class AppliedJobListScreen extends StatefulWidget {
  final bool hideAppBar;
  const AppliedJobListScreen({super.key, this.hideAppBar = false});

  @override
  State<AppliedJobListScreen> createState() => _AppliedJobListScreenState();
}

class _AppliedJobListScreenState extends State<AppliedJobListScreen> {
  String selectedStatus = "all";
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  static  Color appBluePrimary = primaryColor; // 0xFF021A45
  static const Color appBlueAccent = Color(0xFF0052D9); // Vibrant Blue
  static const Color appBlueLight = Color(0xFFEFF6FF); // Light blue tint
  static const Color appBlueBorder = Color(0xFFBFDBFE); // Soft blue border
  static const Color cardBorderColor = Color(0xFFE2E8F0); // Light slate border

  final List<Map<String, String>> statusFilterOptions = [
    {"key": "all", "label": "All"},
    {"key": "applied", "label": "Applied"},
    {"key": "interview_scheduled", "label": "Interview Scheduled"},
    {"key": "selected", "label": "Selected"},
    {"key": "completed", "label": "Completed"},
    {"key": "rejected", "label": "Rejected"},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    Get.find<RecruitmentController>().getAppliedJobs();
  }

  Map<String, dynamic> _getFilterData() {
    Map<String, dynamic> filters = {};
    if (selectedStatus != "all") {
      filters['status'] = selectedStatus;
    }
    if (searchController.text.trim().isNotEmpty) {
      filters['search'] = searchController.text.trim();
      filters['job_title'] = searchController.text.trim();
    }
    return filters;
  }

  void _applyFilters() {
    Get.find<RecruitmentController>().getAppliedJobs(query: _getFilterData());
  }

  List<AppliedJobModel> _filterLocally(List<AppliedJobModel> list) {
    String query = searchController.text.trim().toLowerCase();
    return list.where((item) {
      // Status filter
      bool statusMatches = selectedStatus == "all" ||
          (item.status?.toLowerCase() == selectedStatus.toLowerCase());

      // Search filter
      bool searchMatches = query.isEmpty ||
          (item.displayJobTitle.toLowerCase().contains(query)) ||
          (item.displayApplicantName.toLowerCase().contains(query)) ||
          (item.displayApplicantMobile.toLowerCase().contains(query)) ||
          (item.displayApplicantEmail.toLowerCase().contains(query)) ||
          (item.displayJobCode.toLowerCase().contains(query)) ||
          (item.designation != null && item.designation!.toLowerCase().contains(query));

      return statusMatches && searchMatches;
    }).toList();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String? urlStr) async {
    if (urlStr == null || urlStr.isEmpty) {
      showToast(message: "Resume URL not available", toastType: ToastType.warning);
      return;
    }
    try {
      final Uri uri = Uri.parse(urlStr);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      showToast(message: "Could not open resume link", toastType: ToastType.error);
    }
  }

  Future<void> _makePhoneCall(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) return;
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      }
    } catch (_) {}
  }

  Future<void> _sendWhatsApp(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) return;
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (!cleanNumber.startsWith('91') && cleanNumber.length == 10) {
      cleanNumber = '91$cleanNumber';
    }
    final Uri whatsappUri = Uri.parse("https://wa.me/$cleanNumber");
    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: widget.hideAppBar
          ? null
          : AppBar(
              title: CustomText(
                "Applied Candidates",
                style: Helper(context).textTheme.titleMedium?.copyWith(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                      color: appBluePrimary,
                    ),
              ),
              centerTitle: true,
              backgroundColor: white,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: Container(
                margin: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: appBlueLight,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon:  Icon(Icons.arrow_back_rounded, color: appBluePrimary, size: 20),
                  onPressed: () => pop(context),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1.0),
                child: Container(
                  color: cardBorderColor,
                  height: 1.0,
                ),
              ),
            ),
      body: GetBuilder<RecruitmentController>(builder: (controller) {
        final filteredList = _filterLocally(controller.appliedJobList);

        return RefreshIndicator(
          color: appBlueAccent,
          onRefresh: () async {
            _applyFilters();
          },
          child: Column(
            children: [
              _buildFilterAndSearchBar(controller),
              Expanded(
                child: controller.isAppliedJobsLoading && controller.appliedJobList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(color: appBlueAccent),
                            sizedBoxHeight(height: 14),
                            CustomText(
                              "Loading applied jobs...",
                              style: TextStyle(fontSize: 13.sp, color: greyText),
                            ),
                          ],
                        ),
                      )
                    : filteredList.isEmpty
                        ? Center(
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Padding(
                                padding: EdgeInsets.all(24.r),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(20.r),
                                      decoration: const BoxDecoration(
                                        color: appBlueLight,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.person_search_rounded,
                                        size: 54.r,
                                        color: appBlueAccent,
                                      ),
                                    ),
                                    sizedBoxHeight(height: 16),
                                    CustomText(
                                      "No Applied Candidates Found",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: appBluePrimary,
                                      ),
                                    ),
                                    sizedBoxHeight(height: 6),
                                    CustomText(
                                      selectedStatus != "all" || searchController.text.isNotEmpty
                                          ? "Try adjusting your search query or filter"
                                          : "Applications submitted by candidates will appear here",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 12.sp, color: greyText),
                                    ),
                                    if (selectedStatus != "all" || searchController.text.isNotEmpty) ...[
                                      sizedBoxHeight(height: 16),
                                      OutlinedButton.icon(
                                        onPressed: () {
                                          setState(() {
                                            selectedStatus = "all";
                                            searchController.clear();
                                          });
                                          _applyFilters();
                                        },
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(color: appBlueAccent),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.r),
                                          ),
                                        ),
                                        icon: Icon(Icons.refresh_rounded, color: appBlueAccent, size: 16),
                                        label: Text("Reset Filters", style: TextStyle(color: appBlueAccent)),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: filteredList.length,
                            separatorBuilder: (_, __) => sizedBoxHeight(height: 14.h),
                            itemBuilder: (context, index) {
                              final item = filteredList[index];
                              return _buildAppliedCandidateCard(context, item);
                            },
                          ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildFilterAndSearchBar(RecruitmentController controller) {
    return Container(
      color: white,
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
      child: Column(
        children: [
          // Search Input
          AppTextFieldWithHeading(
            controller: searchController,
            hindText: "Search candidate, role, mobile, job code...",
            bgColor: const Color(0xFFF8FAFC),
            borderColor: cardBorderColor,
            preFixWidget: Icon(Icons.search_rounded, color: appBlueAccent, size: 20),
            suffix: searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, size: 18, color: Color(0xFF434654)),
                    onPressed: () {
                      searchController.clear();
                      setState(() {});
                      _applyFilters();
                    },
                  )
                : null,
            onChanged: (val) {
              setState(() {});
              if (_debounce?.isActive ?? false) _debounce!.cancel();
              _debounce = Timer(const Duration(milliseconds: 400), () {
                _applyFilters();
              });
            },
          ),
          sizedBoxHeight(height: 10),

          // Horizontal Status Chips
          SizedBox(
            height: 36.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: statusFilterOptions.length,
              separatorBuilder: (_, __) => sizedBoxWidth(width: 8.w),
              itemBuilder: (context, index) {
                final opt = statusFilterOptions[index];
                final bool isSelected = selectedStatus == opt['key'];

                return GestureDetector(
                  onTap: () {
                    setState(() => selectedStatus = opt['key']!);
                    _applyFilters();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: isSelected ? appBluePrimary : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: isSelected ? appBluePrimary : cardBorderColor,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        opt['label']!,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? Colors.white : blackText1,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppliedCandidateCard(BuildContext context, AppliedJobModel item) {
    final String initial = (item.displayApplicantName.isNotEmpty)
        ? item.displayApplicantName[0].toUpperCase()
        : "A";

    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cardBorderColor),
        boxShadow: [
          BoxShadow(
            color: appBluePrimary.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar, Name, Role & Status
          Padding(
            padding: EdgeInsets.all(14.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Applicant Avatar
                Container(
                  width: 46.r,
                  height: 46.r,
                  decoration: BoxDecoration(
                    color: appBlueLight,
                    shape: BoxShape.circle,
                    border: Border.all(color: appBlueBorder),
                  ),
                  child: ClipOval(
                    child: item.displayApplicantImage != null && item.displayApplicantImage!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: item.displayApplicantImage!,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Center(
                              child: Text(
                                initial,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: appBlueAccent,
                                ),
                              ),
                            ),
                            errorWidget: (_, __, ___) => Center(
                              child: Text(
                                initial,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: appBlueAccent,
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: Text(
                              initial,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: appBlueAccent,
                              ),
                            ),
                          ),
                  ),
                ),
                sizedBoxWidth(width: 12),

                // Name & Applied Role
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        item.displayApplicantName,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: appBluePrimary,
                        ),
                      ),
                      sizedBoxHeight(height: 2),
                      CustomText(
                        item.designation ?? item.displayJobTitle,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: appBlueAccent,
                        ),
                      ),
                      if (item.displayApplicantMobile.isNotEmpty || item.displayCity.isNotEmpty) ...[
                        sizedBoxHeight(height: 4),
                        Row(
                          children: [
                            if (item.displayApplicantMobile.isNotEmpty) ...[
                              Icon(Icons.phone_outlined, size: 12.sp, color: greyText),
                              sizedBoxWidth(width: 4),
                              CustomText(
                                item.displayApplicantMobile,
                                style: TextStyle(fontSize: 11.sp, color: const Color(0xFF434654)),
                              ),
                              sizedBoxWidth(width: 10),
                            ],
                            if (item.displayCity.isNotEmpty) ...[
                              Icon(Icons.location_on_outlined, size: 12.sp, color: greyText),
                              sizedBoxWidth(width: 3),
                              Expanded(
                                child: CustomText(
                                  item.displayCity,
                                  style: TextStyle(fontSize: 11.sp, color: const Color(0xFF434654)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                sizedBoxWidth(width: 6),
                _buildStatusBadge(item.status),
              ],
            ),
          ),

          // Job Post Tag Banner
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              border: Border(
                top: BorderSide(color: cardBorderColor, width: 0.8),
                bottom: BorderSide(color: cardBorderColor, width: 0.8),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.business_center_outlined, size: 14.sp, color: appBlueAccent),
                sizedBoxWidth(width: 6),
                Expanded(
                  child: CustomText(
                    "Job: ${item.displayJobTitle}${item.displayJobCode.isNotEmpty ? ' (${item.displayJobCode})' : ''}",
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: blackText1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (item.displayBranchName.isNotEmpty) ...[
                  sizedBoxWidth(width: 6),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: appBlueLight,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: CustomText(
                      item.displayBranchName,
                      style: TextStyle(fontSize: 10.sp, color: appBlueAccent, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Details Grid (Salary, Education, Experience, Applied Date)
          Padding(
            padding: EdgeInsets.all(14.r),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildMetaCell(
                      "Offered Salary",
                      item.displaySalary,
                      Icons.payments_outlined,
                      isAccent: true,
                    ),
                    _buildMetaCell(
                      "Education",
                      item.educationLevel ?? item.jobPost?.minimumEducation ?? "Not Specified",
                      Icons.school_outlined,
                    ),
                  ],
                ),
                sizedBoxHeight(height: 10),
                Row(
                  children: [
                    _buildMetaCell(
                      "Experience",
                      item.experienceYears != null ? "${item.experienceYears} Years" : (item.jobPost?.experience ?? "Fresher / Any"),
                      Icons.work_history_outlined,
                    ),
                    _buildMetaCell(
                      "Applied Date",
                      _formatDate(item.createdAt),
                      Icons.calendar_today_outlined,
                    ),
                  ],
                ),

                if (item.remark != null && item.remark!.isNotEmpty) ...[
                  sizedBoxHeight(height: 10),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: cardBorderColor),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.notes_rounded, size: 14.sp, color: greyText),
                        sizedBoxWidth(width: 6),
                        Expanded(
                          child: CustomText(
                            "Remark: ${item.remark}",
                            style: TextStyle(fontSize: 11.sp, color: const Color(0xFF434654)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                sizedBoxHeight(height: 14),

                // Action Buttons Bar
                Row(
                  children: [
                    // Resume Button
                    if (item.resumeUrl != null && item.resumeUrl!.isNotEmpty) ...[
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _launchURL(item.resumeUrl),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: appBlueAccent),
                            backgroundColor: appBlueLight,
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          icon: Icon(Icons.picture_as_pdf_rounded, color: appBlueAccent, size: 16.sp),
                          label: CustomText(
                            "Resume",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: appBlueAccent,
                            ),
                          ),
                        ),
                      ),
                      sizedBoxWidth(width: 8),
                    ],

                    // Call & WhatsApp quick icon buttons
                    if (item.displayApplicantMobile.isNotEmpty) ...[
                      _buildCircleIconButton(
                        icon: Icons.phone_rounded,
                        color: const Color(0xFF16A34A),
                        bgColor: const Color(0xFFDCFCE7),
                        onTap: () => _makePhoneCall(item.displayApplicantMobile),
                      ),
                      sizedBoxWidth(width: 6),
                      _buildCircleIconButton(
                        icon: Icons.chat_rounded,
                        color: const Color(0xFF0D9488),
                        bgColor: const Color(0xFFCCFBF1),
                        onTap: () => _sendWhatsApp(item.displayApplicantMobile),
                      ),
                      sizedBoxWidth(width: 8),
                    ],

                    // Update Status Button
                    Expanded(
                      flex: 1,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (item.id != null) {
                            _showStatusUpdateDialog(context, item);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appBluePrimary,
                          padding: EdgeInsets.symmetric(vertical: 9.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          elevation: 0,
                        ),
                        icon: Icon(Icons.edit_calendar_rounded, color: Colors.white, size: 15.sp),
                        label: CustomText(
                          "Update Status",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaCell(String label, String value, IconData icon, {bool isAccent = false}) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 14.sp, color: isAccent ? appBlueAccent : greyText),
          sizedBoxWidth(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  label,
                  style: TextStyle(fontSize: 10.sp, color: greyText, fontWeight: FontWeight.w500),
                ),
                CustomText(
                  value,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: isAccent ? FontWeight.w700 : FontWeight.w600,
                    color: isAccent ? appBlueAccent : blackText1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleIconButton({
    required IconData icon,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon, color: color, size: 18.sp),
      ),
    );
  }

  void _showStatusUpdateDialog(BuildContext context, AppliedJobModel item) {
    String currentStatus = item.status?.toLowerCase() == 'rejected' ? 'rejected' : 'selected';
    final List<Map<String, dynamic>> statusOptions = [
      {'value': 'selected', 'label': 'Shortlist', 'icon': Icons.verified_outlined, 'color': const Color(0xFF0D9488)},
      {'value': 'rejected', 'label': 'Reject', 'icon': Icons.cancel_outlined, 'color': const Color(0xFFDC2626)},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
              ),
              padding: EdgeInsets.fromLTRB(
                20.w,
                16.h,
                20.w,
                MediaQuery.of(context).viewInsets.bottom + 24.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  sizedBoxHeight(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            "Update Application Status",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: appBluePrimary,
                            ),
                          ),
                          sizedBoxHeight(height: 2),
                          CustomText(
                            item.displayApplicantName,
                            style: TextStyle(fontSize: 12.sp, color: greyText, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close_rounded, color: Color(0xFF434654)),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  sizedBoxHeight(height: 16),
                  ...statusOptions.map((opt) {
                    final bool isSelected = currentStatus == opt['value'];
                    final Color optColor = opt['color'] as Color;

                    return GestureDetector(
                      onTap: () {
                        setModalState(() {
                          currentStatus = opt['value']!;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10.h),
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: isSelected ? appBlueLight : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: isSelected ? appBlueAccent : cardBorderColor,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(6.r),
                              decoration: BoxDecoration(
                                color: optColor.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(opt['icon'] as IconData, size: 16.r, color: optColor),
                            ),
                            sizedBoxWidth(width: 12),
                            Expanded(
                              child: Text(
                                opt['label']!,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  color: isSelected ? appBluePrimary : blackText1,
                                ),
                              ),
                            ),
                            Icon(
                              isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                              color: isSelected ? appBlueAccent : const Color(0xFFCBD5E1),
                              size: 20.r,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  sizedBoxHeight(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Get.find<RecruitmentController>()
                            .updateAppliedJobStatus(item.id!, currentStatus)
                            .then((res) {
                          if (res.isSuccess) {
                            showToast(message: res.message, toastType: ToastType.success);
                          } else {
                            showToast(message: res.message, toastType: ToastType.error);
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appBluePrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Save Status",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "N/A";
    try {
      DateTime dt = DateTime.parse(dateStr).toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
    } catch (e) {
      return dateStr.split("T")[0];
    }
  }

  Widget _buildStatusBadge(String? status) {
    Color color;
    String text;
    switch (status?.toLowerCase()) {
      case 'applied':
        color = const Color(0xFF2563EB);
        text = 'Applied';
        break;
      case 'interview_scheduled':
        color = const Color(0xFFD97706);
        text = 'Interview Scheduled';
        break;
      case 'selected':
        color = const Color(0xFF0D9488);
        text = 'Selected';
        break;
      case 'completed':
        color = const Color(0xFF16A34A);
        text = 'Completed';
        break;
      case 'rejected':
        color = const Color(0xFFDC2626);
        text = 'Rejected';
        break;
      default:
        color = const Color(0xFF64748B);
        text = capitalize(status?.replaceAll("_", " ") ?? "Unknown");
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: CustomText(
        text,
        style: TextStyle(fontSize: 10.sp, color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}
