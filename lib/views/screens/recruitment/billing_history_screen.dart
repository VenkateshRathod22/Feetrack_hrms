import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vlr/controllers/recruitment_controller.dart';
import 'package:vlr/data/models/response/job_post_history_model.dart';
import 'package:vlr/services/constants.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/widget/text_box/app_text_box.dart';

class BillingHistoryScreen extends StatefulWidget {
  final bool hideAppBar;
  const BillingHistoryScreen({super.key, this.hideAppBar = false});

  @override
  State<BillingHistoryScreen> createState() => _BillingHistoryScreenState();
}

class _BillingHistoryScreenState extends State<BillingHistoryScreen> {
  final TextEditingController searchController = TextEditingController();
  String selectedStatus = "All";

  final List<String> statusFilterOptions = [
    "All",
    "active",
    "draft",
    "expired",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<RecruitmentController>().getJobPostsHistory();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  String _stripHtml(String? htmlString) {
    if (htmlString == null || htmlString.isEmpty) return "";
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '').trim();
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "N/A";
    try {
      DateTime dt = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy').format(dt);
    } catch (e) {
      return dateStr.split("T")[0];
    }
  }

  List<JobPostHistoryModel> _getFilteredHistory(List<JobPostHistoryModel> historyList) {
    return historyList.where((item) {
      bool matchesStatus = selectedStatus == "All" ||
          (item.status != null && item.status!.toLowerCase() == selectedStatus.toLowerCase());

      String query = searchController.text.trim().toLowerCase();
      bool matchesSearch = query.isEmpty ||
          (item.jobTitle != null && item.jobTitle!.toLowerCase().contains(query)) ||
          (item.jobCode != null && item.jobCode!.toLowerCase().contains(query)) ||
          (item.jobCity != null && item.jobCity!.toLowerCase().contains(query));

      return matchesStatus && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: widget.hideAppBar
          ? null
          : AppBar(
              backgroundColor: white,
              elevation: 0.5,
              title: CustomText(
                "Job Post & Billing History",
                style: Helper(context).textTheme.titleMedium?.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: blackText1,
                    ),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: black),
                onPressed: () => pop(context),
              ),
            ),
      body: GetBuilder<RecruitmentController>(builder: (controller) {
        final filteredList = _getFilteredHistory(controller.jobPostsHistoryList);

        return RefreshIndicator(
          onRefresh: () async {
            await controller.getJobPostsHistory();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Input
                AppTextFieldWithHeading(
                  controller: searchController,
                  heading: "Search History",
                  hindText: "Search by job title or code...",
                  preFixWidget: Icon(Icons.search, color: greyText),
                  onChanged: (val) {
                    setState(() {});
                  },
                ),
                sizedBoxHeight(height: 12),

                // Status Filter Chips
                SizedBox(
                  height: 38.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: statusFilterOptions.length,
                    separatorBuilder: (_, __) => sizedBoxWidth(width: 8.w),
                    itemBuilder: (context, index) {
                      final status = statusFilterOptions[index];
                      final isSelected = selectedStatus == status;
                      return ChoiceChip(
                        label: Text(capitalize(status)),
                        selected: isSelected,
                        selectedColor: secondaryColor.withValues(alpha: 0.15),
                        backgroundColor: white,
                        labelStyle: TextStyle(
                          color: isSelected ? secondaryColor : blackText1,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 12.sp,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                          side: BorderSide(
                            color: isSelected ? secondaryColor : greyLight2,
                          ),
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => selectedStatus = status);
                          }
                        },
                      );
                    },
                  ),
                ),
                sizedBoxHeight(height: 16),

                // Content Section
                if (controller.isJobPostsHistoryLoading && controller.jobPostsHistoryList.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 80.h),
                    child: const Center(child: CircularProgressIndicator()),
                  )
                else if (filteredList.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 80.h),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.history_outlined, size: 50.r, color: greyText),
                          sizedBoxHeight(height: 12),
                          CustomText(
                            "No job posting history found",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: greyDart2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredList.length,
                    separatorBuilder: (_, __) => sizedBoxHeight(height: 16),
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      return _buildHistoryCard(context, item);
                    },
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHistoryCard(BuildContext context, JobPostHistoryModel item) {
    String cleanDesc = _stripHtml(item.jobDescription);

    String minSalaryFormatted = item.salaryMin != null
        ? PriceConverter.convertRound(item.salaryMin!)
        : "N/A";
    String maxSalaryFormatted = item.salaryMax != null
        ? PriceConverter.convertRound(item.salaryMax!)
        : "N/A";

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Title, Code & Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      item.jobTitle ?? "N/A",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: blackText1,
                      ),
                    ),
                    if (item.jobCode != null && item.jobCode!.isNotEmpty) ...[
                      sizedBoxHeight(height: 2),
                      CustomText(
                        item.jobCode!,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              sizedBoxWidth(width: 8),
              _buildStatusBadge(item.status),
            ],
          ),
          sizedBoxHeight(height: 12),

          // Job Details Grid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoTile("Employment", item.employmentType ?? "N/A"),
              _infoTile("Shift Type", item.jobType ?? "N/A"),
              _infoTile("Vacancies", "${item.vacanciesCount ?? 1}"),
            ],
          ),
          sizedBoxHeight(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoTile("Salary", "$minSalaryFormatted - $maxSalaryFormatted"),
              _infoTile("City", item.jobCity != null && item.jobCity!.isNotEmpty ? capitalize(item.jobCity) : "N/A"),
              _infoTile("Applications", "${item.applicationsCount ?? 0}"),
            ],
          ),
          sizedBoxHeight(height: 12),

          // Description preview if available
          if (cleanDesc.isNotEmpty) ...[
            CustomText(
              cleanDesc,
              style: TextStyle(fontSize: 12.sp, color: greyText, height: 1.4),
              maxLines: 2,
            ),
            sizedBoxHeight(height: 10),
          ],

          // Additional Perks
          if (item.additionalPerks != null && item.additionalPerks!.isNotEmpty) ...[
            Wrap(
              spacing: 6.w,
              runSpacing: 6.h,
              children: item.additionalPerks!.map((perk) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: secondaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: CustomText(
                    "• $perk",
                    style: TextStyle(fontSize: 10.sp, color: secondaryColor, fontWeight: FontWeight.w600),
                  ),
                );
              }).toList(),
            ),
            sizedBoxHeight(height: 10),
          ],

          // Payment & Billing Summary Box
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: backgroundLight,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: greyLight2),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      "Wallet Deducted:",
                      style: TextStyle(fontSize: 12.sp, color: greyText),
                    ),
                    CustomText(
                      PriceConverter.convert(item.walletDeducted ?? "0"),
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: blackText1),
                    ),
                  ],
                ),
                sizedBoxHeight(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      "Online Payable:",
                      style: TextStyle(fontSize: 12.sp, color: greyText),
                    ),
                    CustomText(
                      PriceConverter.convert(item.onlinePayable ?? "0"),
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: primaryColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
          sizedBoxHeight(height: 12),

          // Footer Dates
          const Divider(),
          sizedBoxHeight(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                "Posted: ${_formatDate(item.createdAt)}",
                style: TextStyle(fontSize: 10.sp, color: greyText),
              ),
              if (item.expiresAt != null && item.expiresAt!.isNotEmpty)
                CustomText(
                  "Expires: ${_formatDate(item.expiresAt)}",
                  style: TextStyle(fontSize: 10.sp, color: Colors.orange[800], fontWeight: FontWeight.w600),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(label, style: TextStyle(fontSize: 10.sp, color: greyText)),
          sizedBoxHeight(height: 2),
          CustomText(
            value,
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: blackText1),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String? status) {
    Color color;
    String text;
    switch (status?.toLowerCase()) {
      case 'active':
        color = Colors.green;
        text = 'Active';
        break;
      case 'draft':
        color = Colors.orange;
        text = 'Draft';
        break;
      case 'expired':
        color = Colors.red;
        text = 'Expired';
        break;
      default:
        color = Colors.grey;
        text = capitalize(status ?? "Unknown");
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: CustomText(
        text,
        style: TextStyle(fontSize: 11.sp, color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
